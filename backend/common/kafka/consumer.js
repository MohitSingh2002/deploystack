const Kafka = require('kafkajs').Kafka;

const { KAFKA_CONSUMER_CLIENT_ID, KAFKA_CONSUMER_GROUP, KAFKA_CONSUMER, KAFKA_BROKER_URL, KAFKA_TOPIC_DEPLOYMENT } = require('./kafka_contansts');

async function consumeKafka() {
    const kafka = new Kafka({
        clientId: KAFKA_CONSUMER_CLIENT_ID,
        brokers: [KAFKA_BROKER_URL]
    });

    const consumer = kafka.consumer({ groupId: KAFKA_CONSUMER_GROUP });
    await consumer.connect();
    await consumer.subscribe({ topic: KAFKA_TOPIC_DEPLOYMENT, fromBeginning: true });

    await consumer.run({
        eachMessage: async ({ topic, partition, message }) => {
            const event = JSON.parse(message.value.toString());
            console.log(`👉 Received event: ${event.type} with data: ${JSON.stringify(event.data)}`);
            // Here you can add logic to handle the event, e.g., trigger deployment
        },
    });
}

module.exports = consumeKafka;
