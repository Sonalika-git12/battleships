# Use Node.js 18 as the base image
FROM node:18 AS node-builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the entire application code to the container
COPY . .

# Build the application (for React/Angular apps)
RUN npm run build

# ------------------------
# Build Tomcat Layer
# ------------------------
FROM tomcat:9.0-jdk11

# Set up Tomcat working directory
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy built files from Node.js builder
COPY --from=node-builder /usr/src/app/build/ .

# Expose Tomcat default port
EXPOSE 8089

# Start Tomcat
CMD ["catalina.sh", "run"]
