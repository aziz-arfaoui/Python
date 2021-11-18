const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();
const multer = require('multer');
var path = require('path')


var Storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'images')
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)) //Appending extension
  }
})
var upload = multer({ storage: Storage }).array('image', 12)

app.post('/upload', (req, res) => {
  upload(req, res , err => {
      if (err) {
          res.send('somthing went wrong');
      }
      res.send('file uploaded successfully');
  });
});


app.use(cors());

// parse requests of content-type - application/json
app.use(bodyParser.json());
// parse requests of content-type - application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

require("./app/routes/cheque.routes")(app);





// set port, listen for requests
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});

// connect to database
/*const db = require("./app/models");
db.mongoose.connect(db.url, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => {
    console.log("Connected to the database!");
  })
  .catch(err => {
    console.log("Cannot connect to the database!", err);
    process.exit();
  });*/




  
