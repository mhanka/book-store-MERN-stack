# Stage 1: Build frontend
FROM node:18.16.1-alpine as backend-build

WORKDIR /app/backend

# Copy package.json and package-lock.json to the working directory
COPY backend/package*.json ./
RUN npm install

# Copy the rest of the backend application code to the working directory
COPY backend ./

# Expose port for backend server
EXPOSE 5000

ENTRYPOINT ["npm", "start"]

# Stage 2: Build backend
FROM backend-build as frontend-build

WORKDIR /app/frontend

# Copy package.json and package-lock.json to the working directory
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend application code to the working directory
COPY frontend ./
RUN npm run build


# Stage 3: Final image with NGINX and backend server
FROM nginx:1.19

# Copy the NGINX configuration file
COPY ./frontend/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy built frontend files
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy built backend files
COPY --from=backend-build /app/backend  /app/backend


# Expose ports
EXPOSE 80
EXPOSE 443

# Start the NGINX server
CMD ["nginx", "-g", "daemon off;"]


