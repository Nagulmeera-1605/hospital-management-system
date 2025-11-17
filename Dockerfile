# ---- build stage ----
FROM node:18-alpine AS builder
WORKDIR /app

# install dependencies
COPY package*.json ./
RUN npm ci

# copy project files
COPY . .
RUN npm run build

# ---- production stage ----
FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

