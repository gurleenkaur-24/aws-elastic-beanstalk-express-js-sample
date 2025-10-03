FROM node:16
WORKDIR /app

# install deps using lockfile if present
COPY package*.json ./
RUN npm ci --only=production || npm install --omit=dev

# copy source and expose
COPY . .
EXPOSE 8080

# start the AWS sample app
CMD ["npm","start"]
