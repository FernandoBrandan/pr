---
title: Aws.IAM
description: Aws.IAM
---

## Validar politicas de acceso

### Crear una política IAM personalizada

- [policies](https://us-east-1.console.aws.amazon.com/iam/home#/policies)
- Create policy

```json
// Reemplazá mi-bucket
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::mi-bucket", "arn:aws:s3:::mi-bucket/*"]
    }
  ]
}
```

- Next → Poné un nombre como S3ReadOnlyMyBucket

### Asignar esta política a un usuario o rol

- Podés hacer esto desde IAM → Usuarios o Roles:
- Andá a Users → Elegí un usuario → "Add permissions".
- Seleccioná "Attach existing policies directly".
- Buscá la política que creaste (S3ReadOnlyMyBucket) y marcala.
- Confirmá.

El usuario solo podrá listar y leer archivos de tu bucket, pero no podrá borrar, subir ni modificar nada.
Esto es clave para dar acceso seguro y mínimo (principio de menor privilegio).

## MFA device name

- Nombre del dispositivo
- Este nombre se utilizará en el ARN de identificación de este dispositivo.
- aws_security_credentials

## Personas

- URL de inicio de sesión de la consola:
  https://947514074415.signin.aws.amazon.com/console
- Nombre de usuario
  appNode_p1
- Contraseña de la consola
  fA394&4V

- Clave de acceso
- Clave de acceso secreta

export AWS_ACCESS_KEY_ID=AKIA…
export AWS_SECRET_ACCESS_KEY=wJalr…
export AWS_SESSION_TOKEN=IQoJb3Jh… # para credenciales temporales

Desde root
Crear usuario
Crear grupo
Asignar usuario a grupo

---

Crear rol - credenciales temporales
Crear política - permisos
Asignar política a rol
Asignar rol a usuario
