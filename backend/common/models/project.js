const mongoose = require('mongoose');

const projectSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true
    },
    port: {
        type: String,
        required: false,
        default: ''
    },
    gitHubProject: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'GitHubProject',
        required: false
    }
}, {
    timestamps: true
});

const Project = mongoose.model('Project', projectSchema);
module.exports = Project;
