FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

RUN curl -sSL https://nixpacks.com/install.sh | bash

COPY . .

RUN apk add --no-cache git

EXPOSE 5001

CMD ["node", "index.js"]
