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

const ProjectDeploymentLog = mongoose.model('ProjectDeploymentLog', projectDeploymentLogSchema);
module.exports = ProjectDeploymentLog;
