# Dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 1. Descargamos Node.js v20
RUN Invoke-WebRequest -Uri https://nodejs.org -OutFile node.msi

# 2. SOLUCCIÓN DEVOPS: Forzamos la instalación silenciosa estricta en primer plano y bloqueamos Docker hasta que termine
RUN Start-Process msiexec.exe -ArgumentList '/i node.msi /qn /norestart' -Wait; \
    Remove-Item node.msi

# 3. RECARGA DE ENTORNO: Forzamos a Windows a leer el nuevo PATH donde se instaló Node.js
RUN $env:PATH = 'C:\Program Files\nodejs;' + $env:PATH; \
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

WORKDIR C:/app

COPY . .

# 4. Ahora podemos llamar a npm de forma directa y limpia porque Windows ya lo reconoce
RUN npm install

EXPOSE 3000

CMD ["node", "app.js"]
