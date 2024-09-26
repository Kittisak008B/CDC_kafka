# CDC_kafka

## VM
#### Update the package list
```bash
sudo apt update
```
#### Install Git
```bash
sudo apt install git
```
#### Install Docker 
```bash
curl -fsSL https://get.docker.com | sh
```
```bash
sudo usermod -aG docker $USER
```
```bash
newgrp docker
```
#### Verify Docker Installation and Test 
```bash
docker --version
```
```bash
docker run hello-world
```
#### Check Disk Space
```bash
df -h
```
```bash
git clone https://github.com/Kittisak008B/CDC_kafka.git
cd CDC_kafka/
docker compose up -d
docker ps -a
```

#### mysql-source.json
```
{
  "name": "mysql-source-kafka",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "[PUBLIC_IP_ADDRESS]",
    "database.port": "3306",
    "database.user": "[USER]",
    "database.password": "[PASSWORD]",
    "database.server.name": "[INSTANCE_ID]",
    "table.whitelist": "[DATABASE_NAME].[TABLE_NAME]",
    "database.history.kafka.bootstrap.servers": "broker:9092",
    "database.history.kafka.topic": "[TABLE_NAME]",
    "decimal.handling.mode": "double",
    "include.schema.changes": "true",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter.schema.registry.url": "http://schema-registry:8081"
  }
}
```
#### add source connector
```bash
curl -i -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8083/connectors/ -d @mysql-source.json
```
#### mysql-sink-kafka.json
```
{
    "name": "mysql-sink-kafka",
    "config": {
      "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
      "task.max": "1",
      "topics": "", #sink มาจาก topicอะไร
      "key.converter": "io.confluent.connect.avro.AvroConverter",
      "value.converter": "io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url": "http://schema-registry:8081",
      "value.converter.schema.registry.url": "http://schema-registry:8081",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
      "transforms.unwrap.drop.tombstones": "false",
      "key.converter.schemas.enable": "true",
      "errors.tolerance": "all",
      "errors.log.include.messages": true,
      "connection.attempts": "6",
      "connection.backoff.ms": "1000",
      "connection.url": "jdbc:mysql://[PUBLIC_IP_ADDRESS]:3306/[DATABASE_NAME]?nullCatalogMeansCurrent=true&autoReconnect=true&useSSL=false",
      "connection.user": "[USER]",
      "connection.password": "[PASSWORD]",
      "dialect.name": "MySqlDatabaseDialect",
      "insert.mode": "upsert",
      "delete.enabled" : "true",
      "batch.size": "2",
      "table.name.format": "[TABLE_NAME]",
      "table.whitelist": "[DATABASE_NAME].[TABLE_NAME]",
      "pk.mode": "record_key",
      "pk.fields": "[PRIMARY_KEY]",
      "auto.create": "true",
      "auto.evolve": "true",
      "db.timezone": "Asia/Bangkok"
    }
  }
```
#### add sink connector
```bash
curl -i -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8083/connectors/ -d @mysql-sink-kafka.json
```

#### execute a command in a running container
```bash
docker exec -it connect bash
```
$`ls -lrt /usr/share/confluent-hub-components` <br>
$`exit`

#### find file
```bash
ls -lrt -R | grep "mysql-connector-java-8.0.13.jar"
```
#### check container log
```bash
docker logs [CONTAINER_NAME]
docker logs connect | grep mysql-sink-kafka
```
```bash
docker compose down --volumes --rmi all
```

- Zookeeper: Manages Kafka brokers.
- Kafka Broker: Processes and stores messages in topics.
- Schema Registry: Manages and validates message schemas.
- Kafka Connect: Integrates Kafka with external systems.
- Control Center: Web UI for managing Kafka.
- ksqlDB: SQL engine for stream processing.
