#!/bin/sh

# On efface les caches
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Si on est sur le serveur 1, on fait les migrations de la base de données
# Comme on avait un problème avec les migrations, il fallait attendre que la base de données soit prête
# On a modifié le fichier AppServiceProvider.php pour relancer les migrations si la base de données n'est pas prête
if [ "$SERVER_WEB_NAME" = "SERVEUR 1" ]; then
  php artisan migrate:fresh --seed
fi

# On build le front
npm run build

# On demarre le serveur laravel
php artisan serve --host=0.0.0.0 --port=80