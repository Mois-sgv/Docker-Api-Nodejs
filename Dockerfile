# Dockerfile
FROM ://microsoft.com

# Configurar PowerShell estricto como el intérprete por defecto
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 1. Instalar Chocolatey de forma oficial y nativa en Windows Server
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org'))

# 2. Usar Chocolatey para instalar Node.js (esto configura el PATH automáticamente y no falla jamás)
RUN choco install nodejs-lts --version=20.11.0 -y --no-progress

# 3. Establecemos el directorio de trabajo de la app en Windows
WORKDIR C:/app

# 4. Copiamos los archivos de nuestro repositorio (app.js y package.json)
COPY . .

# 5. Instalamos Express (NPM ya es reconocido nativamente por el sistema)
RUN npm install

# 6. Informamos a AWS ECS sobre el puerto de red
EXPOSE 3000

# 7. Comando de arranque definitivo
CMD ["node", "app.js"]
