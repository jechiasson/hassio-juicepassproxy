#!/usr/bin/env bashio

export MQTT_HOST="$(bashio::config 'mqtt_host')"
export MQTT_PORT="$(bashio::config 'mqtt_port')"
export MQTT_USER="$(bashio::config 'mqtt_username')"
export MQTT_PASS="$(bashio::config 'mqtt_password')"
export IGNORE_ENELX="$(bashio::config 'ignore_enelx')"
export JUICEBOX_HOST="$(bashio::config 'juicebox_host')"
export JUICEBOX_ID="$(bashio::config 'juicebox_id')"
export UPDATE_UDPC="$(bashio::config 'update_udpc')"
export JPP_HOST="$(bashio::config 'jpp_host')"
export DEBUG="$(bashio::config 'debug')"

# Patch juicebox_mitm.py to silently drop ZentriOS JSON packets
# Patch juicebox_mitm.py to silently drop ZentriOS JSON packets
python3 -c "
import pathlib
file_path = pathlib.Path('/juicepassproxy/juicebox_mitm.py')
if file_path.exists():
    content = file_path.read_text()
    old_func = 'def _message_decode(self, data):'
    patch_code = 'def _message_decode(self, data):\n        if data.strip().startswith(b\"{\"):\n            return None'
    if old_func in content and 'startswith' not in content:
        file_path.write_text(content.replace(old_func, patch_code))
"

/juicepassproxy/docker_entrypoint.sh