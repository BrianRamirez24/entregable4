const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const productSchema = mongoose.model('Productos');

const ventaSchema = new Schema({
        
    codigoVenta:{type:String, required : true },
    producto:{type:Schema.Types.ObjectId, ref : "Productos"},
    cantidad:{type:Number, required:true},
    iva:{type:Number, required:true},
    subtota:{type:Number, 
            required:true}
    


})



module.exports = mongoose.model("Venta",ventaSchema);