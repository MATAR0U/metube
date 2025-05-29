# MeTube (version française)

Interface web pour youtube-dl (utilisant le fork [yt-dlp](https://github.com/yt-dlp/yt-dlp)) avec le support de playlist. Permet de télécharger des vidéos depuis YouTube et des [dizaines d'autres sites](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md).

![screenshot1](https://github.com/alexta69/metube/raw/master/screenshot.gif)

## Utiliser docker

```bash
docker run -d -p 8081:8081 -v /path/to/downloads:/downloads ghcr.io/matar0u/metube-fr
```

## Utiliser docker compose

```yaml
services:
  metube:
    image: ghcr.io/matar0u/metube-fr
    container_name: metube-fr
    restart: unless-stopped
    ports:
      - "8081:8081"
    volumes:
      - /path/to/downloads:/downloads
```

## Configuration via les variables d'environment

Certains paramètres peuvent être défini par variable d'environnement, utilisant l'option `-e` avec la commande docker, ou la section `environment:` dans le docker-compose.

* __UID__: utilisateur sous lequel MeTube va tourner. `1000` par défaut.
* __GID__: groupe sous lequel MeTube va tourner. `1000` par défaut.
* __UMASK__: valeur umask utilisé par MeTube. `022` par défaut.
* __DEFAULT_THEME__: theme par défaut utilisé pour l'ui, peut être `light`, `dark` ou `auto`. `auto` par défaut.
* __DOWNLOAD_DIR__: chemin où les téléchargement seront enregistrés. `/downloads` par défaut dans l'image docker, sinon `.`.
* __AUDIO_DOWNLOAD_DIR__: chemin où les téléchargement en audio uniquement seront enregistrés, si vous souhaitez les séparés des vidéos. `DOWNLOAD_DIR` par défaut.
* __DOWNLOAD_DIRS_INDEXABLE__: si `true`, les dossiers (__DOWNLOAD_DIR__ et __AUDIO_DOWNLOAD_DIR__) seront indéxé sur le serveur web. `false` par défaut.
* __CUSTOM_DIRS__: activation ou non du téléchargement de vidéos dans des répertoires personnalisés au sein de __DOWNLOAD_DIR__ (ou __AUDIO_DOWNLOAD_DIR__). Lorsque cette option est activée, une liste déroulante apparaît à côté du bouton "Ajouter" pour spécifier le répertoire de téléchargement. `true` par défaut.
* __CREATE_CUSTOM_DIRS__: activation ou non de la création automatique de répertoires dans le __DOWNLOAD_DIR__ (ou __AUDIO_DOWNLOAD_DIR__) s'ils n'existent pas. Lorsque cette option est activée, le sélecteur de répertoire de téléchargement prend en charge la saisie de texte libre et le répertoire spécifié est créé de manière récursive. `true` par défaut.
* __STATE_DIR__: chemin où les fichiers de persistance de la file d'attente seront sauvegardés. `/downloads/.metube` par défaut dans l'image docker, sinon `.`.
* __TEMP_DIR__: chemin où les fichiers de téléchargement intermédiaires seront sauvegardés. `/downloads` par défaut dans l'image docker, sinon `.`.
  * Définissez un système de fichier SSD ou RAM (ex., `tmpfs`) pour de meilleur performances
  * __Note__: L'utilisation d'un système de fichier RAM peut empêcher la reprise des téléchargements
* __DELETE_FILE_ON_TRASHCAN__: si `true`, les fichiers téléchargés sont supprimés du serveur lorsqu'ils sont mis à la corbeille depuis la section "Achevé" sur l'interface utilisateur. `false` par défaut.
* __URL_PREFIX__: chemin de base pour le serveur web (à utiliser lors d'un hébergement derrière un reverse proxy). `/` par défaut.
* __PUBLIC_HOST_URL__: URL de base utilisée pour les liens de téléchargement affichés dans l’interface. Par défaut, MeTube sert les fichiers à partir de sa propre URL. Si votre répertoire de téléchargement est accessible via une autre URL (par exemple via un reverse proxy ou un serveur web tiers), utilisez cette variable pour la modifier.
* __HTTPS__: utilise `https` au lieu de `http` (les variables __CERTFILE__ et __KEYFILE__ sont alors requises). `false` par défaut.
* __CERTFILE__: chemin vers le fichier de certificat SSL à utiliser avec HTTPS.
* __KEYFILE__: chemin vers la clé privée SSL à utiliser avec HTTPS.
* __PUBLIC_HOST_AUDIO_URL__: identique à __PUBLIC_HOST_URL__, mais s'applique uniquement aux téléchargements audio.
* __OUTPUT_TEMPLATE__: modèle utilisé pour nommer les fichiers téléchargés, selon [cette spécification](https://github.com/yt-dlp/yt-dlp/blob/master/README.md#output-template). `%(title)s.%(ext)s` par défaut.
* __OUTPUT_TEMPLATE_CHAPTER__: modèle utilisé pour nommer les fichiers quand ils sont découpés par chapitres via les post-traitements. `%(title)s - %(section_number)s %(section_title)s.%(ext)s` par défaut.
* __OUTPUT_TEMPLATE_PLAYLIST__: modèle utilisé pour nommer les fichiers lorsqu’ils proviennent d’une playlist. `%(playlist_title)s/%(title)s.%(ext)s` par défaut. Si vide, c’est __OUTPUT_TEMPLATE__ qui est utilisé.
* __DEFAULT_OPTION_PLAYLIST_STRICT_MODE__: si `true`, l’option "Mode Playlist strict" sera activée par défaut. Dans ce mode, les playlists ne seront téléchargées que si l’URL correspond strictement à une playlist. Les vidéos individuelles dans une playlist seront traitées comme des vidéos seules. `false` par défaut.
* __DEFAULT_OPTION_PLAYLIST_ITEM_LIMIT__: nombre maximum d’éléments d’une playlist pouvant être téléchargés. `0` par défaut (pas de limite).
* __YTDL_OPTIONS__: options supplémentaires à transmettre à `yt-dlp`, au format JSON. [Voir les options disponibles ici](https://github.com/yt-dlp/yt-dlp/blob/master/yt_dlp/YoutubeDL.py#L220). Ces options correspondent en grande partie à celles de la ligne de commande, mais certaines doivent être adaptées (par exemple, `--recode-video` doit être passé via les `postprocessors`). Les tirets sont remplacés par des underscores. Ce [script](https://github.com/yt-dlp/yt-dlp/blob/master/devscripts/cli_to_api.py) peut vous aider à convertir les options CLI.
* __YTDL_OPTIONS_FILE__: chemin vers un fichier JSON contenant des options `yt-dlp`. Si à la fois __YTDL_OPTIONS_FILE__ et __YTDL_OPTIONS__ sont définis, __YTDL_OPTIONS__ prend le dessus.
* __ROBOTS_TXT__: chemin vers un fichier `robots.txt` monté dans le conteneur.
* __DOWNLOAD_MODE__: contrôle la façon dont les téléchargements sont planifiés et exécutés. Trois modes sont disponibles : `sequential`, `concurrent`, et `limited`. `limited` par défaut :
  * `sequential` : un téléchargement à la fois. Le suivant ne commence qu'une fois le précédent terminé. Idéal pour limiter l’utilisation des ressources ou maintenir un ordre précis.
  * `concurrent` : tous les téléchargements commencent immédiatement, sans limite. Peut surcharger votre système si trop de téléchargements sont lancés à la fois.
  * `limited` : les téléchargements commencent en parallèle mais sont limités à un nombre maximum simultané via un sémaphore.
* __MAX_CONCURRENT_DOWNLOADS__: utilisé uniquement si __DOWNLOAD_MODE__ est `limited`. Définit le nombre maximal de téléchargements simultanés. Par exemple, si réglé à `5`, seuls cinq téléchargements seront actifs en même temps, les suivants seront mis en attente. `3` par défaut.

> ⚠️ **Remarque** : Traduction en cours. La suite du README n'a pas encore été traduite.

The project's Wiki contains examples of useful configurations contributed by users of MeTube:
* [YTDL_OPTIONS Cookbook](https://github.com/alexta69/metube/wiki/YTDL_OPTIONS-Cookbook)
* [OUTPUT_TEMPLATE Cookbook](https://github.com/alexta69/metube/wiki/OUTPUT_TEMPLATE-Cookbook)

## Using browser cookies

In case you need to use your browser's cookies with MeTube, for example to download restricted or private videos:

* Add the following to your docker-compose.yml:

```yaml
    volumes:
      - /path/to/cookies:/cookies
    environment:
      - YTDL_OPTIONS={"cookiefile":"/cookies/cookies.txt"}
```

* Install in your browser an extension to extract cookies:
  * [Firefox](https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/)
  * [Chrome](https://chrome.google.com/webstore/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)
* Extract the cookies you need with the extension and rename the file `cookies.txt`
* Drop the file in the folder you configured in the docker-compose.yml above
* Restart the container

## Browser extensions

Browser extensions allow right-clicking videos and sending them directly to MeTube. Please note that if you're on an HTTPS page, your MeTube instance must be behind an HTTPS reverse proxy (see below) for the extensions to work.

__Chrome:__ contributed by [Rpsl](https://github.com/rpsl). You can install it from [Google Chrome Webstore](https://chrome.google.com/webstore/detail/metube-downloader/fbmkmdnlhacefjljljlbhkodfmfkijdh) or use developer mode and install [from sources](https://github.com/Rpsl/metube-browser-extension).

__Firefox:__ contributed by [nanocortex](https://github.com/nanocortex). You can install it from [Firefox Addons](https://addons.mozilla.org/en-US/firefox/addon/metube-downloader) or get sources from [here](https://github.com/nanocortex/metube-firefox-addon).

## iOS Shortcut

[rithask](https://github.com/rithask) created an iOS shortcut to send URLs to MeTube from Safari. Enter the MeTube instance address when prompted which will be saved for later use. You can run the shortcut from Safari’s share menu. The shortcut can be downloaded from [this iCloud link](https://www.icloud.com/shortcuts/66627a9f334c467baabdb2769763a1a6).

## iOS Compatibility

iOS has strict requirements for video files, requiring h264 or h265 video codec and aac audio codec in MP4 container. This can sometimes be a lower quality than the best quality available. To accommodate iOS requirements, when downloading a MP4 format you can choose "Best (iOS)" to get the best quality formats as compatible as possible with iOS requirements.

To force all downloads to be converted to an iOS compatible codec insert this as an environment variable 

```yaml
  environment:
    - 'YTDL_OPTIONS={"format": "best", "exec": "ffmpeg -i %(filepath)q -c:v libx264 -c:a aac %(filepath)q.h264.mp4"}'
```

## Bookmarklet

[kushfest](https://github.com/kushfest) has created a Chrome bookmarklet for sending the currently open webpage to MeTube. Please note that if you're on an HTTPS page, your MeTube instance must be configured with `HTTPS` as `true` in the environment, or be behind an HTTPS reverse proxy (see below) for the bookmarklet to work.

GitHub doesn't allow embedding JavaScript as a link, so the bookmarklet has to be created manually by copying the following code to a new bookmark you create on your bookmarks bar. Change the hostname in the URL below to point to your MeTube instance.

```javascript
javascript:!function(){xhr=new XMLHttpRequest();xhr.open("POST","https://metube.domain.com/add");xhr.withCredentials=true;xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function(){if(xhr.status==200){alert("Sent to metube!")}else{alert("Send to metube failed. Check the javascript console for clues.")}}}();
```

[shoonya75](https://github.com/shoonya75) has contributed a Firefox version:

```javascript
javascript:(function(){xhr=new XMLHttpRequest();xhr.open("POST","https://metube.domain.com/add");xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function(){if(xhr.status==200){alert("Sent to metube!")}else{alert("Send to metube failed. Check the javascript console for clues.")}}})();
```

The above bookmarklets use `alert()` as a success/failure notification. The following will show a toast message instead:

Chrome:

```javascript
javascript:!function(){function notify(msg) {var sc = document.scrollingElement.scrollTop; var text = document.createElement('span');text.innerHTML=msg;var ts = text.style;ts.all = 'revert';ts.color = '#000';ts.fontFamily = 'Verdana, sans-serif';ts.fontSize = '15px';ts.backgroundColor = 'white';ts.padding = '15px';ts.border = '1px solid gainsboro';ts.boxShadow = '3px 3px 10px';ts.zIndex = '100';document.body.appendChild(text);ts.position = 'absolute'; ts.top = 50 + sc + 'px'; ts.left = (window.innerWidth / 2)-(text.offsetWidth / 2) + 'px'; setTimeout(function () { text.style.visibility = "hidden"; }, 1500);}xhr=new XMLHttpRequest();xhr.open("POST","https://metube.domain.com/add");xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function() { if(xhr.status==200){notify("Sent to metube!")}else {notify("Send to metube failed. Check the javascript console for clues.")}}}();
```

Firefox:

```javascript
javascript:(function(){function notify(msg) {var sc = document.scrollingElement.scrollTop; var text = document.createElement('span');text.innerHTML=msg;var ts = text.style;ts.all = 'revert';ts.color = '#000';ts.fontFamily = 'Verdana, sans-serif';ts.fontSize = '15px';ts.backgroundColor = 'white';ts.padding = '15px';ts.border = '1px solid gainsboro';ts.boxShadow = '3px 3px 10px';ts.zIndex = '100';document.body.appendChild(text);ts.position = 'absolute'; ts.top = 50 + sc + 'px'; ts.left = (window.innerWidth / 2)-(text.offsetWidth / 2) + 'px'; setTimeout(function () { text.style.visibility = "hidden"; }, 1500);}xhr=new XMLHttpRequest();xhr.open("POST","https://metube.domain.com/add");xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function() { if(xhr.status==200){notify("Sent to metube!")}else {notify("Send to metube failed. Check the javascript console for clues.")}}})();
```

## Raycast extension

[dotvhs](https://github.com/dotvhs) has created an [extension for Raycast](https://www.raycast.com/dot/metube) that allows adding videos to MeTube directly from Raycast.

## HTTPS support, and running behind a reverse proxy

It's possible to configure MeTube to listen in HTTPS mode. `docker-compose` example:

```yaml
services:
  metube:
    image: ghcr.io/alexta69/metube
    container_name: metube
    restart: unless-stopped
    ports:
      - "8081:8081"
    volumes:
      - /path/to/downloads:/downloads
      - /path/to/ssl/crt:/ssl/crt.pem
      - /path/to/ssl/key:/ssl/key.pem
    environment:
      - HTTPS=true
      - CERTFILE=/ssl/crt.pem
      - KEYFILE=/ssl/key.pem
```

It's also possible to run MeTube behind a reverse proxy, in order to support authentication. HTTPS support can also be added in this way.

When running behind a reverse proxy which remaps the URL (i.e. serves MeTube under a subdirectory and not under root), don't forget to set the URL_PREFIX environment variable to the correct value.

If you're using the [linuxserver/swag](https://docs.linuxserver.io/general/swag) image for your reverse proxying needs (which I can heartily recommend), it already includes ready snippets for proxying MeTube both in [subfolder](https://github.com/linuxserver/reverse-proxy-confs/blob/master/metube.subfolder.conf.sample) and [subdomain](https://github.com/linuxserver/reverse-proxy-confs/blob/master/metube.subdomain.conf.sample) modes under the `nginx/proxy-confs` directory in the configuration volume. It also includes Authelia which can be used for authentication.

### NGINX

```nginx
location /metube/ {
        proxy_pass http://metube:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
}
```

Note: the extra `proxy_set_header` directives are there to make WebSocket work.

### Apache

Contributed by [PIE-yt](https://github.com/PIE-yt). Source [here](https://gist.github.com/PIE-yt/29e7116588379032427f5bd446b2cac4).

```apache
# For putting in your Apache sites site.conf
# Serves MeTube under a /metube/ subdir (http://yourdomain.com/metube/)
<Location /metube/>
    ProxyPass http://localhost:8081/ retry=0 timeout=30
    ProxyPassReverse http://localhost:8081/
</Location>

<Location /metube/socket.io>
    RewriteEngine On
    RewriteCond %{QUERY_STRING} transport=websocket    [NC]
    RewriteRule /(.*) ws://localhost:8081/socket.io/$1 [P,L]
    ProxyPass http://localhost:8081/socket.io retry=0 timeout=30
    ProxyPassReverse http://localhost:8081/socket.io
</Location>
```

### Caddy

The following example Caddyfile gets a reverse proxy going behind [caddy](https://caddyserver.com).

```caddyfile
example.com {
  route /metube/* {
    uri strip_prefix metube
    reverse_proxy metube:8081
  }
}
```

## Updating yt-dlp

The engine which powers the actual video downloads in MeTube is [yt-dlp](https://github.com/yt-dlp/yt-dlp). Since video sites regularly change their layouts, frequent updates of yt-dlp are required to keep up.

There's an automatic nightly build of MeTube which looks for a new version of yt-dlp, and if one exists, the build pulls it and publishes an updated docker image. Therefore, in order to keep up with the changes, it's recommended that you update your MeTube container regularly with the latest image.

I recommend installing and setting up [watchtower](https://github.com/containrrr/watchtower) for this purpose.

## Troubleshooting and submitting issues

Before asking a question or submitting an issue for MeTube, please remember that MeTube is only a UI for [yt-dlp](https://github.com/yt-dlp/yt-dlp). Any issues you might be experiencing with authentication to video websites, postprocessing, permissions, other `YTDL_OPTIONS` configurations which seem not to work, or anything else that concerns the workings of the underlying yt-dlp library, need not be opened on the MeTube project. In order to debug and troubleshoot them, it's advised to try using the yt-dlp binary directly first, bypassing the UI, and once that is working, importing the options that worked for you into `YTDL_OPTIONS`.

In order to test with the yt-dlp command directly, you can either download it and run it locally, or for a better simulation of its actual conditions, you can run it within the MeTube container itself. Assuming your MeTube container is called `metube`, run the following on your Docker host to get a shell inside the container:

```bash
docker exec -ti metube sh
cd /downloads
```

Once there, you can use the yt-dlp command freely.

## Submitting feature requests

MeTube development relies on code contributions by the community. The program as it currently stands fits my own use cases, and is therefore feature-complete as far as I'm concerned. If your use cases are different and require additional features, please feel free to submit PRs that implement those features. It's advisable to create an issue first to discuss the planned implementation, because in an effort to reduce bloat, some PRs may not be accepted. However, note that opening a feature request when you don't intend to implement the feature will rarely result in the request being fulfilled.

## Building and running locally

Make sure you have node.js and Python 3.11 installed.

```bash
cd metube/ui
# install Angular and build the UI
npm install
node_modules/.bin/ng build
# install python dependencies
cd ..
pip3 install pipenv
pipenv install
# run
pipenv run python3 app/main.py
```

A Docker image can be built locally (it will build the UI too):

```bash
docker build -t metube .
```

## Development notes

* The above works on Windows and macOS as well as Linux.
* If you're running the server in VSCode, your downloads will go to your user's Downloads folder (this is configured via the environment in .vscode/launch.json).
