# Use Node.js 18 as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Install PM2 globally
RUN npm install -g pm2

# Copy the entire application code to the container
COPY . .

# Expose the application port
EXPOSE 8090

# Start the application with PM2
CMD ["pm2-runtime", "server.js"]
