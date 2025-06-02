# Use Node.js base image
FROM node:alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (for dependencies)
COPY package*.json ./

# Install dependencies inside the container
RUN npm install

# Copy the rest of your backend code
COPY . .

# Expose the port your backend runs on
EXPOSE 3000

# Start the backend
CMD ["npm", "start"]