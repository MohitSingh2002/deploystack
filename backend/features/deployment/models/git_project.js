const mongoose = require('mongoose');

const gitProjectSchema = mongoose.Schema({
    cloneUrl: {
        type: String,
        required: true
    }
}, {
    timestamps: true
});

gitProjectSchema.set('toJSON', {
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

const GitProject = mongoose.model('GitProject', gitProjectSchema);
module.exports = GitProject;
