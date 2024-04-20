# Use an official Node.js runtime as the base image
FROM node:19.5.0-alpine

# Set the working directory inside the container
WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# RUN npm install

# # Copy the rest of the application code to the working directory
# COPY . .

# # Install app dependencies
# RUN npm run build

# Copy the rest of the application code to the working directory
COPY /dist/bundle.js  ./ 

COPY .env ./

# Expose the port on which your backend server will run
EXPOSE 5000

# Start the backend server
CMD ["node", "bundle.js"]
