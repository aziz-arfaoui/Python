module.exports = app => {
    const cheque = require("../controllers/cheque.controller");
    var router = require("express").Router();

    router.get("/",cheque.getinfo);
    app.use('/api/cheque', router);
    
  };