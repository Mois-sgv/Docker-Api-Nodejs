# Dockerfile

# 1. Usamos la imagen oficial ligera de Windows Server Core optimizada para contenedores
FROM :mcr.microsoft.com/windows/servercore:ltsc2022

# 2. Configuramos PowerShell como el intérprete por defecto para la construcción del contenedor
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 3. Descargamos e instalamos Node.js oficial para Windows de forma silenciosa y automática
RUN Invoke-WebRequest -Uri https://nodejs.org -OutFile node.msi; \
    Start-Process msiexec.exe -ArgumentList '/i node.msi /quiet /norestart' -Wait; \
    Remove-Item node.msi

# 4. Creamos el directorio de la aplicación en la unidad de disco C: de Windows y nos movemos allí
WORKDIR C:\app

# 5. Copiamos todo el código de nuestra API (incluyendo app.js y package.json) hacia la ruta de trabajo
COPY . .

# 6. Instalamos la librería de Express y sus dependencias necesarias en el entorno de Windows
RUN npm install

# 7. Informamos a AWS ECS que la aplicación estará escuchando tráfico de red por el puerto 3000
EXPOSE 3000

# 8. Comando de arranque definitivo que mantendrá tu servidor web encendido de forma continua
CMD ["node", "app.js"]
