# Utilisez une image node comme base
FROM node:14 AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /usr/src/app

# Copiez les fichiers package.json et package-lock.json
COPY package*.json ./

# Installez toutes les dépendances
RUN npm install

# Copiez le reste des fichiers du projet
COPY . .

# Exécutez webpack pour construire le projet
RUN npx webpack

# Utilisez une image de serveur web pour servir les fichiers statiques
FROM nginx:alpine

# Copiez les fichiers statiques du stage de build au serveur web
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/index.html

# Exposez le port 80 pour le serveur web
EXPOSE 80

# Démarrez le serveur web
CMD ["nginx", "-g", "daemon off;"]