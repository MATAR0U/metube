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


if [[ "${CUSTOM_COLOR}" =~ ^#[a-fA-F0-9]{3,6}$ ]]; then
    color=${CUSTOM_COLOR#"#"}

    r_hex=${color:0:2}
    g_hex=${color:2:2}
    b_hex=${color:4:2}

    r_dec=$((16#${r_hex}))
    g_dec=$((16#${g_hex}))
    b_dec=$((16#${b_hex}))

    factor=0.6

    r_new=$(printf "%.0f" "$(echo "$r_dec * $factor" | bc -l)")
    g_new=$(printf "%.0f" "$(echo "$g_dec * $factor" | bc -l)")
    b_new=$(printf "%.0f" "$(echo "$b_dec * $factor" | bc -l)")

    (( r_new < 0 )) && r_new=0
    (( g_new < 0 )) && g_new=0
    (( b_new < 0 )) && b_new=0
    (( r_new > 255 )) && r_new=255
    (( g_new > 255 )) && g_new=255
    (( b_new > 255 )) && b_new=255

    r_hex_new=$(printf "%02x" $r_new)
    g_hex_new=$(printf "%02x" $g_new)
    b_hex_new=$(printf "%02x" $b_new)

    darker_color="#${r_hex_new}${g_hex_new}${b_hex_new}"

    sed -i "s|#0d6efd|${CUSTOM_COLOR}|g" /app/ui/dist/metube/styles*css
    sed -i "s|#0b5ed7|${darker_color}|g" /app/ui/dist/metube/styles*css
    sed -i "s|#0a58ca|${darker_color}|g" /app/ui/dist/metube/styles*css
    sed -i "s|#0a53be|${darker_color}|g" /app/ui/dist/metube/styles*css
    sed -i "s|#198754|${darker_color}|g" /app/ui/dist/metube/styles*css
else
    exit 1
fi


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