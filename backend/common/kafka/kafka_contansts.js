// TODO : Change localhost to kafka if you want to run it with Docker
const KAFKA_BROKER_URL = 'localhost:9092';
const KAFKA_CLIENT_ID = 'deploystack';
const KAFKA_TOPIC_DEPLOYMENT = 'deployment';
const KAFKA_PRODUCER = 'deployment-producer';
const KAFKA_CONSUMER_CLIENT_ID = 'deployment-consumer-client';
const KAFKA_CONSUMER_GROUP = 'deployment-consumer-group';
const KAFKA_CONSUMER = 'deployment-consumer';

module.exports = {
    KAFKA_BROKER_URL,
    KAFKA_CLIENT_ID,
    KAFKA_TOPIC_DEPLOYMENT,
    KAFKA_PRODUCER,
    KAFKA_CONSUMER_CLIENT_ID,
    KAFKA_CONSUMER_GROUP,
    KAFKA_CONSUMER,
};
