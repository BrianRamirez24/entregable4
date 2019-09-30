const ProductSchema = require('../model/producto');




module.exports = {

    createProduct: async function(req,res){
        const {codigo, nombre, descripcion,stock, precio } = req.body;
    try{
        if(!codigo) {
            res.status(500).flash('error','codigo de producto requerido')
        }
        else if(!nombre){
            res.status(500).flash('error','debe ingresar el nombre del producto');

        }else if(!descripcion){
            res.status(500).flash('error','debe de ingresar una descripcion valida al producto');
        
        }else if(!stock){
            res.status(500).flash('error','por favor ingrese un stock al producto');
        
        }
        else if(!precio){
            res.status(500).flash('error','debe darle un precio');
        
        }
        else{
           ProductSchema.findOne({codigo: codigo})
                             .then((product)=>{
              if(product){

                res.status(500).flash('error','el producto ya está registrado');

              }
              else{

                  const products = new ProductSchema({
                      
                      codigo,
                      nombre, 
                      descripcion,
                      stock, 
                      precio
                  });

                  console.log(products);

                   await products.save(err =>{

                        err ?
                        res.status(500).flash('erorr','no se almacenaron datos intente nuevamente') : 
                        res.status(200).flash('success_msg', 'producto registrado exitosamente');
                        res.redirect('/dashboard');
                })
             
          }
         
        
        })



        .catch(err =>console.log( err ));
    }
} catch(error){
        console.log('error: ', error);
    }

    },

    listProducts: async function(req, res) {
        const productList = await ProductSchema.find().sort({name: 'asc'});
        res.render('/dashboard',{ productList });
    },

    updateProduct: async function(req, res){

        const { codigo, nombre, descripcion,stock, precio } = req.body;

        const objProduct = {
                codigo:"",
                nombre:"",
                descripcion:"",
                stock:"",
                precio:""
        };

        try{


         if(codigo){ objProduct.codigo = codigo;}
         if(nombre){ objProduct.nombre = nombre; }
         if(descripcion){ objProduct.descripcion = descripcion; }
         if(stock){ objProduct.stock = stock; }
         if(precio) { objProduct.precio = precio; }
         var id = req.params.id;
      
             await ProductSchema.findOneAndUpdate({ codigo: codigo } , {$set : objProduct}, 
                err => err  ?  res.status(500).flash('no se pudo actualizar el producto'): 
                               res.status(200).flash('success_msg','producto actualziado exitosmante'))
       

    }catch(error){
        res.status(500).flash(error)
    }


    },
    
    destroyProduct:async function (req, res){
        try{
            const id= req.params.id;
                await ProductSchema.deleteOne({ id }, err =>{ 
                                                      err ? res.status(500).flash('error', 'no se elimino el producto') : 
                                                      res.status(200).flash('success_msg','producto eliminado exitosamente')})
        }
        catch(error){

        }
    },

    fiterProduct: async function(req, res) {
        const productList = await ProductSchema.findOne({codigo:codigo},
                                                        (err, products) => {
            err? 
                 res.status(500).flash('error', 'producto no encontrado') : 
                 res.render('/products/productFilter');
        });
        
       
    },



}