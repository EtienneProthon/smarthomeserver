source .env
mkdir -p $DATADIR/grafana/data 
mkdir -p $DATADIR/diun/data 
mkdir -p $DATADIR/nodered/data 
mkdir -p $DATADIR/homepage && cp config/homepage-docker.yaml $DATADIR/homepage/docker.yaml
mkdir -p $DATADIR/loki/data && mkdir -p $DATADIR/loki/config && cp config/loki-config.yaml $DATADIR/loki/config/loki-config.yaml
mkdir -p $DATADIR/prometheus/etc && mkdir -p $DATADIR/prometheus/data && cp config/prometheus_config.yaml $DATADIR/prometheus/etc/prometheus.yml
mkdir -p $DATADIR/mosquitto/config && mkdir -p $DATADIR/mosquitto/log && mkdir -p $DATADIR/mosquitto/data && cp config/mosquitto.conf $DATADIR/mosquitto/config/mosquitto.conf
mkdir -p $DATADIR/zigbee2mqtt/data && cp config/zigbee2mqtt_configuration.yaml $DATADIR/zigbee2mqtt/data/configuration.yaml
