using com.sapas as sapas from '../db/schema';

service CatalogService {
    entity Products as projection on sapas.Products;
    //entity Categories as projection on sapas.Categories;
    //entity Currencies as projection on sapas.Currencies;
    //entity DimensionUnits as projection on sapas.DimensionUnits;
    //entity Months as projection on sapas.Months;
    //entity ProductReviews as projection on sapas.ProductReviews;
    //entity SalesData as projection on sapas.SalesData;
    //entity StockAvailability as projection on sapas.StockAvailability;
    //entity Suppliers as projection on sapas.Suppliers;
    //entity UnitOfMeasures as projection on sapas.UnitOfMeasures;
}
