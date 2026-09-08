# =========================================================================
# 1. IMAGEN BASE: Usamos el sistema operativo Windows Server 2022 oficial
# =========================================================================
FROM ://microsoft.com

# 2. CONFIGURACIÓN: Establecemos PowerShell como el entorno de ejecución por defecto
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# 3. INSTALACIÓN DE CHOCOLATEY: Descargamos el gestor de paquetes oficial de Windows
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org'))

# 4. INSTALACIÓN DE NODE.JS: Choco instala Node v20 en primer plano y configura el PATH solo
RUN choco install nodejs-lts --version=20.11.0 -y --no-progress

# 5. DIRECTORIO DE TRABAJO: Creamos la ruta absoluta de la app dentro del disco C:
WORKDIR C:/app
