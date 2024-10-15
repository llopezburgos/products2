namespace com.sapas;

type Name : String(50);

// Tipo estructurado
type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
}

// // Tipo matriz o array
// type EmailsAddresses_01 : array of {
//     kind  : String;
//     email : String;
// }

// // Tipo estructurado que luego se convierte en array más adelante
// type EmailsAddresses_02 {
//     kind  : String;
//     email : String;
// }

// entity Emails {
//     email_01 : EmailsAddresses_01; // Array
//     email_02 : many EmailsAddresses_02; // Estructurado que con many se convierte en array
//     email_03 : many {
//             kind  : String;
//             email : String;
//     } // Otra forma para representar un array
// }

// type Gender: String enum { //Op. 1: Limitamos a male y female
//     male;
//     female;
// };

// entity Order {
//     clientgender : Gender;
//     status: Integer enum{ //Op. 2: Le decimos que si entra un 1 va a ser submitted
//         submitted = 1;
//         fulfiller = 2;
//         shipped = 3;
//         cancel = -1;
//     };
//     priority : String @assert.range enum { // Op. 3: Limitamos a high, medium y low pero sin cambiar el tipo de dato
//         high;
//         medium;
//         low;
//     }
// }

// entity Car {
//     key ID                 : UUID;
//         name               : String;
//         virtual discount_1 : Decimal;
//         @Core.Computed : false
//         virtual discount_2 : Decimal;
// }

type Dec  : Decimal(16, 2);

entity Products {
    key ID               : UUID;
        Name             : String not null;
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now; //DateTime;
        DiscontinuedDate : DateTime;
        Price            : Dec; //Decimal(16, 2);
        Height           : type of Price; //Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
};

entity Suppliers {
    key ID         : UUID;
        Name       : type of Products : Name; //String;
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phone      : String;
        Fax        : String;

};

entity Suppliers_01 {
    key ID      : UUID;
        Name    : String;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;

};

entity Suppliers_02 {
    key ID      : UUID;
        Name    : String;
        Address : {
            Street     : String;
            City       : String;
            State      : String(2);
            PostalCode : String(5);
            Country    : String(3);
        };
        Email   : String;
        Phone   : String;
        Fax     : String;

};

entity Categories {
    key ID   : String(1);
        Name : String;


};

entity StockAvailability {
    key ID          : Integer;
        Description : String;
};

entity Currencies {
    key ID          : String(3);
        Description : String;
};

entity UnitOfMeasures {
    key ID          : String(2);
        Description : String;
};

entity DimensionUnits {
    key ID          : String(2);
        Description : String;
};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
};

entity ProductReviews {
    key ID           : UUID;
        ToProduct_Id : UUID;
        CreatedAt    : DateTime;
        Name         : String;
        Rating       : Integer;
        Comment      : String;
};

entity SalesData {
    key ID           : UUID;
        DeliveryDate : DateTime;
        Revenue      : Decimal(16, 2);
};
