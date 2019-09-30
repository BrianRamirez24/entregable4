const express = require('express');
const bcryst = require('bcryptjs');
const path = require('path');
const router = express.Router();
const { registrarUsuario } = require('../controller/userscontroller')
const passport = require('passport');

/*
 se ejecuta cuando se entra a la ruta por
 defecto del servidor 3000
*/
//redirige por defecto al localhost:3000/


router.route('/')
  .all((req,res,next)=>{
    res.redirect('/user/login');
})


router.route('/index')
        .get((req,res)=> res.render('/index'))


router.route('/register')
      .get((req, res) => {
          res.render('user/register');
       })
  
     .post(registrarUsuario);
          
      /*
      .post(    passport.authenticate('local-signup',{
              successRedirect : '/login',
              failureRedirect : '/index',
              passReqToCallback : true
          })
      .post(*/
          
        /*
        
        
       
        */
   

      
      router.route('/login')
      .get((req, res, next) => {
          res.render('user/login');
        })
      .post((req,res,next)=>{})  
     




      router.route('/dashboard')
      .get((req, res, next) => {
          res.render('user/dashboard');
        })
      .post((req,res,next)=>{

      })  






module.exports = router;