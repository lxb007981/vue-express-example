FROM node:14 AS server-build
WORKDIR /root/
COPY api/ ./api/
RUN cd api && npm install && npm run build

FROM node:14 AS ui-build
WORKDIR /usr/src/app
COPY my-app/ ./my-app/
RUN cd my-app && npm install && npm run build

FROM node:14 AS build
WORKDIR /root/
COPY --from=ui-build /usr/src/app/my-app/dist ./my-app/dist
COPY --from=server-build /root/api/server.bundle.js ./api/

EXPOSE 80

CMD ["node", "./api/server.bundle.js"]