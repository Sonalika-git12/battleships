# Use Node.js 18 as the base image
FROM node:18 AS node-builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the entire application code to the container
COPY . .

# Optional: Build the application if required (for React, Angular, or Vue.js apps)
# Uncomment the next line if your application requires building
# RUN npm run build

# ------------------------
# Build Tomcat Layer
# ------------------------
FROM tomcat:9.0-jdk11

# Set up Tomcat working directory
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy all application files from the node-builder stage
# If your app does not require building, copy the source code instead
COPY --from=node-builder /usr/src/app/ .

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
