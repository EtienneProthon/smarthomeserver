
mkdir -p ${DATADIR}/loki/config && cp config/loki-config.yaml ${DATADIR}/loki/config/loki-config.yaml
mkdir -p ${DATADIR}/prometheus/etc && cp config/prometheus_config.yaml ${DATADIR}/prometheus/etc/prometheus.yml
mkdir -p ${DATADIR}/mosquitto && cp config/mosquitto.conf ${DATADIR}/mosquitto/config
mkdir -p ${DATADIR}/zigbee2mqtt/data && cp config/zigbee2mqtt_configuration.yaml ${DATADIR}/zigbee2mqtt/data/configuration.yaml
