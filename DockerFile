FROM nginx:stable-alpine


# Remove default nginx html
RUN rm -rf /usr/share/nginx/html/*


# Copy all static website files (Windows paths auto-convert)
COPY . /usr/share/nginx/html


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
