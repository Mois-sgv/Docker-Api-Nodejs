# Dockerfile

# 1. Usamos una imagen oficial que ya tiene Windows Server 2022 Y Node.js 20 instalados de fábrica
FROM stefanscherer/node:20-windowsservercore-2022

# 2. Establecemos el directorio de trabajo de la app usando rutas correctas de Windows
WORKDIR C:/app

# 3. Copiamos los archivos de nuestro repositorio (app.js y package.json)
COPY . .

# 4. Instalamos las dependencias. npm ya viene instalado y configurado en el PATH
RUN npm install

# 5. Informamos a AWS ECS que la aplicación estará escuchando en el puerto 3000
EXPOSE 3000

# 6. Comando de arranque nativo de Node.js
CMD ["node", "app.js"]
