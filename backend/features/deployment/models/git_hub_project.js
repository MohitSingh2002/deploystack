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

gitHubProjectSchema.set('toJSON', {
  transform: function (doc, ret) {
    if (ret.createdAt) {
      ret.createdAt = ret.createdAt.toISOString();
    }
    if (ret.updatedAt) {
      ret.updatedAt = ret.updatedAt.toISOString();
    }
    return ret;
  }
});

const GitHubProject = mongoose.model('GitHubProject', gitHubProjectSchema);
module.exports = GitHubProject;
