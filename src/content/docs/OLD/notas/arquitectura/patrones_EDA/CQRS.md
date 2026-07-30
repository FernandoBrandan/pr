---
title: CQRS 
description: CQRS
--- 

____
https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs

### Command and Query Responsibility Segregation 

Es un patrón que divide las acciones de un sistema en comandos y consultas.
- Comando es una instrucción, una directiva para realizar una tarea específica. 
Es una intención cambiar algo y no devuelve un valor, solo una indicación de éxito o fracaso. 
- Consulta es una solicitud de información que no cambia el estado del sistema ni causa ningún efecto secundario.

<Image src="https://www.karanpratapsingh.com/_next/image?url=%2Fstatic%2Fcourses%2Fsystem-design%2Fchapter-III%2Fcommand-and-query-responsibility-segregation%2Fcommand-and-query-responsibility-segregation.png&w=1920&q=75">

El principio central de CQRS es la separación de comandos y consultas. 
Realizan roles fundamentalmente diferentes dentro de un sistema, y separarlos significa que cada uno puede optimizarse según sea necesario, de lo que los sistemas distribuidos realmente pueden beneficiarse.

## CQRS con Event Sourcing
El patrón CQRS se usa a menudo junto con el patrón de Event Sourcing. 
Los sistemas basados en CQRS utilizan modelos de datos de lectura y escritura separados, cada uno adaptado a tareas relevantes y a menudo ubicado en tiendas físicamente separadas.

Cuando se usa con el patrón de Event Sourcing, el almacén de eventos es el modelo de escritura y es la fuente oficial de información. 
El modelo de lectura de un sistema basado en CQRS proporciona vistas materializadas de los datos, típicamente como vistas altamente desnormalizadas.

## Ventajas
- Permite escalar independientemente las cargas de trabajo de lectura y escritura.
- Escalado más fácil, optimizaciones y cambios arquitectónicos.
- Más cerca de la lógica empresarial con acoplamiento suelto.
- La aplicación puede evitar uniones complejas al consultar.
- Borrar límites entre el comportamiento del sistema.

## Desventajas
- Diseño de aplicación más complejo.
- Pueden ocurrir fallas de mensajes o mensajes duplicados.
- Tratar con la consistencia eventual es un desafío.
- Mayor esfuerzo de mantenimiento del sistema.
- Usar casos

### Aquí hay algunos escenarios en los que CQRS será útil:

- El rendimiento de las lecturas de datos debe ajustarse por separado del rendimiento de las escrituras de datos.
- Se espera que el sistema evolucione con el tiempo y pueda contener múltiples versiones del modelo, o donde las reglas comerciales cambian regularmente.
- Integración con otros sistemas, especialmente en combinación con el Event Sourcing, donde la falla temporal de un subsistema no debería afectar la disponibilidad de los demás.
- Mejor seguridad para garantizar que solo las entidades de dominio correctas realicen escrituras en los datos. 