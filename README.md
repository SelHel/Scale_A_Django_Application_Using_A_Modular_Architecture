# Mettre à l'échelle une application Django en utilisant une architecture modulaire
## Résumé

Amélioration du Site web d'Orange County Lettings :<br>

- Réduction de la dette technique
- Refonte de l'architecture modulaire
- Mise en place d'un pipeline CI/CD utilisant CircleCI et Heroku
- Surveillance de l'application et suivi des erreurs via Sentry


## Développement local

### Prérequis

- Compte GitHub avec accès en lecture à ce repository
- Git CLI
- SQLite3 CLI
- Interpréteur Python, version 3.6 ou supérieure

Dans le reste de la documentation sur le développement local, il est supposé que la commande `python` de votre OS shell exécute l'interpréteur Python ci-dessus (à moins qu'un environnement virtuel ne soit activé).

### macOS / Linux

#### Cloner le repository

- `cd /path/to/put/project/in`
- `git clone https://github.com/OpenClassrooms-Student-Center/Python-OC-Lettings-FR.git`

#### Créer l'environnement virtuel

- `cd /path/to/Python-OC-Lettings-FR`
- `python -m venv venv`
- `apt-get install python3-venv` (Si l'étape précédente comporte des erreurs avec un paquet non trouvé sur Ubuntu)
- Activer l'environnement `source venv/bin/activate`
- Confirmer que la commande `python` exécute l'interpréteur Python dans l'environnement virtuel
`which python`
- Confirmer que la version de l'interpréteur Python est la version 3.6 ou supérieure `python --version`
- Confirmer que la commande `pip` exécute l'exécutable pip dans l'environnement virtuel, `which pip`
- Pour désactiver l'environnement, `deactivate`

#### Gérer les variables d'environnement

Créer un fichier nommé **.env** à la racine du projet puis stocker dans ce fichier les variables d'environnement ci-dessous :

```yaml
SECRET_KEY=<your-secret-key>
DEBUG=True
ALLOWED_HOSTS=localhost,0.0.0.0,127.0.0.1
```

#### Exécuter le site

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pip install --requirement requirements.txt`
- `python manage.py runserver`
- Aller sur `http://localhost:8000` dans un navigateur.
- Confirmer que le site fonctionne et qu'il est possible de naviguer (vous devriez voir plusieurs profils et locations).

#### Linting

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `flake8`

#### Tests unitaires

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pytest`

#### Base de données

- `cd /path/to/Python-OC-Lettings-FR`
- Ouvrir une session shell `sqlite3`
- Se connecter à la base de données `.open oc-lettings-site.sqlite3`
- Afficher les tables dans la base de données `.tables`
- Afficher les colonnes dans le tableau des profils, `pragma table_info(Python-OC-Lettings-FR_profile);`
- Lancer une requête sur la table des profils, `select user_id, favorite_city from
  Python-OC-Lettings-FR_profile where favorite_city like 'B%';`
- `.quit` pour quitter

#### Panel d'administration

- Aller sur `http://localhost:8000/admin`
- Connectez-vous avec l'utilisateur `admin`, mot de passe `Abc1234!`

### Windows

Utilisation de PowerShell, comme ci-dessus sauf :

- Pour activer l'environnement virtuel, `.\venv\Scripts\Activate.ps1` 
- Remplacer `which <my-command>` par `(Get-Command <my-command>).Path`


## Déploiement

### Prérequis
- Compte [DockerHub](https://hub.docker.com/)
- Compte [CircleCI](https://circleci.com/signup/)
- Compte [Heroku](https://signup.heroku.com/)
- Installer [Heroku CLI](https://devcenter.heroku.com/articles/getting-started-with-python#set-up)

Dans ce projet le deploiement de l'application sur Heroku est automatisé avec un pipeline CI/CD CircleCI.<br>
Les détails de la configuration du pipeline sont disponibles dans le fichier config.yml du dossier .circleci

### Fonctionnement du déploiement

- Lors d'un **git push** depuis la branche master du projet, le pipeline déclenche le linting et les tests.<br>Si le linting et les tests sont réussis, il déclenche la conteneurisation et envoie l'image sur DockerHub.<br>
Si la conteneurisation et l'envoi de l'image sont réussis, il exécute le déploiement de l'application sur Heroku.

- Seules les modifications apportées à la branche master dans Github déclenchent la conteneurisation et le deploiement du site vers Heroku.

- Les modifications apportées aux autres branches du projet déclencheront uniquement le linting et les tests.

![alt tag](https://user-images.githubusercontent.com/83015257/191265011-9c8ea0ae-fe32-485b-96c6-dec8045c2511.png)

- Lien vers le Pipeline CircleCI du projet :<br> <https://dl.circleci.com/status-badge/redirect/gh/SelHel/Scale_A_Django_Application_Using_A_Modular_Architecture/tree/master>



### Guide de déploiement

#### Étape 1:DockerHub
- Se connecter à DockerHub et créer un nouveau repository (Pensez à modifier le nom du repository DockerHub dans le fichier de configuration .circleci/config.yml)

- Ensuite vous devez générer un Access token. ([Voir documentation](https://docs.docker.com/docker-hub/access-tokens/))<br>
(Vous devrez le renseigner dans les variables d'environnement de votre projet CircleCI)

#### Étape 2:Heroku
- Se connecter à Heroku et créer une nouvelle application (Pensez à modifier le nom de l'application Heroku dans le fichier de configuration .circleci/config.yml)

- Ensuite vous devez générer un API token en utilisant Heroku CLI. ([Voir documentation](https://devcenter.heroku.com/articles/authentication))<br>
(Vous devrez le renseigner dans les variables d'environnement de votre projet CircleCI)

#### Étape 3:CircleCI

- Se connecter à CircleCI, créer un nouveau projet lié à votre repository GitHub.

- Sélectionner la branche master comme source pour le fichier .circleci/config.yml

- Ensuite vous devez définir les variables d'environnement suivantes dans les Settings de votre projet :

	| Name  | Value
	| :--------------: |:---------------: |
	| ALLOWED_HOSTS  |  [your-app-name].herokuapp.com   |
	| DEBUG  | False  |
	| DOCKERHUB_TOKEN  | YOUR DOCKERHUB TOKEN  |
	| DOCKERHUB_USER  | YOUR DOCKERHUB USERNAME |
	| HEROKU_TOKEN  | YOUR HEROKU API TOKEN  |
	| SECRET_KEY  | YOUR DJANGO SECRET KEY  |


- Vous pouvez maintenant déployer votre application en utilisant CircleCI, il vous suffira simplement d'effectuer un **git push** depuis l'une de vos branches pour que le pipeline déclenche automatiquement les étapes précédentes.


## Surveillance de l'application et suivi des erreurs via Sentry

### Prérequis

- Un compte [Sentry](https://sentry.io/signup/) (connexion avec github)

### Utilisation

- Se connecter à Sentry et créer un nouveau projet en choisissant la plateforme Django.

- Récupérer le DSN en allant dans **Organization settings** > **Projects**, choisissez votre projet puis cliquez sur **Client Keys(DSN)**.

- Copiez le DSN et ajoutez le aux variables d'environnement du fichier **.env** ainsi qu'aux variables d'environnement du projet sur CircleCI :
	
	| Clé  | Valeur
	| :--------------: |:---------------: |
	| SENTRY_DSN  |  YOUR SENTRY DSN KEY   |
	
- Test d'une erreur `https://[your-app-name].herokuapp.com/sentry-debug/`

- Pour afficher et résoudre l'erreur enregistrée, connectez-vous à [sentry.io](https://sentry.io/organizations/[your-sentry-id]/issues/) et ouvrez votre projet.<br>
Cliquer sur le titre de l'erreur, une page s'ouvrira, vous pourrez voir des informations détaillées et la marquer comme résolue.

## Extraire l'image de DockerHub et l'exécutez localement
### Prérequis
- Installer [Docker Desktop](https://docs.docker.com/get-docker/)

### Pour extraire et exécuter l'image à partir de Docker Hub :

- Lancez l'application Docker Desktop

- Dans un terminal ou dans l'invite de commandes exécutez la commande suivante :
```docker run -p 8000:8000 selhel/python-oc-lettings:latest```

- Si vous ne disposez pas de l'image en local, Docker ira la télécharger sur le registre.

- Le site lancé localement sera disponible à l'adresse : [http://localhost:8000](http://localhost:8000)


## Lien vers l'application deployée sur Heroku

- [https://oc-lettings-17.herokuapp.com](https://oc-lettings-17.herokuapp.com)

## Auteur
**Selim Helaoui**