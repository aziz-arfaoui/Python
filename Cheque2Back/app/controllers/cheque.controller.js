const spawn = require("child_process").spawn;
const pythonProcess = spawn('python',["../../codepyopencv.py"]);
const exec = require('child_process').exec;


function os_func() {
    this.execCommand = function(cmd, callback) {
        exec(cmd, (error, stdout, stderr) => {
            if (error) {
                console.error(`exec error: ${error}`);
                return;
            }

            callback(stdout);
        });
    }
}
var os = new os_func();

exports.getinfo = (req, res) => {
  os.execCommand('python3 codepyopencv.py', function (returnvalue) {
    console.log(returnvalue)
    res.status(200).json({ 
      s1: returnvalue,
      s2 : "aaaaa"
    });
  });
};

