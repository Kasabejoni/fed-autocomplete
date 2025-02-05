# Base image for development
FROM node:18-alpine AS dev

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --frozen-lockfile

# Copy all project files
COPY . .

# Expose Vite's development port
EXPOSE 5173

# Set environment variables for Vite inside Docker
ENV CHOKIDAR_USEPOLLING=true

# Start Vite in development mode
CMD ["npm", "run", "dev"]

# Build stage (for production)
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json for caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --frozen-lockfile

# Copy project files
COPY . .

# Build the Vue app with Vite
RUN npm run build

# Serve Stage (Nginx)
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy built Vue app from builder stage
COPY --from=builder /app/dist ./

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for serving the app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
