---
title: "Event Sourcing" 
description: "Event Sourcing"
--- 

https://github.com/cer/event-sourcing-examples
https://martinfowler.com/eaaDev/EventSourcing.html

En lugar de almacenar solo el estado actual de los datos en un dominio, use una tienda solo para agregar para registrar la serie completa de acciones tomadas en esos datos. 
La tienda actúa como el sistema de registro y puede usarse para materializar los objetos de dominio.

<Image src="https://www.karanpratapsingh.com/_next/image?url=%2Fstatic%2Fcourses%2Fsystem-design%2Fchapter-III%2Fevent-sourcing%2Fevent-sourcing.png&w=3840&q=75">

Esto puede simplificar las tareas en dominios complejos, evitando la necesidad de sincronizar el modelo de datos y el dominio comercial, al tiempo que mejora el rendimiento, la escalabilidad y la capacidad de respuesta. También puede proporcionar consistencia para los datos transaccionales y mantener pistas de auditoría completas e historial que puedan permitir acciones compensatorias.

### Abastecimiento de eventos versus arquitectura impulsada por eventos ( EDA )
El abastecimiento de eventos aparentemente se confunde constantemente con Arquitectura impulsada por eventos ( EDA ). 
La arquitectura basada en eventos se trata de usar eventos para comunicarse entre los límites del servicio. 
En general, aprovechar un agente de mensajes para publicar y consumir eventos de forma asincrónica dentro de otros límites.

Mientras que el abastecimiento de eventos se trata de usar eventos como un estado, que es un enfoque diferente para almacenar datos. 
En lugar de almacenar el estado actual, en cambio vamos a almacenar eventos. 
Además, el abastecimiento de eventos es uno de los varios patrones para 
implementar una arquitectura basada en eventos.


## Ventajas
- Excelente para informes de datos en tiempo real.
- Ideal para la seguridad de fallas, los datos se pueden reconstituir desde la tienda de eventos.
- Extremadamente flexible, se puede almacenar cualquier tipo de mensaje.
- Forma preferida de lograr la funcionalidad de registros de auditoría para sistemas de alto cumplimiento.

## Desventajas
- Requiere una infraestructura de red extremadamente eficiente.
- Requiere una forma confiable de controlar los formatos de mensajes, como un registro de esquemas.
- Diferentes eventos contendrán diferentes cargas útiles.
___

La fuente de eventos es un patrón de diseño en el que el estado de un sistema se representa como una secuencia de eventos que han ocurrido a lo largo del tiempo. En un sistema basado en eventos, los cambios en el estado del sistema se registran como eventos y se almacenan en un almacén de eventos. El estado actual del sistema se obtiene reproduciendo los eventos del almacén de eventos.

Una de las principales ventajas de la fuente de eventos es que proporciona un historial claro y auditable de todos los cambios que se han producido en el sistema. Esto puede ser útil para depurar y seguir la evolución del sistema a lo largo del tiempo.

El aprovisionamiento de eventos se utiliza a menudo junto con otros patrones, como la segregación de responsabilidad de consulta de comandos (CQRS) y el diseño orientado al dominio, para construir sistemas escalables y con capacidad de respuesta con una lógica empresarial compleja. También es útil para construir sistemas que necesitan soportar la funcionalidad de deshacer/rehacer o que necesitan integrarse con sistemas externos.
