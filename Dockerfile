# Dockerfile

# 1. Usamos una imagen oficial que ya tiene Windows Server 2022 Y Node.js 20 instalados de fábrica
# =========================================================================
# ETAPA 1: Usamos la imagen oficial de Node.js solo para extraer sus archivos
# =========================================================================
FROM node:20-alpine AS node-source

# =========================================================================
# ETAPA 2: Tu sistema operativo real Windows Server 2022
# =========================================================================
FROM ://microsoft.com

# Copiamos la carpeta completa de Node directamente desde la Etapa 1 hacia el disco C: de Windows
COPY --from=node-source /usr/local/bin/node.exe C:/nodejs/node.exe

# Inyectamos la ruta de Node en las variables de entorno de Windows de forma nativa en Docker
ENV PATH="C:\nodejs;${PATH}"

# Establecemos el directorio de trabajo para tu código
WORKDIR C:/app

# Copiamos app.js y package.json
COPY . .

# Informamos a AWS ECS sobre el puerto de red
EXPOSE 3000

# Comando definitivo para iniciar tu API
CMD ["node", "app.js"]
