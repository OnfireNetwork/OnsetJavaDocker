#!/bin/bash
java -jar java/OnsetJava-JNI-0.1.jar
if [ ! -f "server_config.json" ]; then
    IFS=','
    read -ra ARR_PLUGINS <<< "$CONFIG_PLUGINS"
    read -ra ARR_PACKAGES <<< "$CONFIG_PACKAGES"
    IFS=' '
    for p in "${ARR_PLUGINS[@]}"
    do
        export CONFIG_EXTRA_PLUGINS="${CONFIG_EXTRA_PLUGINS},\"${p}\""
    done
    for p in "${ARR_PACKAGES[@]}"
    do
        export CONFIG_EXTRA_PACKAGES="${CONFIG_EXTRA_PACKAGES},\"${p}\""
    done
    (cat /files/server_config.json.source | envsubst) > server_config.json
fi
if [ ! -f "plugins/OnsetJavaPlugin.so" ]; then
    cp /files/OnsetJavaPlugin.so plugins/
fi
