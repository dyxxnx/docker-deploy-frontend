# Stage 0, based on Node.js, to build and compile Angular
FROM node:10-alpine as node

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json /app/

# Install dependencies
RUN npm install

# Copy the entire project directory
COPY ./ /app/

# Set the build target as an argument
ARG TARGET=ng-deploy

# Build the Angular app
RUN npm run ${TARGET}

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.13

# Copy the built Angular app from the previous stage
COPY --from=node /app/dist/ /usr/share/nginx/html

# Copy the custom Nginx configuration file
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for Nginx
EXPOSE 80