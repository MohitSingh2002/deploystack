const Kafka = require('kafkajs').Kafka;

const { KAFKA_CONSUMER_CLIENT_ID,
    KAFKA_CONSUMER_GROUP,
    KAFKA_CONSUMER,
    KAFKA_BROKER_URL,
    KAFKA_TOPIC_DEPLOYMENT,
    KAFKA_DEPLOYMENT_COMPLETED,
    KAFKA_DEPLOYMENT_FAILED,
    KAFKA_DEPLOYMENT_EVENT } = require('./kafka_contansts');

const gitRepoDeployment = require('../helpers/deployment/git_repo_deployment');

const { clearLogs, logDeployment } = require('../helpers/log_deployment');

async function runWithHeartbeat(task, heartbeat) {
  const interval = setInterval(() => {
    heartbeat().catch(() => {});
  }, 3000);

  try {
    return await task();
  } finally {
    clearInterval(interval);
  }
}

async function consumeKafka(io) {
    const kafka = new Kafka({
        clientId: KAFKA_CONSUMER_CLIENT_ID,
        brokers: [KAFKA_BROKER_URL]
    });

    const consumer = kafka.consumer({ groupId: KAFKA_CONSUMER_GROUP, maxPollInterval: 600000 });
    await consumer.connect();
    await consumer.subscribe({ topic: KAFKA_TOPIC_DEPLOYMENT, fromBeginning: false });

    await consumer.run({
        autoCommit: false,

        eachBatch: async ({
            batch,
            resolveOffset,
            heartbeat,
            commitOffsetsIfNecessary
        }) => {

            for (const message of batch.messages) {
                const event = JSON.parse(message.value.toString());

                console.log(`👉 Processing: ${message.offset}, ${event.type}, ${JSON.stringify(event.data)}`);

                try {
                    if (event.type === 'git-repo-deployment') {
                        // await gitRepoDeployment(event.data, io);
                        clearLogs();
                        await runWithHeartbeat(
                            () => gitRepoDeployment(event.data, io),
                            heartbeat
                        );
                    }

                    resolveOffset(message.offset);

                    await heartbeat();

                    logDeployment('\nProcess Completed');
                    console.log('Process Completed');
                } catch (err) {
                    logDeployment('\n' + JSON.stringify(err.message));
                    console.error("Deployment failed:", err.message);
                    resolveOffset(message.offset);
                    await heartbeat();
                }
            }

            // await commitOffsetsIfNecessary();
            await consumer.commitOffsets([
                {
                    topic: batch.topic,
                    partition: batch.partition,
                    offset: (Number(batch.lastOffset()) + 1).toString(),
                },
            ]);
        }
        });

    // await consumer.run({
    //     autoCommit: true,
    //     eachMessage: async ({ message }) => {
    //         const event = JSON.parse(message.value.toString());

    //         console.log(`👉 Processing: ${message.offset}, ${event.type}, ${JSON.stringify(event.data)}`);

    //         try {
    //             if (event.type === 'git-repo-deployment') {
    //                 await gitRepoDeployment(event.data, io);
    //             }

    //             io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, KAFKA_DEPLOYMENT_COMPLETED);
    //         } catch (err) {
    //             console.error(`Deployment Failed : ${JSON.stringify(err.message)}`);
    //             io.to(KAFKA_TOPIC_DEPLOYMENT).emit(KAFKA_DEPLOYMENT_EVENT, KAFKA_DEPLOYMENT_FAILED);
    //         }

    //         console.log('Process Completed');
    //     },
    // });
}

module.exports = consumeKafka;
