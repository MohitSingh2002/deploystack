FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN apk add --no-cache git

EXPOSE 5001

CMD ["node", "index.js"]
