# Dockerfile

# 1. Usamos la imagen oficial ligera de Windows Server Core optimizada para contenedores
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# 2. Configuramos PowerShell como el intérprete por defecto para la construcción del contenedor
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 3. Descargamos e instalamos Node.js oficial para Windows de forma silenciosa y automática
RUN Invoke-WebRequest -Uri https://nodejs.org -OutFile node.msi; \
    Start-Process msiexec.exe -ArgumentList '/i node.msi /quiet /norestart' -Wait; \
    Remove-Item node.msi

# 4. Usamos la barra normal para definir la ruta absoluta en Windows
WORKDIR C:/app

# 5. Copiamos todo el código de nuestra API (incluyendo app.js y package.json) hacia la ruta de trabajo
COPY . .

# 6. SOLUCIÓN: Usamos la ruta absoluta exacta donde el instalador de Windows aloja Node y NPM por defecto
RUN & 'C:\Program Files\nodejs\npm.cmd' install

# 7. Informamos a AWS ECS que la aplicación estará escuchando tráfico de red por el puerto 3000
EXPOSE 3000

# 8. Comando de arranque definitivo utilizando la ruta absoluta de Node para evitar fallos de PATH
CMD ["C:\\Program Files\\nodejs\\node.exe", "app.js"]
