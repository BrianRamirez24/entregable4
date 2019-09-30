const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const productSchema = new Schema({

    codigo:{
            type : String, 
            required: true
            },

    nombre:{
            type : String, 
            required: true
            },

    descripcion:{
                 type : String, 
                 required : true
                },

  

    stock:{ 
              type : Number, 
              required : true
            },

    precio: {
             type : Number,  
             required : true
            }


})
module.exports = mongoose.model('Productos', productSchema)