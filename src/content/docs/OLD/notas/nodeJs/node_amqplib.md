---
title: node:amqplib
description: producer/consumer message amqplib 
---

## producer

```js
// producer.ts
import amqp from 'amqplib'
const RABBITMQ_URL = process.env.RABBITMQ_URL as string
const ERROR_QUEUE = 'ERROR_QUEUE'

export const rabbtimq = async (message: any[]): Promise<void> => {
  const QUEUE = 'ORDERSERVICE'
  try {
    const connection = await amqp.connect(RABBITMQ_URL)
    const channel = await connection.createChannel()
    await channel.assertQueue(QUEUE, { durable: true })

    // Generar un ID único para correlacionar la respuesta
    const correlationId = Math.floor(Math.random() * 1000000).toString()
    // Crear una cola temporal para esperar la respuesta
    const replyQueue = await channel.assertQueue('', { exclusive: true })
    // Esperar por la respuesta en la cola temporal

    // eslint-disable-next-line no-async-promise-executor
    return new Promise(async (resolve, reject) => {
      const onMessage = async (msg: amqp.ConsumeMessage | null) => {
        if (!msg) return

        console.log(`📩 Message received from queue: ${msg.fields.exchange || QUEUE}`)

        if (msg.properties.correlationId === correlationId) {
          const response = JSON.parse(msg.content.toString())

          if (msg.fields.routingKey === ERROR_QUEUE) {
            console.error('❌ Error response received:', response)
            response.routingKey = ERROR_QUEUE
            reject(response)
          } else {
            response.routingKey = QUEUE
            console.log('✅ Valid response received:', response)
            resolve(response)
          }

          await channel!.cancel(consumer.consumerTag)
        }
      }

      const consumer = await channel!.consume(replyQueue.queue, onMessage, { noAck: true })

      // Enviar mensaje
      channel!.sendToQueue(QUEUE, Buffer.from(JSON.stringify(message)), {
        persistent: true,
        correlationId,
        replyTo: replyQueue.queue
      })
      console.log('📤 Message sent to RabbitMQ!')
    })
  } catch (error) {
    console.error('Failed to send message to RabbitMQ:', error)
    throw new Error('Failed to send message to RabbitMQ')
  }
}

```

## Consumer

```js
import amqp from 'amqplib'
import { BookService } from '../Services/bookService'
const RABBITMQ_URL = process.env.RABBITMQ_URL as string
const QUEUE = ''
const ERROR_QUEUE = 'ERROR_QUEUE'
export const consumeMessages = async (): Promise<void> => {
    try {
        const connection = await amqp.connect(RABBITMQ_URL)
        const channel = await connection.createChannel()
        await channel.assertQueue(QUEUE, { durable: true })
        console.log(`Connected to RabbitMQ! Waiting for messages in ${QUEUE}. To exit press CTRL+C`)
        channel.consume(QUEUE, async (msg) => {
            if (msg) {
                console.log(`Received message: ${msg.content.toString()}`)
                const data = JSON.parse(msg.content.toString())
                try {
                    const response = await BookService.checkIfItemsExist(data)
                    if (msg.properties.replyTo) {
                        channel.sendToQueue(msg.properties.replyTo, Buffer.from(JSON.stringify({ response, message: 'From api-books consumeMessages' })), {
                            correlationId: msg.properties.correlationId
                        })
                    }
                } catch (error) {
                    const errorMessage = { // Enviar mensaje de error a una cola de errores
                        error,
                        originalMessage: 'Error processing order',
                        timestamp: new Date().toISOString()
                    }
                    channel.sendToQueue(ERROR_QUEUE, Buffer.from(JSON.stringify(errorMessage)), { persistent: true })
                }
                channel.ack(msg)// mensaje procesado
            }
        }, { noAck: false })
    } catch (error) {
        console.error('Failed to connect to RabbitMQ:', error)
        throw error
    }
}
```
