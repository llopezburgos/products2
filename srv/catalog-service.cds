using com.sapas as sapas from '../db/schema';

/* Selector inteligente --> * */
define service CatalogService {
    entity Products          as
        select from sapas.materials.Products {
            // ID,
            // Name          as ProductName @mandatory,
            // Description,
            // @readonly
            // ImageUrl,
            // ReleaseDate,
            // DiscontinuedDate,
            // Price,
            // Height,
            // Width,
            // Depth,
            *,
            Quantity,
            UnitOfMeasure as ToUnitOfMeasure,
            Currency      as ToCurrency,
            DimensionUnit as ToDimesionUnit,
            Supplier,
        };

    @readonly
    entity Supplier          as
        select from sapas.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Review            as
        select from sapas.ProductReviews {
            ID,
            Name,
            Rating,
            Comment
        };

    /* Proyecciones con Postfix*/
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from sapas.materials.DimensionUnits;
}

/* Expresiones de Ruta ==> Name */
define service MyService {

    entity SuppliersProduct  as
        select from sapas.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.City
        }

    /* Expresiones de Ruta ==> Where*/
    entity SuppliersProduct2 as
        select from sapas.materials.Products {
            *,
            Name,
            Description,
            Supplier.City
        }
        where
            Supplier.City = 'Sammamish';

    /* Filtros Infix ==> Primera forma*/
    entity EntityInfix       as
        select Supplier[Name = 'Exotic Liquids'].Phone from sapas.materials.Products
        where
            Products.Name = 'Bread';

    /* Filtros Infix ==> Segunda forma*/
    entity EntityJoin        as
        select Phone from sapas.materials.Products
        left join sapas.Suppliers as supp
            on(
                supp.ID = Products.Supplier.ID
            )
            and supp.Name = 'Exotic Liquids'
        where
            Products.Name = 'Bread';

    /* Agrupaciones*/

    // Ir a schema. cds

    entity AveragePrice      as projection on sapas.AveragePrice;
    /* MIXIN */
    entity Products2         as projection on sapas.Products2;

    /* Casting */
    entity EntityCasting     as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from sapas.materials.Products;

    /* Exits */
    entity EntityExists      as
        select from sapas.materials.Products {
            Name
        }
        where
            exists Supplier[Name = 'Exotic Liquids'];

}


/*define service ConsultasEmbebidas {



}*/


// service CatalogService {
//     entity Products as projection on sapas.materials.Products;
//     entity Categories as projection on sapas.materials.Categories;
//     entity Currencies as projection on sapas.materials.Currencies;
//     //entity DimensionUnits as projection on sapas.DimensionUnits;
//     //entity Months as projection on sapas.Months;
//     //entity ProductReviews as projection on sapas.ProductReviews;
//     entity SalesData as projection on sapas.SalesData;
//     //entity StockAvailability as projection on sapas.StockAvailability;
//     entity Suppliers as projection on sapas.Suppliers;
//     //entity Suppliers_01 as projection on sapas.Suppliers_01;
//     //entity Suppliers_02 as projection on sapas.Suppliers_02;
//     entity UnitOfMeasures as projection on sapas.materials.UnitOfMeasures;
//     //entity Car as projection on sapas.Car;
//     //entity ProductReviews as projection on sapas.ProductReviews;
//     //entity Sum1     as projection on sapas.SelProducts1;
//     //entity Sum2     as projection on sapas.SelProducts2;
//     //entity Sum      as projection on sapas.SelProducts3;
//     entity Order     as projection on sapas.Orders;
//     entity OrderItems      as projection on sapas.OrderItems;


// }
