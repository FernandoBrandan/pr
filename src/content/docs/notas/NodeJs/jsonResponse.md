---
title: "Json response"
description: "Json response."
slug: "Json response"
---

https://stackify.com/node-js-error-handling/
https://dev.to/srishtikprasad/error-handling-with-express-40pk
https://dev.to/divine_nnanna2/error-handling-and-logging-in-nodejs-applications-1k2a
https://dev.to/amritak27/advanced-error-handling-in-nodejs-1ep8
https://medium.com/@adarshahelvar/error-handling-in-node-js-7a474a8e6ba7
https://medium.com/@vickypaiyaa/power-of-advanced-error-handling-techniques-in-node-js-44d53cda3c61
https://javascript.plainenglish.io/global-error-handling-in-node-js-with-middleware-a-complete-guide-%EF%B8%8F-b037023e3866
https://blog.appsignal.com/2023/03/15/how-to-build-an-error-handling-layer-in-nodejs.html

## errores y clases
https://engineering.udacity.com/handling-errors-like-a-pro-in-typescript-d7a314ad4991
https://www.youtube.com/watch?v=SZESFtcoGT0

## Template para respuesta 

```json
{
  "status": "success",
  "message": "Descripción breve de la respuesta",
  "data": {},
  "error": null
}
```
status: success/error
message: Description
data: json data
error: null/error message

```js
const responseHandler = (req, res, next) => {
  res.success = (data, message = "Operación exitosa") => {
    res.json({
      status: "success",
      message,
      data,
      error: null
    });
  };

  res.error = (errorMessage = "Error desconocido", code = 400) => {
    res.status(code).json({
      status: "error",
      message: errorMessage,
      data: null,
      error: errorMessage
    });
  };

  next();
};
module.exports = responseHandler;
```
```js
const responseHandler = require("./responseHandler");
app.use(responseHandler);

```


