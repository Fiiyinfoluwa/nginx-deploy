const http = require("http");
const os = require("os");

const hostname = os.hostname();
const interfaces = os.networkInterfaces();

let ipAddress = "unknown";

Object.keys(interfaces).forEach((name) => {
  const interface = interfaces[name];
  interface.forEach((address) => {
    if (address.family === "IPv4" && !address.internal) {
      ipAddress = address.address;
    }
  });
});

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader("Content-Type", "text/html");
  res.end(`<html>
    <head>
      <style>
        h2 {
          text-align: center;
          padding-top: 10px;
        }
        h3 {
          text-align: center;
          padding-bottom: 60px;
        }
      </style>
    </head>
    <body>
      <h2>Hello! This is my hostname: ${hostname}</h1>
      <h3>This is my IP address: ${ipAddress}</p>
    </body>
  </html>`);
});

server.listen(5000, () => {
  console.log("Server running at http://localhost:5000/");
});
