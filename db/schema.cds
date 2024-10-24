namespace com.sapas;

using {
    cuid,
    managed
} from '@sap/cds/common';

type Name : String(50);

// Tipo estructurado
type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

type Dec  : Decimal(16, 2);

context materials {
    entity Products : cuid, managed {
        key ID               : UUID;
            Name             : String not null;
            Description      : String;
            ImageUrl         : String;
            ReleaseDate      : Timestamp default $now;
            DiscontinuedDate : DateTime;
            Price            : Dec; //Decimal(16, 2);
            Height           : type of Price; //Decimal(16, 2);
            Width            : Decimal(16, 2);
            Depth            : Decimal(16, 2);
            Quantity         : Decimal(16, 2);
            // Supplier_Id       : UUID;
            // ToSupplier        : Association to one Suppliers
            //                         on ToSupplier.ID = Supplier_Id;
            // UnitOfMeasures_ID : String(2);
            // ToUnitOfMeasure   : Association to UnitOfMeasures
            //                         on ToUnitOfMeasure.ID = UnitOfMeasures_ID;

            Supplier         : Association to one Suppliers;
            UnitOfMeasure    : Association to UnitOfMeasures;
            Currency         : Association to Currencies;
            DimensionUnit    : Association to DimensionUnits;
            //Category         : Association to Categories;
            ToSalesData      : Association to many SalesData
                                   on ToSalesData.Products = $self;
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
            Description : localized String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : String;
    };

}

entity Suppliers {
    key ID         : UUID;
        Name       : type of materials.Products : Name; //String;
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phone      : String;
        Fax        : String;
        Product    : Association to many materials.Products
                         on Product.Supplier = $self;

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
        Products     : Association to materials.Products;
};

/*
Entidades Select
*/
entity SelProducts   as select from materials.Products; //Es como si fuera una vista

entity SelProducts1  as
    select from materials.Products {
        *
    };

entity SelProducts2  as
    select from materials.Products {
        Name,
        Price,
        Quantity
    };

entity SelProducts3  as
    select from materials.Products
    left join ProductReviews
        on Products.Name = ProductReviews.Name
    {
        ProductReviews.Rating,
        Products.Name,
        sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.Name
    order by
        Rating;

/*
Entidades Projection
*/
entity ProjProducts  as projection on materials.Products;

entity ProjProducts2 as
    projection on materials.Products {
        *
    };

entity ProjProducts3 as
    projection on materials.Products {
        //ReleaseDate,
        Name
    };

// entity ParamProducts(pName : String)     as
//     select
//         Name,
//         Price,
//         Quantity
//     from Products
//     where
//         Name = :pName;

// entity ProjParamProducts(pName : String) as projection on Products where Name = :pName;

extend materials.Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
}

entity Course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;
}

entity Student {
    key ID     : UUID;
        Course : Association to many StudentCourse
                     on Course.Student = $self;
}

entity StudentCourse {
    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;
}


entity Orders {
    key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
}

entity OrderItems {
    key ID      : UUID;
        Order   : Association to Orders;
        Product : Association to materials.Products;

}

/* Agrupaciones */

entity AveragePrice as 
select from sapas.materials.Products {
 Products.ID as ProductId,
 avg( Price ) as AveragePrice : Decimal (16,2) }
 group by
 Products.ID;


/* MIXIN */
entity Products2 as 
select from sapas.materials.Products
mixin {
    ToStockAvailibility : Association to sapas.materials.StockAvailability
    on ToStockAvailibility.ID = $projection.ID;
}

into {
    *,
    ToStockAvailibility.Description as Description,
    case
    when Quantity >=8 then 'Paco'
    when Quantity >0 then 'Manolo'
    else 'Rodolfo'
    end as StockAvailability : String

}