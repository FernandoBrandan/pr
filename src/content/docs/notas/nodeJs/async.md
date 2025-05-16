---
title: Async
description: Async
---

## Estados
- Pendiente: El estado inicial, ni cumplido ni rechazado.
- Cumplido: La operación se completó con éxito.
- Rechazado: La operación falló.

## Fn

- resolver: Una función que se llama cuando la operación asíncrona es exitosa.
- rechazar: Una función que se llama cuando falla la operación asíncrona.

```js
// Basico 
const fs = require('fs');
fs.leerArchivo('ejemplo.txt', 'utf8', (err, datos) => {
    if(err) {
    	return err;
    }
    return datos;
});
```
```js
// Ejemplo: Una Promesa Simple
const asyncOperation = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => { resolve('Operation completed successfully!'); }, 2000);
    });
};

asyncOperation().then((message) => { console.log(message);})
.catch((error) => { console.error(error);});

```
```js
const myPromise = new Promise((resolve, reject) => {
  const success = true;
  if (success) {
    resolve('Operación exitosa');
  } else {
    reject('Operación fallida');
  }
});

myPromise.then(result => console.log(result))
  		.catch(error => console.error(error));

```
```js
const asyncOperation = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const errorOccurred = Math.random() > 0.5; 
            if (errorOccurred) {
                reject('An error occurred during the operation.');
            } else {
                resolve('Operation completed successfully!');
            }
        }, 2000);
    });
};
asyncOperation() .then((message) => { console.log(message); })
    			.catch((error) => { console.error(error); });
```

```js
// Promesas en cadena, cada operación depende de los datos de la anterior
firstOperation()
    .then((data) => secondOperation(data))
        throw new Error('Evita propagar el error.');
        return secondOperation(data);
    .then((data) => thirdOperation(data))
    .then((finalResult) => {
        console.log('All operations completed. Final result:', finalResult);
    })
    .catch((error) => {
        console.error('An error occurred:', error);
    });
```
```js
// Combinar promesas
const promise1 = new Promise((resolve) => setTimeout(() => resolve('Result 1'), 1000));
const promise2 = new Promise((resolve) => setTimeout(() => resolve('Result 2'), 2000));
const promise3 = new Promise((resolve) => setTimeout(() => resolve('Result 3'), 3000));

Promise.all([promise1, promise2, promise3])
    .then((results) => {
        console.log('All promises resolved:', results);
    })
    .catch((error) => {
        console.error('One of the promises rejected:', error);
    });
```
```js
// Devuelve tan pronto se resuelve o rechaza.
Promise.race([promise1, promise2, promise3])
    .then((result) => {
        console.log('First promise resolved:', result);
    })
    .catch((error) => {
        console.error('First promise rejected:', error);
    });
```
```js
// Espera a que todas las Promesas en la matriz resuelvan o rechacen
// Devuelve una matriz de objetos que representan el resultado de cada Promesa.
Promise.allSettled([promise1, promise2, promise3])
    .then((results) => {
        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                console.log(`Promise ${index + 1} resolved with:`, result.value);
            } else {
                console.log(`Promise ${index + 1} rejected with:`, result.reason);
            }
        });
    });
```
```js
// Combinando async/await con Combinadores de Promesa
const operation1 = () => new Promise((resolve) => setTimeout(() => resolve('Result 1'), 1000));
const operation2 = () => new Promise((resolve) => setTimeout(() => resolve('Result 2'), 2000));

const main = async () => {
    try {
        const results = await Promise.all([operation1(), operation2()]);
        console.log('Results:', results);
    } catch (error) {
        console.error('Error:', error);
    }
};
```
```js
// Patrón: Ejecución Secuencial
const operations = [operation1, operation2, operation3];
const executeSequentially = async () => {
    for (const operation of operations) {
        const result = await operation();
        console.log('Result:', result);
    }
};
```
```js
// Patrón: Ejecución Paralela
const executeInParallel = async () => {
    const results = await Promise.all(operations.map((op) => op()));
    console.log('Results:', results);
};

``` 