# That stage installs all the required tools
FROM node:16-alpine AS tools-stage

WORKDIR /usr/src/app


RUN yarn set version berry

RUN echo "nodeLinker: node-modules" >> .yarnrc.yml


# ---------------------------------------------------------------------------------


# That stage follows the manual Nuxt v2 installation documentation
# https://nuxtjs.org/fr/docs/get-started/installation/
FROM node:16-alpine AS nuxt-2-stage

COPY --from=tools-stage /usr/src/app /usr/src/app
WORKDIR /usr/src/app

RUN echo '\
  {\
  "name": "my-app",\
  "scripts": {\
  "dev": "yarn nuxt",\
  "build": "yarn nuxt build",\
  "generate": "yarn nuxt generate",\
  "start": "yarn nuxt start"\
  }\
  }' > package.json

RUN yarn add nuxt

RUN mkdir pages

RUN echo '\
  <template>\
  <h1>Hello world!</h1>\
  </template>' > pages/index.vue


# EXPOSE 3000
#
# CMD ["yarn", "run", "dev"]


# ---------------------------------------------------------------------------------


# That stage follows the Nuxt Bridge installation documentation
# https://v3.nuxtjs.org/getting-started/bridge/
FROM node:16-alpine AS nuxt-bridge-stage

COPY --from=nuxt-2-stage /usr/src/app /usr/src/app
WORKDIR /usr/src/app

RUN yarn add nuxt-edge

RUN yarn remove nuxt

RUN rm yarn.lock

RUN yarn install

RUN yarn add --dev @nuxt/bridge@npm:@nuxt/bridge-edge@latest

RUN sed -i "s/yarn nuxt build/yarn nuxi build/" package.json
RUN sed -i "s/yarn nuxt start/yarn nuxi preview/" package.json
RUN sed -i "s/yarn nuxt generate/yarn nuxi generate/" package.json
RUN sed -i "s/yarn nuxt/yarn nuxi dev/" package.json

# The following modules are described in the documentation, but are not installed in a stock Nuxt v2 project
# RUN yarn remove @nuxt/content nuxt-vite @nuxt/typescript-build @nuxt/typescript-runtime @nuxt/nitro @vue/composition-api @nuxtjs/composition-api

EXPOSE 3000

CMD ["yarn", "run", "dev", "--host", "0.0.0.0"]
