FROM node

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
EXPOSE 8081

# Start the application with PM2
CMD ["pm2-runtime", "server.js"]
