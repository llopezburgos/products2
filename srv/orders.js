const cds = require("@sap/cds");
const { Orders } = cds.entities("com.training"); //Aquí extraemos solo la entidad Orders de momento

module.exports = (srv) => {

    /****** READ ******/
    /*srv.on("READ", "GetOrders", async (req) => { 
        return await SELECT.from(Orders);
    }); *///Acción, nombre, respuesta. Es una función asíncrona.

    /****** READ - FILTROS ******/
    srv.on("READ", "GetOrders", async (req) => {
        if (req.data.ClientEmail !== undefined) { // Si recibimos un cliente entonces devolvemos los datos de ese cliente
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }// Sino los devolvemos todos
        return await SELECT.from(Orders);
    });

    /****** AFTER ******/
    srv.after("READ", "GetOrders", (data) => {
        data.map((order) => { order.Reviewed = true });
    });

    /****** CREATE ******/
    srv.on("CREATE", "CreateOrders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run( // Insercción
                INSERT.into(Orders).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreatedOn: req.data.CreatedOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved
                })
            ).then((resolve, reject) => { // Respuesta
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== undefined) {
                    return req.data;
                } else {
                    req.error(409, "Record Not Inserted");
                }
            }).catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        return returnData; // Esto es opcional
    });

    /****** BEFORE ******/
    srv.before("CREATE", "CreateOrders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
    });

    /****** UPDATE ******/
    srv.on("UPDATE", "UpdateOrders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run( // Insercción
                UPDATE(Orders, req.data.ClientEmail).set({
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName
                })
            ).then((resolve, reject) => { // Respuesta
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (resolve[0] === 0) {
                    req.error(409, "Record Not Found")
                }
            }).catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        return returnData; // Esto es opcional
    });

    
    /****** DELETE ******/
    srv.on("DELETE", "DeleteOrders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run( // Insercción
                DELETE.from(Orders) .where({
                    ClientEmail: req.data.ClientEmail
                })
            ).then((resolve, reject) => { // Respuesta
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (resolve[0] === 0) {
                    req.error(409, "Record Not Found")
                }
            }).catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        return returnData; // Esto es opcional
    });
};