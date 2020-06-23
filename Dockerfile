#Stage 1 - Create cached node_modules.
# Only rebuild layer if package.json has changed
FROM mhart/alpine-node as node_cache
WORKDIR /cache/
COPY package*.json ./
RUN yarn install

#Stage 2 - Build this thing
FROM mhart/alpine-node as build_output
WORKDIR /build/
COPY --from=node_cache /cache/ .
COPY . .
RUN yarn build

#Stage 3 - Copy this thing
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine
WORKDIR /root/
COPY --from=build_output /build/ .
RUN gsutil -m rsync -r -c -d public/ gs://www.nicktouchette.com/gatsby/