# OnsetJavaDocker
A docker container for OnsetJava

## Usage

### Basic Run Command
This command starts a bare metal Onset Server with just OnsetJava.
```
docker run -d -it --name myonsetserver -p 7777:7777/udp -p 7776:7776 -p 7775:7775 janbebendorf/onsetjava
```

### Config
The configuration is auto-generated using environment variables
The following environment variables are available

- CONFIG_SERVERNAME="Onset Java Server"
- CONFIG_SERVERNAME_SHORT="Onset Java Server"
- CONFIG_GAMEMODE="OnsetJava"
- CONFIG_WEBSITE_URL="https://github.com/OnfireNetwork/OnsetJava"
- CONFIG_MAX_PLAYERS=300
- CONFIG_PASSWORD=""
- CONFIG_TIMEOUT=15000
- CONFIG_IPLIMIT=5
- CONFIG_MASTERLIST=false
- CONFIG_VOICE=true
- CONFIG_VOICE_SAMPLE_RATE=24000
- CONFIG_VOICE_3D=true
- CONFIG_STREAM_DISTANCE_PLAYER=12000
- CONFIG_STREAM_RATE_PLAYER=0.05
- CONFIG_STREAM_DISTANCE_VOICE=5000
- CONFIG_STREAM_RATE_VOICE=0.8
- CONFIG_STREAM_DISTANCE_VEHICLE=12000
- CONFIG_STREAM_RATE_VEHICLE=0.1
- CONFIG_STREAM_DISTANCE_OBJECT=12000
- CONFIG_STREAM_RATE_OBJECT=0.1
- CONFIG_STREAM_DISTANCE_NPC=12000
- CONFIG_STREAM_RATE_NPC=0.1
- CONFIG_STREAM_DISTANCE_PICKUP=12000
- CONFIG_STREAM_RATE_PICKUP=0.1
- CONFIG_STREAM_DISTANCE_DOOR=12000
- CONFIG_STREAM_RATE_DOOR=0.1
- CONFIG_STREAM_DISTANCE_TEXT3D=12000
- CONFIG_STREAM_RATE_TEXT3D=0.1

#### Plugins and Packages
To add plugins and packages to the config you can use a comma seperated list in `CONFIG_PLUGINS` and `CONFIG_PACKAGES`

### Binding Paths
The server is located in `/server` in the container.
You can bind any file or directory in that folder except server_config.json as this is auto generated and shouldn't be touched manually.
