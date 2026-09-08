FROM ://microsoft.com
WORKDIR C:/app
COPY . .
RUN npm install
CMD ['node', 'app.js']
