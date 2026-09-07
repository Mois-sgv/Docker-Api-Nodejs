// app.js

// 1. Importamos la librería 'express', que es el estándar para crear servidores web en Node.js
const express = require('express');

// 2. Inicializamos la aplicación de Express para empezar a configurar nuestras rutas web
const app = express();

// 3. Definimos el puerto de red. Intentará leerlo desde las variables de entorno de AWS (process.env.PORT)
// Si no existe ninguna variable configurada, usará por defecto el puerto 3000
const PORT = process.env.PORT || 3000;

// 4. Configuración de la Ruta Principal o Raíz (cuando alguien entra a http://tu-ip/)
// 'req' (request) es la petición del usuario, 'res' (response) es la respuesta que le enviamos
app.get('/', (req, res) => {
    // Enviamos una respuesta en formato HTML con un encabezado grande (h1)
    res.send('<h1>¡HOLA MUNDO DESDE NODE.JS EN WINDOWS CONTAINERS! 🚀 Windows Server rules.</h1>');
});

// 5. Encendemos el servidor para que se quede "escuchando" peticiones en el puerto definido
// A diferencia de tu script anterior, este comando no termina solo; mantiene el contenedor vivo indefinidamente
app.listen(PORT, () => {
    // Imprimimos un mensaje en la consola que viajará directamente a tus logs de AWS CloudWatch
    console.log(`Servidor activo y escuchando de forma continua en el puerto ${PORT}`);
});
