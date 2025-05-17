---
title: Paginacion
description: Paginacion
--- 

### 
- Número de página (page=2)
- Cantidad de elementos por página (per_page=10)
- Cálculo de límites:  (página 2 - tamaño 10) devolverá los elementos del índice 10 al 19.

```sql
SELECT * FROM productos LIMIT 10 OFFSET 10;  -- Página 2, 10 productos por página
```
```json
{
  "data": [
    { "id": 11, "nombre": "Producto 11" },
    { "id": 12, "nombre": "Producto 12" },
  ],
  "meta": {
    "total_count": 100,
    "total_pages": 10,
    "current_page": 2,
    "per_page": 10
  }
}
```

## Ventajas de la paginación del lado del servidor:
- Reducción de la carga en el cliente: 
En lugar de cargar todos los datos de una vez, el cliente solo recibe lo necesario para la página actual.
- Rendimiento optimizado: 
El servidor solo consulta los datos que necesita mostrar, lo que reduce la sobrecarga en la base de datos y mejora el tiempo de respuesta.
- Escalabilidad: 
Permite manejar grandes volúmenes de datos sin que el cliente o el servidor se vean sobrecargados.

## Consideraciones:
- Estado de la página: El cliente debe gestionar el estado de la página (página actual - tamaño de página).
- Manejo de errores: El servidor debe manejar casos en los que el cliente pida una página que no existe.

```js
const express = require('express');
const mongoose = require('mongoose');
const Product = require('./models/Product'); 
const app = express();

app.get('/products', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const perPage = parseInt(req.query.per_page) || 10;

  try {
    const products = await Product.find()
      .skip((page - 1) * perPage)
      .limit(perPage);

    const totalCount = await Product.countDocuments();
    const totalPages = Math.ceil(totalCount / perPage);

    res.json({
      data: products,
      meta: {
        total_count: totalCount,
        total_pages: totalPages,
        current_page: page,
        per_page: perPage,
      },
    });
  } catch (error) {
    res.status(500).send(error.message);
  }
});
app.listen(3000, () => console.log('Server running on http://localhost:3000'));
```

# <mark>Front

```html 
<body>
  <h1>Productos</h1>
  <ul id="product-list"></ul>
  <div class="pagination">
    <button id="prev-page" disabled>Anterior</button>
    <button id="next-page">Siguiente</button>
  </div>
  <script src="app.js"></script>
</body>
```
```js
let currentPage = 1;
const perPage = 10;
const productList = document.getElementById('product-list');
const prevButton = document.getElementById('prev-page');
const nextButton = document.getElementById('next-page');

function fetchProducts(page) {
  fetch(`/products?page=${page}&per_page=${perPage}`)
    .then(response => response.json())
    .then(data => {
      const { data: products, meta } = data;
      productList.innerHTML = '';       // Limpiar la lista de productos
      products.forEach(product => {
        const li = document.createElement('li');
        li.classList.add('product');
        li.textContent = `${product.name} (ID: ${product.id})`;
        productList.appendChild(li);
      });       // Mostrar los productos

      // Habilitar/deshabilitar botones de paginación
      prevButton.disabled = currentPage === 1;
      nextButton.disabled = currentPage === meta.total_pages;
    })
    .catch(error => console.error('Error fetching products:', error));
}

// Manejo del botón de la página anterior
prevButton.addEventListener('click', () => {
  if (currentPage > 1) {
    currentPage--;
    fetchProducts(currentPage);
  }
});

// Manejo del botón de la página siguiente
nextButton.addEventListener('click', () => {
  currentPage++;
  fetchProducts(currentPage);
});

// Cargar los productos iniciales
fetchProducts(currentPage);
```
- Manejo de errores: Mostrar un mensaje al usuario si ocurre un problema al cargar los productos.
- Optimización de la UI: Indicador de carga (spinner) mientras se obtienen los productos desde el servidor.
- Estado de la página: Si el cliente recarga la página o navega a otra vista, se mantiene el estado de la página actual usando el almacenamiento local o la URL (añadiendo parámetros de página a la URL).


- Rendimiento: Cargar todos los datos en el cliente puede consumir mucha memoria y afectar el rendimiento de la aplicación.
- Escalabilidad: A medida que los datos crecen, mantener todo en el frontend no es una opción escalable.
- Costo de la red: Al hacer una consulta solo para los datos relevantes a cada página, se minimiza la cantidad de datos que viajan entre el servidor y el cliente.

# Optimizar ?? 
- Cargar más de una página a la vez: El frontend cargue los datos de las siguientes páginas en segundo plano mientras el usuario está visualizando la página actual. 
- Cacheo de datos: Cachear los resultados de las páginas ya solicitadas, para evitar hacer solicitudes repetidas al servidor.

 