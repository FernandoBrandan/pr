---
title: eureka-client.ts
description: eureka-client.ts
---

```yml
# docker-compose
services:
  eureka-server:
    image: steeltoeoss/eureka-server
    container_name: eureka_service
    ports:
      - "8761:8761"
    environment:
      - EUREKA_CLIENT_REGISTERWITH_EUREKA=false
      - EUREKA_CLIENT_FETCHREGISTRY=false
    networks:
      - api-network
```

```ts
// ./getConfig
import Consul from "consul"

export const consul = new Consul({
  host: process.env.CONSUL_HOST || "localhost"
})
export async function getConfig(serviceName: string) {
  const result = await consul.kv.get(`config/${serviceName}`)
  if (!result || !result.Value) {
    throw new Error(`No config found for ${serviceName}`)
  }
  return JSON.parse(result.Value as string)
}
```

```ts
// ./eureka-client.ts
import { Eureka } from "eureka-js-client"
import { getConfig } from "./getConfig";

(async () => {
  const config = await getConfig("orderServiceAsync")
  const client = new Eureka({
    instance: {
      app: "orderServiceAsync",
      hostName: "orderServiceAsync",
      ipAddr: "orderServiceAsync",
      port: {
        $: config.port,
        "@enabled": true,
      },
      vipAddress: "orderServiceAsync",
      dataCenterInfo: {
        "@class": "com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo",
        name: "MyOwn",
      },
    },
    eureka: {
      host: process.env.EUREKA_SERVER || "0.0.0.0",
      port: 8761,
      servicePath: "/eureka/apps/",
    },
  })

  client.start((error: any) => {
    if (error) console.error("Eureka registration failed:", error)
    else console.log("📍 orderServiceAsync service registered in Eureka")
  })
})()

```

```ts
// ./index.ts

import "./eureka-client"
import { getConfig } from "./getConfig"

async function main() {
  const app = express() 
  const config = await getConfig("orderServiceAsync")
  const port = process.env.PORT ? parseInt(process.env.PORT, 10) : config.PORT 

  app.listen(port, () => {
    console.log(`orderServiceAsync - Server listening on http://localhost:${port}`)
  })
}
main().catch(err => {
  console.error('Failed to start server:', err)
})
```