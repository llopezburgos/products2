const cds = require("@sap/cds");
const cors = require('cors')

cds.on("bootstrap", (app) => {
    app.use(cors())
    app.get("/alive", (_,res) => { // 2 parametros: peticion y respuesta. Si no se usa, se debe poner _
        res.status(200).send("Server is Alive");
    });
});


module.exports = cds.server;