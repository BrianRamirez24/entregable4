const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const clientSchema = new Schema({

    tipd:{
          type:String,
          require:true,
          enum:['CC', 'TI', 'TE']
        },

    doc:{
        type:String, 
        required:true
    },
    
    nombre:{
        type:String, 
        required:true
    },
    
    apellidos:{
        type: String,
        require:true
    },
    
    genero:{
        type:String, 
        require:true,
        enum:['M','F']
    },
    
    
    
    direccion:{
        type:String, 
        required:true
    },

    telefono:{
        type:String, 
        required:true
    },
    
    celular:{
              type:String, 
              required:false
       }
    })

module.exports = mongoose.model('Cliente', clientSchema)