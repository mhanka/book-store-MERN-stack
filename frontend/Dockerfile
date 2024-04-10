# Layer 1: Telling Docker to use the node:18-alpine image as the base image for the container.
FROM node:18.16.1-alpine as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port on which your frontend server will run
EXPOSE 80

# Start the frontend server
RUN npm run build




# Using the nginx:1.19 image as the base image for the container.
FROM nginx:1.19

# # # Copying the nginx.conf file from the local machine to the container's /etc/nginx/nginx.conf path.
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# # # Copying the built files from the previous build stage (named 'build') to the container's /usr/share/nginx/html path.
COPY --from=build /app/dist /usr/share/nginx/html


