// TODO : Change localhost to kafka if you want to run it with Docker
const KAFKA_BROKER_URL = 'localhost:9092';
const KAFKA_CLIENT_ID = 'deploystack';
const KAFKA_TOPIC_DEPLOYMENT = 'deployment';
const KAFKA_PRODUCER = 'deployment-producer';
const KAFKA_CONSUMER_CLIENT_ID = 'deployment-consumer-client';
const KAFKA_CONSUMER_GROUP = 'deployment-consumer-group';
const KAFKA_CONSUMER = 'deployment-consumer';
const KAFKA_DEPLOYMENT_COMPLETED = 'deployment-completed';
const KAFKA_DEPLOYMENT_FAILED = 'deployment-failed';
const KAFKA_DEPLOYMENT_EVENT = 'deployment-event';

module.exports = {
    KAFKA_BROKER_URL,
    KAFKA_CLIENT_ID,
    KAFKA_TOPIC_DEPLOYMENT,
    KAFKA_PRODUCER,
    KAFKA_CONSUMER_CLIENT_ID,
    KAFKA_CONSUMER_GROUP,
    KAFKA_CONSUMER,
    KAFKA_DEPLOYMENT_COMPLETED,
    KAFKA_DEPLOYMENT_FAILED,
    KAFKA_DEPLOYMENT_EVENT,
};
