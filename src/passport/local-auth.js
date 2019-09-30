const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const userSchema = require('../model/user');
/*
module.exports = function(passport) {
    passport.use(
      new LocalStrategy({ usernameField: 'email' }, (email, password, done) => {
        // Match user
        User.findOne({
          email: email
        }).then(user => {
          if (!user) {
            return done(null, false, { message: 'That email is not registered' });
          }
  
          // Match password
          bcrypt.compare(password, user.password, (err, isMatch) => {
            if (err) throw err;
            if (isMatch) {
              return done(null, user);
            } else {
              return done(null, false, { message: 'Password incorrect' });
            }
          });
        });
      })
    );
  
    passport.serializeUser(function(user, done) {
      done(null, user.id);
    });
  
    passport.deserializeUser(function(id, done) {
      User.findById(id, function(err, user) {
        done(err, user);
      });
    });
  };
  
*/







    passport.serializeUser((user,done) => {
        done(null, user.id)
    });
    
    passport.deserializeUser(async (id, done) => {
        const user = await userSchema.findById(id);
        done(null,user); 
    });
    
    
    
    passport.use('local-signup', new LocalStrategy({
        usernameField : "txtUsername",
        passwordField : "txtPassword",
        passReqToCallback : true
    }, async (req, email, password , done) => {
        const user = new userSchema();
        user.email = email;
        user.password = password;
        await user.save()
        done(null, user)
      
    
    }));


