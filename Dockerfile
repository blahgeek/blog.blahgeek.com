FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY site /site
