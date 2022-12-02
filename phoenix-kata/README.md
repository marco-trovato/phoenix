## Application Requirements

- Runs on Node.js 8.11.1 LTS
- MongoDB as Database(single node)
- Environment variables:
    - PORT - Application HTTP Exposed Port
    - DB_CONNECTION_STRING - Database connection string `mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]`

## Run Application

- Install dependencies `npm install`
- Run `npm start`
- Connect to `http://<hostname|IP>:<ENV.PORT>`

## Ignore the following methods:

- `GET /crash` kill the application process
- `GET /generatecert` is not optimized and creates resource consumption peaks

## Requirements

- [x] Automate with a script the creation of the infrastructure and the setup of the application.
- [ ] Todo
