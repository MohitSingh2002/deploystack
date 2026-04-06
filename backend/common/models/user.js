const mongoose = require('mongoose');

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    git: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Git',
        default: null
    }
});

const User = mongoose.model('User', userSchema);
module.exports = User;
