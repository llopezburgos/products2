using com.training as training from '../db/training';

service ManageOrders {
    // entity GetOrders as projection on training.Orders;
    // entity CreateOrders as projection on training.Orders;
    // entity UpdateOrders as projection on training.Orders;
    // entity DeleteOrders as projection on training.Orders;
    type cancelOrderReturn {
        status  : String enum {
            Succeeded;
            Failed
        };
        message : String
    };

    //entity Orders as projection on training.Orders;
    //function getClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
    //action   cancelOrder(ClientEmail : String(65))      returns cancelOrderReturn;

    // Ponemos el mismo código de arriba pero quitando el punto y coma.
    entity Orders as projection on training.Orders
        actions {
            function getClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
            action   cancelOrder(ClientEmail : String(65))      returns cancelOrderReturn;
        }


}
