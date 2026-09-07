# Dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Configurar PowerShell estricto
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 1. Descargamos la versión PORTÁTIL binaria (.zip) de Node.js en lugar del instalador msi
RUN Invoke-WebRequest -Uri https://nodejs.org -OutFile node.zip

# 2. Descomprimimos el archivo directamente en C:\ y borramos el archivo zip para ahorrar espacio
RUN Expand-Archive -Path node.zip -DestinationPath C:\ ; \
    Remove-Item node.zip ; \
    Rename-Item -Path C:\node-v20.11.0-win-x64 -NewName C:\nodejs

# 3. Inyectamos la ruta de Node de forma permanente en las variables de entorno del contenedor
ENV PATH="C:\nodejs;${PATH}"

# 4. Establecemos el directorio de trabajo de la app
WORKDIR C:/app

# 5. Copiamos los archivos de nuestro repositorio
COPY . .

# 6. Al usar la versión portátil y la instrucción ENV, npm se reconoce de inmediato y sin esperas
RUN npm install

# 7. Exponemos el puerto
EXPOSE 3000

# 8. Comando de arranque nativo y limpio
CMD ["node", "app.js"]
