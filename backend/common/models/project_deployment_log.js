const mongoose = require('mongoose');

const projectDeploymentLogSchema = mongoose.Schema({
    projectId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Project',
        required: true
    },
    logs: {
        type: Buffer,
        required: true
    }
}, {
    timestamps: true
});

projectDeploymentLogSchema.set('toJSON', {
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

const ProjectDeploymentLog = mongoose.model('ProjectDeploymentLog', projectDeploymentLogSchema);
module.exports = ProjectDeploymentLog;
