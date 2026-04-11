const Kafka = require('kafkajs').Kafka;

const { KAFKA_PRODUCER, KAFKA_BROKER_URL, KAFKA_TOPIC_DEPLOYMENT } = require('./kafka_contansts');

async function productDeploymentEvent(event) {
    const kafka = new Kafka({
        clientId: KAFKA_PRODUCER,
        brokers: [KAFKA_BROKER_URL]
    });

    const producer = kafka.producer();
    await producer.connect();

    await producer.send({
        topic: KAFKA_TOPIC_DEPLOYMENT,
        messages: [
            { value: JSON.stringify(event) }
        ]
    });

    await producer.disconnect();
}

module.exports = productDeploymentEvent;
