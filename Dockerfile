FROM nginx

COPY site /site
COPY nginx.conf /etc/nginx/nginx.conf
