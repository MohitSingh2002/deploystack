const Kafka = require('kafkajs').Kafka;

const { KAFKA_CONSUMER_CLIENT_ID, KAFKA_CONSUMER_GROUP, KAFKA_CONSUMER, KAFKA_BROKER_URL, KAFKA_TOPIC_DEPLOYMENT } = require('./kafka_contansts');

const gitRepoDeployment = require('../helpers/deployment/git_repo_deployment');

// io.to('deployment').emit('deployment-event', event);

async function consumeKafka(io) {
    const kafka = new Kafka({
        clientId: KAFKA_CONSUMER_CLIENT_ID,
        brokers: [KAFKA_BROKER_URL]
    });

    const consumer = kafka.consumer({ groupId: KAFKA_CONSUMER_GROUP });
    await consumer.connect();
    await consumer.subscribe({ topic: KAFKA_TOPIC_DEPLOYMENT, fromBeginning: false });

    await consumer.run({
        autoCommit: true,
        eachMessage: async ({ message }) => {
            const event = JSON.parse(message.value.toString());

            console.log(`👉 Processing: ${event.type}, ${JSON.stringify(event.data)}`);

            if (event.type === 'git-repo-deployment') {
                await gitRepoDeployment(event.data, io);
            }

            console.log('Process Completed');
        },
    });

    // await consumer.run({
    //     autoCommit: false,
    //     eachBatch: async ({batch, resolveOffset, heartbeat, commitOffsetsIfNecessary, }) => {
    //         for (const message of batch.messages) {
    //             const event = JSON.parse(message.value.toString());

    //             console.log(`👉 Processing: ${event.type}, ${JSON.stringify(event.data)}`);

    //             if (event.type === 'git-repo-deployment' && event.data.repoName !== 'JustJava') {
    //                 await gitRepoDeployment(event.data, io);
    //             }

    //             console.log('Process Completed');

    //             resolveOffset(message.offset);

    //             await heartbeat();
    //         }

    //         // // commit after batch processed
    //         await consumer.commitOffsets([
    //             {
    //                 topic: batch.topic,
    //                 partition: batch.partition,
    //                 offset: (Number(batch.lastOffset()) + 1).toString(),
    //             },
    //         ]);
    //     },
    // });
}

module.exports = consumeKafka;
