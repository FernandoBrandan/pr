ver.md

Resumen
La cláusula ENGINE=InnoDB al final de una sentencia CREATE TABLE en MySQL indica que la tabla se debe crear utilizando el motor de almacenamiento InnoDB, en lugar de otros motores como MyISAM o MEMORY. InnoDB es el motor por defecto en MySQL desde la versión 5.5.5 y destaca por su soporte de transacciones ACID, bloqueo a nivel de fila y recuperación ante fallos, lo que lo hace idóneo para aplicaciones que requieren alta fiabilidad y concurrencia 
MySQL Developer Zone
Wikipedia
.

¿Qué es InnoDB?
Motor de almacenamiento diseñado para MySQL y MariaDB, distribuido por Oracle bajo licencia GPL v2 o comercial 
Wikipedia
.

Reemplazó a MyISAM como motor por defecto en MySQL 5.5.5 (2010) gracias a su balance entre rendimiento y fiabilidad 
Wikipedia
IONOS
.

Soporta transacciones con las cuatro propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad) y claves foráneas con integridad referencial declarativa 
Wikipedia
MariaDB
.

¿Por qué usar ENGINE=InnoDB?
Transaccionalidad y concurrencia

Bloqueo a nivel de fila (row‑level locking), lo que mejora la concurrencia en entornos OLTP, a diferencia de MyISAM que bloquea tablas completas 
Stack Overflow
.

Recuperación ante fallos

Registro de transacciones (redo log) y rollback automático que permiten restaurar la base de datos a un estado consistente tras una caída del servidor 
MySQL Developer Zone
.

Índices agrupados (clustered indexes)

Los datos se almacenan físicamente en el orden de la clave primaria, reduciendo I/O en lecturas frecuentes basadas en esa clave 
MySQL Developer Zone
.

Sintaxis en CREATE TABLE
Cuando escribes:

sql
Copiar
Editar
CREATE TABLE Hotel (
  … definición de columnas …
) ENGINE=InnoDB;
ENGINE=InnoDB obliga a MySQL a asociar InnoDB a la tabla recién creada 
Database Administrators Stack Exchange
.

Si omites la cláusula ENGINE, MySQL usa el motor que tengas configurado como default_storage_engine, que por defecto es InnoDB 
MySQL Developer Zone
.

Comparativa rápida con MyISAM
Característica					InnoDB								MyISAM
Transacciones ACID				Sí									No
Bloqueo							Nivel de fila						Nivel de tabla
Integridad referencial			Claves foráneas						No
Recuperación tras fallo			Registro y recuperación automática	Necesita reparación manual de índices y tablas
Rendimiento OLTP				Excelente							Bueno, pero peor en alta concurrencia

Conclusión:
Usar ENGINE=InnoDB es la opción recomendada para la mayoría de aplicaciones de producción que requieren seguridad de datos, integridad referencial y alto rendimiento en entornos con múltiples usuarios concurrentes.