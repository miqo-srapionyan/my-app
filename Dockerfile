# Step 1: Build stage
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files and directories into the container
COPY . .

# Build the application
RUN npm run build

# Stage 2: Runtime stage
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built files from the previous stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./

# Expose the Next.js default port
EXPOSE 3000

# Start the Next.js server in production mode
CMD ["npm", "start"]
