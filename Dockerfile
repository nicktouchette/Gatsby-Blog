FROM 14-4.0-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn install
COPY . .
CMD [ "yarn", "build" ]