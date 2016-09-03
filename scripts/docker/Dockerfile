# The FROM instruction sets the Base Image for subsequent instructions.
# Using Nginx as Base Image
FROM nginx:alpine

# The RUN instruction will execute any commands
# Adding HelloWorld page into Nginx server

#RUN rm /etc/nginx/conf.d/*

#ADD file.roar /etc/nginx/conf.d/
#VOLUME /opt/software
#COPY /tmp/build/dist/app.js /usr/share/nginx/html
#COPY /tmp/build/dist/app.css /usr/share/nginx/html

# The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime
EXPOSE 80

# The CMD instruction provides default execution command for an container
# Start Nginx and keep it from running background
CMD ["nginx", "-g", "daemon off;"]
