const mongoose = require('mongoose');

const gitHubProjectSchema = mongoose.Schema({
    fullName: {
        type: String,
        required: true
    },
    cloneUrl: {
        type: String,
        required: true
    },
    ownerName: {
        type: String,
        required: true
    },
    repoName: {
        type: String,
        required: true
    },
    branchName: {
        type: String,
        required: true
    }
}, {
    timestamps: true
});

const GitHubProject = mongoose.model('GitHubProject', gitHubProjectSchema);
module.exports = GitHubProject;
