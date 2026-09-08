# 1. Usamos la imagen oficial de Microsoft que ya viene con Windows Server Y Node.js de fábrica
FROM ://microsoft.com

# 2. Establecemos la carpeta de la aplicación dentro del contenedor
WORKDIR C:/app

# 3. Copiamos tus archivos del proyecto (app.js y package.json)
COPY . .

# 4. Instalamos las dependencias. El comando 'npm' ya funciona de forma nativa e inmediata
RUN npm install

# 5. Comando definitivo para arrancar tu servidor web de Node.js
CMD ["node", "app.js"]