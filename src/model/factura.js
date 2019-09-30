const mongoose = require('mongoose');
const Cliente = require('../model/cliente');
const ventaSchema = mongoose.model('Venta');
const Schema = mongoose.Schema;

const facturaSchema = new Schema({

    codigo:{type:String, required:true},
    fecha_factura: { type: Date, default: Date.now },
    cliente:{type: Schema.Types.ObjectId,ref: "Cliente"},   
    venta:[{type: Schema.Types.ObjectId, ref: "Venta"}],
    total:{type:Number, required:true}

})


module.exports = mongoose.model('Factura',facturaSchema)