source .env
sudo mkdir -p $DATADIR/loki/config && sudo cp config/loki-config.yaml $DATADIR/loki/config/loki-config.yaml
sudo mkdir -p $DATADIR/prometheus/etc && sudo cp config/prometheus_config.yaml $DATADIR/prometheus/etc/prometheus.yml
sudo mkdir -p $DATADIR/mosquitto && sudo cp config/mosquitto.conf $DATADIR/mosquitto/config/mosquitto.conf
sudo mkdir -p $DATADIR/zigbee2mqtt/data && sudo cp config/zigbee2mqtt_configuration.yaml $DATADIR/zigbee2mqtt/data/configuration.yaml
