//imports
const path = require('path');
const express = require('express');
const morgan = require('morgan');
const exphbs = require('express-handlebars');
const passport = require('passport');
const session = require('express-session');
const flash = require('connect-flash');
const methodOverride = require('method-override');
//const cors = require('cors'); 

require('./connection/db');
require('./passport/local-auth');


//initializers

const app = express();

//settings

app.set('PORT',process.env.PORT || 3000);

app.set('views' ,path.join(__dirname,'views'));

// static files
app.set(express.static(path.join(__dirname + 'public')));



app.engine('.hbs', exphbs({
        defaultLayout:'main.hbs',
        layoutsDir: path.join(app.get('views'),'layouts'),
        partialsDir: path.join(app.get('views'),'partials'),
        extname:'.hbs'
}));

app.set('view engine','.hbs');

app.set('json spaces', 2); 



//middwares


app.use(morgan('dev'));

app.use(methodOverride('_method'));
app.use(express.json());
//global variables

app.use(session({
    secret : 'secret',
    resave: false,
    saveUninitialized: true,
    cookie:{ secure: true }


}));

app.use(flash());


app.use((req,res,next)=>{
    res.locals.success_msg = req.flash('success_msg');
    res.locals.error_msg = req.flash('error_msg');
    res.locals.error = req.flash('error');
    next(); 
})

app.use(passport.initialize());

app.use(passport.session())
app.use(express.urlencoded({extended:false}));


//static files




//routes


app.use(require("./routes/routeCliente"));
app.use(require("./routes/routeProduct"));
app.use(require("./routes/routeUser"));
 
 



//server
app.listen(app.get('PORT'), ()=>{
    console.log(`Server is running on Port ${app.get('PORT')}`);
});