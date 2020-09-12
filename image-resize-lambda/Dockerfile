FROM lambci/lambda:build-nodejs12.x as stage1

WORKDIR /app

COPY . .

RUN rm -rf node_modules
RUN npm install
RUN rm -rf dist
RUN mkdir dist
RUN zip -9yr dist/image-resize-lambda.zip .

FROM scratch AS export-stage
COPY --from=stage1 /app/dist/image-resize-lambda.zip .