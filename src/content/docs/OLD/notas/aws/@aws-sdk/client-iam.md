---
title: client-iam
description: aws-sdk/client-iam
---

## IAM Manager (Node.js CLI + AWS SDK)

Una aplicación de consola para gestionar IAM.

```sh
iam-manager/
├── .env
├── index.js
├── aws/
│ ├── iamClient.js                 # Cliente IAM configurado
│ ├── stsClient.js                 # Cliente STS para asunción de roles
│ ├── listEntities.js              # Listar usuarios, roles, políticas, grupos
│ ├── getDetails.js                # Detalles de un recurso (policy, user, role)
│ ├── createEntity.js              # Crear usuario, rol o política
│ ├── updateEntity.js              # Actualizar (attach/detach)
│ ├── deleteEntity.js              # Borrar usuario, rol o política
│ ├── exportBackup.js              # Exportar configuración a JSON
│ ├── assumeRole.js
│ ├── deleteUnusedPolicies.js
├── utils/
│ └── logger.js
│ └── config.js                    # Carga y valida .env
└── policies/
  └── backup/
```

```sh
node index.js list --scope Local
node index.js view --name MyCustomPolicy
node index.js create --file ./my-policy.json
node index.js delete-unused
node index.js export
```

```sh
npm install dotenv prompt-sync winston commander
npm install @aws-sdk/client-iam @aws-sdk/client-sts

# Rol + MFA vía STS
```
