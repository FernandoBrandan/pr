---
title: Enterprise Service Bus
description: Enterprise Service Bus (ESB)
--- 
Es un patrón mediante el cual un componente de software centralizado realiza integraciones entre aplicaciones. 
Realiza transformaciones de modelos de datos, maneja conectividad, realiza enrutamiento de mensajes, convierte protocolos de comunicación y potencialmente gestiona la composición de múltiples solicitudes. 
El ESB puede hacer que estas integraciones y transformaciones estén disponibles como una interfaz de servicio para su reutilización por nuevas aplicaciones.

## Ventajas
En teoría, un ESB centralizado ofrece el potencial de estandarizar y simplificar drásticamente la comunicación, los mensajes y la integración entre los servicios en toda la empresa. Aquí hay algunas ventajas de usar un ESB:

- Mejora de la productividad del desarrollador: Permite a los desarrolladores incorporar nuevas tecnologías en una parte de una aplicación sin tocar el resto de la aplicación.
- Escalabilidad más simple y rentable: Los componentes se pueden escalar independientemente de los demás.
- Mayor resistencia: La falla de un componente no afecta a los demás, y cada microservicio puede cumplir con sus propios requisitos de disponibilidad sin arriesgar la disponibilidad de otros componentes en el sistema.

## Desventajas
Si bien los ESB se implementaron con éxito en muchas organizaciones, en muchas otras organizaciones el ESB llegó a ser visto como un cuello de botella. Aquí hay algunas desventajas de usar un ESB:

- Hacer cambios o mejoras en una integración podría desestabilizar a otros que usan esa misma integración.
- Un solo punto de falla puede derribar todas las comunicaciones.
- Las actualizaciones del ESB a menudo afectan las integraciones existentes, por lo que se requieren pruebas significativas para realizar cualquier actualización.
- ESB se gestiona de forma centralizada, lo que dificulta la colaboración entre equipos.
- Alta configuración y complejidad de mantenimiento.

## Ejemplos
https://azure.microsoft.com/en-in/products/service-bus/
https://www.ibm.com/products/app-connect
https://camel.apache.org/
https://www.redhat.com/en/technologies/jboss-middleware/fuse