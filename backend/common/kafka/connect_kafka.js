const Kafka = require('kafkajs').Kafka;
const { KAFKA_BROKER_URL, KAFKA_CLIENT_ID, KAFKA_TOPIC_DEPLOYMENT } = require('./kafka_contansts');

const kafka = new Kafka({
  clientId: KAFKA_CLIENT_ID,
  brokers: [KAFKA_BROKER_URL]
});

async function connectKafka() {
    const admin = kafka.admin();
    await admin.connect();
    await admin.createTopics({
    topics: [
        {
        topic: KAFKA_TOPIC_DEPLOYMENT,
        numPartitions: 1,
        replicationFactor: 1,
        }
    ],
    waitForLeaders: true,
    });
    console.log('Kafka Connected and Topic Created');
    await admin.disconnect();
}

module.exports = connectKafka;
