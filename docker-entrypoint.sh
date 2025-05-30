#!/bin/sh

echo "Setting umask to ${UMASK}"
umask ${UMASK}
echo "Creating download directory (${DOWNLOAD_DIR}), state directory (${STATE_DIR}), and temp dir (${TEMP_DIR})"
mkdir -p "${DOWNLOAD_DIR}" "${STATE_DIR}" "${TEMP_DIR}"

sed -i "s|{{METUBE_TITLE}}|${METUBE_TITLE}|g" /app/ui/dist/metube/index.html

path_ico="favicon.ico"
path_ico16="assets/icons/favicon-16x16.png"
path_ico32="assets/icons/favicon-32x32.png"

if [ "${CUSTOM_ICO}" = true ]; then
    path_ico="assets/custom/favicon.ico"
    path_ico16="assets/custom/favicon.ico"
    path_ico32="assets/custom/favicon.ico"
fi

sed -i "s|{{CUSTOM_ICO}}|${path_ico}|g" /app/ui/dist/metube/index.html
sed -i "s|{{CUSTOM_ICO16}}|${path_ico16}|g" /app/ui/dist/metube/index.html
sed -i "s|{{CUSTOM_ICO32}}|${path_ico32}|g" /app/ui/dist/metube/index.html

if [ `id -u` -eq 0 ] && [ `id -g` -eq 0 ]; then
    if [ "${UID}" -eq 0 ]; then
        echo "Warning: it is not recommended to run as root user, please check your setting of the UID environment variable"
    fi
    echo "Changing ownership of download and state directories to ${UID}:${GID}"
    chown -R "${UID}":"${GID}" /app "${DOWNLOAD_DIR}" "${STATE_DIR}" "${TEMP_DIR}"
    echo "Running MeTube as user ${UID}:${GID}"
    su-exec "${UID}":"${GID}" python3 app/main.py
else
    echo "User set by docker; running MeTube as `id -u`:`id -g`"
    python3 app/main.py
fi