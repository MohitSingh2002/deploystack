FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache curl bash git tar gzip docker-cli nginx certbot certbot-nginx sudo

COPY package*.json ./
RUN npm install

RUN curl -sSL https://nixpacks.com/install.sh | bash

RUN mkdir -p ~/.docker/cli-plugins/
RUN curl -SL https://github.com/docker/buildx/releases/download/v0.33.0/buildx-v0.33.0.linux-amd64 -o ~/.docker/cli-plugins/docker-buildx
RUN chmod +x ~/.docker/cli-plugins/docker-buildx

COPY . .

RUN apk add --no-cache git && \
    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    echo 'include /etc/nginx/sites-enabled/*;' > /etc/nginx/http.d/deploystack.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5001 80 443

CMD ["/start.sh"]
