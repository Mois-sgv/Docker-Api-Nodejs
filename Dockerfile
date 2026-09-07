# Dockerfile
FROM ://microsoft.com

SHELL ["powershell", "-Command", "`$ErrorActionPreference = 'Stop';"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org'))

RUN choco install nodejs-lts --version=20.11.0 -y --no-progress

WORKDIR C:/app

COPY . .

RUN npm install

EXPOSE 3000

CMD ["node", "app.js"]