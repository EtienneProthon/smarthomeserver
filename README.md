# smarthomeserver
A simple setup for your own smart home server (on a Raspberry Pi)

## Setup

```
# Set a fix ip for your Raspberry Pi using network manager
sudo nmcli c mod 'Wired connection 1' ipv4.addresses YOUR_IP/24 ipv4.method manual
# Allow access to memory usage metrics
sudo vi /boot/cmdline.txt
# Add `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1` at the end of the line
# Install docker
# Activate loki plugin for docker 
docker plugin install grafana/loki-docker-driver:arm-v7 --alias loki --grant-all-permissions
```


```
# Create a folder to host all docker_data
sudo mkdir /docker_data
# Give your current user and group
sudo chown -R $USER /docker_data 
sudo chgrp -R $GROUPS /docker_data
# Run the setup script
./setup.sh
# Run the docker compose
sudo docker compose -f smarthome.yml up -d
# Create mosquitto password (check mosquitto container name with sudo docker ps)
sudo docker exec -it smarthomeserver-mosquitto-1 sh
mosquitto_passwd -c /mosquitto/config/password.txt myuser
# Set your env var in the .env file and update the config with
sudo docker compose -f smarthome.yml up -d
```
- Go at YOUR_SERVER_IP:9080

## Why you need your own smart home server
The smart home market is really fragmented. Using different gateways and Apps from different ecosystems can be annoying, expansive and might not work very well together. Instead I suggest using a custom smart home server with some open source software that can replace all your hubs and give you access to one system to control it all.

## The hardware
I am running this on a Raspberry Pi but as these are Docker containers you can run them on pretty much any platform.

## Login
I recommend accessing your Pi/server via SSH. If you do make sure to configure it for save usage and change the standard password! It is recommended to use login via SSH keys. I described how to set that up [here](https://thesmarthomejourney.com/2022/11/26/how-to-ssh-into-your-server/)

## How to get started
Create a folder to hold all your docker data. Then clone this repository and update the .env file. Change the password and IDs and update the path to the folder you just created. Make sure that the data folder belongs to the same user/group ids you are providing in the .env file. If you see any errors errors in the container logs about `Permission denied` or similar then you have to check if that subfolder in your datafolder belongs to the same user the container is using. If you still run into problems add user: `${PUID}:${PGID}` to the container definition to force it to use that user.

Be sure to update the email related settings if you want to use notifications for automatic container updates. If you have done that uncomment the `WATCHTOWER_NOTIFICATIONS` related variables in the hosting.yml file.

If you want to use Loki/Grafana to see all logs in one place you need to also copy the loki-configuration.yaml file to `${DATADIR}/loki/config/loki-config.yaml`. You need to also install the Loki logging driver or remove the logging commands from the compose files. The installation can be done via
```
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
// or if you are running this on a Raspberry Pi
docker plugin install grafana/loki-docker-driver:arm-v7 --alias loki --grant-all-permissions
```
Alternatively if you are going to use promtail to ingest the logs you need to also copy the promtail-config.yaml file to `${DATADIR}/promtail/config/promtail-config.yaml` and remove the `logging:` parts in the compose yaml files.

If you want to use monitoring of your containers and host system via prometheus you should also create a config directory for that and copy the config file from this repository like
```
mkdir /some/data/dir/prometheus/etc
cp prometheus_config.yaml ${DATADIR}/prometheus/etc/prometheus.yml
```

If you want to use the Mosquitto MQTT broker make sure to also copy the provided configuration file like
```
cp mosquitto.conf ${DATADIR}/mosquitto/config
```

If you want to use Zigbee2MQTT do not forget to copy the config file and update it via
```
cp zigbee2mqtt_configuration.yaml ${DATADIR}/zigbee2mqtt/data/configuration.yaml
```
and update the IP of your Zigbee bridge (if you use a networked one) or switch to serial port in the same config file. Also make sure to update the `devices:` entry in your `smarthome.yml` file to pass the right serial device to your Docker container in that case.

Then you can start the containers via docker compose.
```
docker-compose -f hosting.yml up -d
docker-compose -f smarthome.yml up -d
docker-compose -f monitoring.yml up -d

// to see logs (some will only be available via Grafana, see below)
docker-compose -f ...yml logs -f
// to see if containers are running
docker-compose -f ...yml ps

// to stop
docker-compose -f ...yml down
```

## Which services are included?

In the smarthome.yml:

| Service  | Port |  Setup |
| ------------- | ------------- | ------------- |
| Mosquitto  | 1883  | You need to copy the config file above. Can be accessed with a MQTT client like MQTT explorer |
| InfluxDB  | only internally available from other containers  | - |
| Grafana | 3000  | Setup can be done according to my [Grafana dashboard guide](https://thesmarthomejourney.com/2020/07/20/smart-home-dashboards-grafana/). You can use this to view logs according to [the Loki guide](https://thesmarthomejourney.com/2021/08/23/loki-grafana-log-aggregation/) |
| TasmoAdmin  | 3080  | just let it scan your network for devices |
| Zigbee2MQTT  | -  | Setup can be done according to my [Zigbee2MQTT guide](https://thesmarthomejourney.com/2022/07/19/zigbee2mqtt-quick-start-guide/) |
| Zigbee2MQTTAssistant  | 8880  | [More info](https://thesmarthomejourney.com/2021/01/13/zigbee2mqttassistant/) |
| HomeAssistant  | 8123  | Just go to the webpage and follow the setup wizard |

In the hosting.yml:

| Service  | Port |  Setup |
| ------------- | ------------- | ------------- |
| Heimdall  | 9080  | - |
| PiHole  | 6080  | There is a nice in-depth guide [here](https://www.smarthomebeginner.com/pi-hole-setup-guide/) |
| Adguard Home | 3380 | You can follow my setup guide [here](https://thesmarthomejourney.com/2021/05/24/adguard-pihole-dns-ad-blocker/)|
| Unifi controller | 8080  | Just follow the setup wizard |
| Watchtower | - | This is set up according to my [Watchtower guide](https://thesmarthomejourney.com/2021/03/01/watchtower-docker-auto-updates/) |
| Loki | 3100 | This is set up according to my [Loki guide](https://thesmarthomejourney.com/2021/08/23/loki-grafana-log-aggregation/) |
| Duplicati | 8200 | This allows you to back up any data from your Docker containers. More details [here](https://thesmarthomejourney.com/2022/04/04/home-assistant-docker-backup/) |

In the monitoring.yml
| Service  | Port |  Setup |
| ------------- | ------------- | ------------- |
| Prometheus  | 9090  | There is a full explanation [here](https://thesmarthomejourney.com/2022/07/25/monitoring-smarthome-prometheus/) |
| node exporter  | 9100  | No frontend, see prometheus guide |
| cadvisor | 8080 | No frontend, see prometheus guide|

You should only use one adblocker (Adguard Home or PiHole) at a time as they use the same ports. If you want to run a second Adguard Home instance somewhere else as a backup and still keep the setting in sync then follow [this article](https://thesmarthomejourney.com/2023/02/12/adguardhome-sync-instances/). The needed container is already in the hosting.yml file.

## Logging
If something is not working, check the logs first! Some service logs can only be viewed directly via `docker logs containername` or `docker-compose -f yamlname.yaml logs`. The important services are pushing their logs to Loki which collects all of them. You can use Grafana to view them all. I describe this in more detail [here](https://thesmarthomejourney.com/2021/08/23/loki-grafana-log-aggregation/). You need to install the Loki logging driver (see installation part above) for this to work or slightly change the compose files by removing the custom logging sections.
Loki creates a json file for each services log that is kepts until a restart. Without any restrictions these files can get really big. To avoid this I added a size restriction to the configuration of each service via the `max-size` argument. More details about this can be found [here](https://thesmarthomejourney.com/2022/06/15/loki-log-size-limit/).

## How does it look like? I need more details
You can find more images and a details in my [blog post](https://thesmarthomejourney.com/2021/01/09/custom-smart-home-server-hub/)
