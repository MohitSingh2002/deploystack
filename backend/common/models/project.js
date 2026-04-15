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

projectSchema.set('toJSON', {
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

const Project = mongoose.model('Project', projectSchema);
module.exports = Project;
