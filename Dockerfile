# 1. Usamos una imagen oficial y actualizada para Windows Server 2022 con Node 20 preinstalado
FROM amitie10g/node-nanoserver:20-ltsc2022

# 2. Establecemos el directorio de trabajo usando las rutas normales de Windows
WORKDIR C:/app

# 3. Copiamos tus archivos locales (app.js y package.json) hacia el contenedor
COPY . .

# 4. Instalamos las dependencias. 'npm' ya funciona de forma nativa e inmediata en esta imagen
RUN npm install

# 5. Comando definitivo para arrancar tu API web
CMD ["node", "app.js"]
