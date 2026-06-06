FROM node:22-alpine

ENV NODE_ENV=production \
    REDOCLY_SUPPRESS_UPDATE_NOTICE=true \
    PORT=4000

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY redocly.yaml redocly.dist.yaml ./
COPY scripts ./scripts
COPY AGENTS.md ./
COPY logo-vedecom.png logo-vedecom-dark.png favicon-vedecom.png ./
COPY ERM ./ERM
COPY HEMS ./HEMS
COPY OBC ./OBC
COPY OCPP_OCPI ./OCPP_OCPI
COPY OpenADR ./OpenADR
COPY PKI ./PKI
COPY charge-point ./charge-point
COPY components ./components
COPY ev-virtualizer ./ev-virtualizer

RUN npm run bundle

EXPOSE 4000

CMD ["npm", "run", "preview:dist:no-bundle"]
