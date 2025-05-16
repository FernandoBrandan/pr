---
title: Arquitectura Niveles
description: Apuntes varios
---

# 01 - Niveles

La arquitectura de N niveles divide una aplicación en capas lógicas y niveles físicos.
Las capas son una forma de separar responsabilidades y gestionar dependencias.
Cada capa tiene una responsabilidad específica.
Una capa superior puede utilizar servicios de una capa inferior, pero no al revés.
n-tier-architecture.webp

![tier]("src/assets/n-tier-architecture.webp")

Los niveles están separados físicamente y se ejecutan en máquinas distintas.
Una capa puede llamar directamente a otra o utilizar mensajería asíncrona.
Aunque cada capa puede alojarse en su propio nivel, no es necesario.
Varias capas pueden alojarse en la misma capa.
Separar físicamente los niveles mejora la escalabilidad y la resistencia y añade latencia por la comunicación de red adicional.

Una arquitectura de N niveles puede ser de dos tipos:

- En una arquitectura de capa cerrada, una capa sólo puede llamar a la capa inmediatamente inferior.
- En una arquitectura de capa abierta, una capa puede llamar a cualquiera de las capas inferiores.

Una arquitectura de capa cerrada limita las dependencias entre capas. Sin embargo, puede crear un tráfico de red innecesario, si una capa simplemente pasa las peticiones a la capa siguiente.

## Tipos de arquitecturas N-Tier

### Arquitectura de 3 niveles

- **Capa de presentación:** Maneja las interacciones del usuario con la aplicación.
- **Capa de lógica de negocio:** Acepta los datos de la capa de aplicación, los valida según la lógica de negocio y los pasa a la capa de datos.
- **Capa de acceso a los datos:** Recibe los datos de la capa de negocio y realiza las operaciones necesarias en la base de datos.

### Arquitectura de 2 niveles

- **Capa de presentación:** se ejecuta en el cliente y se comunica con un almacén de datos.
- No hay capa lógica de negocio ni capa inmediata entre el cliente y el servidor.

### Arquitectura de 1 nivel

- Es la más sencilla, ya que equivale a ejecutar la aplicación en un ordenador personal.
- Todos los componentes necesarios para que una aplicación funcione se encuentran en una única aplicación o servidor.

## Ventajas

- Puede mejorar la disponibilidad.
- Mejor seguridad ya que las capas pueden comportarse como un cortafuegos.
- Los niveles separados nos permiten escalarlos según sea necesario.
- Mejora el mantenimiento ya que diferentes personas pueden gestionar diferentes niveles.

## Desventajas

- Mayor complejidad del sistema en su conjunto.
- Aumento de la latencia de la red a medida que aumenta el número de niveles.
- Caro, ya que cada nivel tendrá su propio coste de hardware.
- Dificultad para gestionar la seguridad de la red.
