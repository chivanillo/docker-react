# First phase of production
FROM node:alpine as builder

WORKDIR /usr/app
COPY ./package.json ./
RUN npm install

COPY . .

RUN npm run build

# Second phase and preparing production server. Default port for NGINX is 80
# docker run -p 8080:80 chivanillo/frontendprod
FROM nginx

# When AWS elasticbeanstalk starts up the Dockerfile will look for the EXPOSE command
# and whatever port is listen here is what elasticbeanstalk is going to map directly
# In terms of local user, it will do nothing.
EXPOSE 80

COPY --from=builder /usr/app/build /usr/share/nginx/html
