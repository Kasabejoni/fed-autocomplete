# Build Stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --frozen-lockfile

# Copy the rest of the application files
COPY . .

# Build the Vue app
RUN npm run build

# Serve Stage (Nginx)
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy built Vue app from previous stage
COPY --from=builder /app/dist ./

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for serving the app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
