const mongoose = require('mongoose');

const gitSchema = mongoose.Schema({
    id: {
        type: String,
        default: ''
    },
    name: {
        type: String,
        default: ''
    },
    slug: {
        type: String,
        default: ''
    },
    webhookSecret: {
        type: String,
        default: ''
    },
    pem: {
        type: String,
        default: ''
    },
    installationId: {
        type: String,
        default: ''
    }
});

const Git = mongoose.model('Git', gitSchema);
module.exports = Git;
