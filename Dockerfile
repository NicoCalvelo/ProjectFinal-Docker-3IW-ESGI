# On part de l'image nginx:alpine et on va faire les installations de php plus tard
FROM nginx:alpine

# On installe php et les extensions necessaires pour laravel
RUN apk add --no-cache php php-fpm php-pdo_mysql php-mbstring php-exif php-pcntl php-bcmath php-gd php-fileinfo php-tokenizer php-dom php-xml php-xmlwriter php-session

# On fait un update et upgrade des packages
RUN apk update && apk upgrade

# On installe composer et nodejs
RUN apk add composer nodejs npm

# On expose le port 9000 pour que traefik puisse communiquer avec le container
EXPOSE 9000

# On set le working directory
WORKDIR /app/

# On fais un copie de notre projet dans le dossier /app
# On le fais ici parce que le volume dans docker compose s'execute après le dockerfile
# Donc si on le fais dans le docker compose, on pourra pas faire les installations de composer et npm
COPY TP-Final-3IW-ESGI /app
COPY nginx.conf /etc/nginx/nginx.conf

# installer packages
RUN composer install

# install dependencies
RUN npm install

# On crée la clé de l'application
RUN php artisan key:generate

# On crée le lien symbolique pour les commandes qu'on va lancer plus tard
COPY setup.sh /setup.sh
# On donne les droits d'execution au fichier
RUN chmod +x /setup.sh
# On appel le fichier setup.sh qui va lancer les commandes à chaque fois qu'on va lancer le container
CMD ["/setup.sh"]