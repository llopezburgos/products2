using com.sapas as sapas from '../db/schema';

service CatalogService {
    entity Products as projection on sapas.Products;
    entity Categories as projection on sapas.Categories;
    entity Currencies as projection on sapas.Currencies;
    //entity DimensionUnits as projection on sapas.DimensionUnits;
    //entity Months as projection on sapas.Months;
    //entity ProductReviews as projection on sapas.ProductReviews;
    entity SalesData as projection on sapas.SalesData;
    //entity StockAvailability as projection on sapas.StockAvailability;
    entity Suppliers as projection on sapas.Suppliers;
    //entity Suppliers_01 as projection on sapas.Suppliers_01;
    //entity Suppliers_02 as projection on sapas.Suppliers_02;
    entity UnitOfMeasures as projection on sapas.UnitOfMeasures;
    //entity Car as projection on sapas.Car;
    //entity ProductReviews as projection on sapas.ProductReviews;
    //entity Sum1     as projection on sapas.SelProducts1;
    //entity Sum2     as projection on sapas.SelProducts2;
    //entity Sum      as projection on sapas.SelProducts3;
    entity Order     as projection on sapas.Orders;
    entity OrderItems      as projection on sapas.OrderItems;
}
