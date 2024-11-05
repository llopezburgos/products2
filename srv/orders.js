const cds = require("@sap/cds");
const { Orders } = cds.entities("com.training"); //Aquí extraemos solo la entidad Orders de momento

module.exports = (srv) => {

    /****** READ ******/
    /*srv.on("READ", "GetOrders", async (req) => { 
        return await SELECT.from(Orders);
    }); *///Acción, nombre, respuesta. Es una función asíncrona.

    /* Before All Request */

    srv.before("*", (req) => {
        console.log(`Method: ${req.method}`);
        console.log(`Target: ${req.target}`);
    });

    /****** READ - FILTROS ******/
    // srv.on("READ", "GetOrders", async (req) => {
    srv.on("READ", "Orders", async (req) => {
        if (req.data.ClientEmail !== undefined) { // Si recibimos un cliente entonces devolvemos los datos de ese cliente
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }// Sino los devolvemos todos
        return await SELECT.from(Orders);
    });

    /****** AFTER ******/
    //srv.after("READ", "GetOrders", (data) => {
    srv.after("READ", "Orders", (data) => {
        data.map((order) => { order.Reviewed = true });
    });

    /****** CREATE ******/
    //srv.on("CREATE", "CreateOrders", async (req) => {
    srv.on("CREATE", "Orders", async (req) => {
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
    //srv.before("CREATE", "CreateOrders", (req) => {
    srv.before("CREATE", "Orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
    });

    /****** UPDATE ******/
    //srv.on("UPDATE", "UpdateOrders", async (req) => {
    srv.on("UPDATE", "Orders", async (req) => {
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
    //srv.on("DELETE", "DeleteOrders", async (req) => {
    srv.on("DELETE", "Orders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run( // Insercción
                DELETE.from(Orders).where({
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

    /****** FUNCTION ******/
    srv.on("getClientTaxRate", async (req) => {
        // NO server side-effect
        const { ClientEmail } = req.data;
        const db = srv.transaction(req); //Aquí se inicia una transacción de base de datos.
        const results = await db
            .read(Orders, ["Country_code"])
            .where({ ClientEmail: ClientEmail });

        console.log(results[0]);

        switch (results[0].Country_code) {
            case 'ES':
                return 21.5;
            // break;
            case 'UK':
                return 24.6;
            //break;
            default:
                break;
        }
    });

    /******** ACTION *******/

    srv.on("cancelOrder", async (req) => {
        const { ClientEmail } = req.data;
        const db = srv.transaction(req); //Aquí se inicia una transacción de base de datos.
        console.log(ClientEmail);
        const resultsRead = await db
            .read(Orders, ["FirstName", "LastName", "Approved"])
            .where({ ClientEmail: ClientEmail });

        let returnOrder = {
            status: "",
            message: ""
        };

        //console.log(ClientEmail);
        console.log(resultsRead);

        if (resultsRead[0].Approved == false) {
            const resultsUpdate = await db
            .update(Orders)
            .set({ Status: "C" })
            .where({ClientEmail: ClientEmail});
            console.log(resultsRead[0].FirstName);
            returnOrder.status = "Succeeded";
            returnOrder.message = `The Order placed by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was cancel `
        } else {
            returnOrder.status = "Failed";
            returnOrder.message = `The Order placed by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was NOT cancel because is approved`
        }

        console.log("Action cancelOrder executed");
        return returnOrder;
    });
};
