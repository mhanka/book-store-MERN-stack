# Stage 1: Build frontend
FROM node:18.16.1-alpine as build

WORKDIR /app/backend

# Copy package.json and package-lock.json to the working directory
COPY backend/package*.json ./
RUN npm install

# Copy the rest of the backend application code to the working directory
COPY backend ./

EXPOSE 5000

RUN npm run build


WORKDIR /app/frontend

# Copy package.json and package-lock.json to the working directory
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend application code to the working directory
COPY frontend ./

EXPOSE 3000
RUN npm run build


# Stage 3: Final image with NGINX and backend server
FROM nginx:1.19

# Copy the NGINX configuration file
COPY ./frontend/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy built frontend files
COPY --from=build /app/frontend/dist /usr/share/nginx/html
COPY --from=build /app/backend/dist /usr/share/nginx/html

# Copy built backend files

# Expose ports
EXPOSE 80

# Start the NGINX server
CMD ["nginx", "-g", "daemon off;"]


