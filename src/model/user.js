const mongoose = require("mongoose");
const bcryp = require("bcrypt-nodejs");
const Schema = mongoose.Schema;

const userSchema = new Schema({
	email: { type: String, required: true },
	password: { type: String, required: true },
	roll:{type: String, required: true },
	estado:{type: String, required: true},
	fechaReg: {type:Date, default:Date.now}
});


userSchema.methods.encryptPassword = (password) => bcryp.hashSync(password, bcryp.genSaltSync(10));

userSchema.methods.comparePassword = (password) => bcryp.compareSync(password, this.password);


module.exports = mongoose.model("user", userSchema);

