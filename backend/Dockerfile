FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN apt-get update && apt-get install -y git

EXPOSE 5001

CMD ["node", "index.js"]
