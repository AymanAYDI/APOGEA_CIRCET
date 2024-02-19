codeunit 50012 "Price Mgt."
{
    /// <summary>
    /// Calcul des prix pour V15
    /// </summary>
    /// <param name="piCodeGroupe"></param>
    /// <param name="piCodeRessource"></param>
    procedure CreateResourcePrice(piCodeGroupe: Code[20]; piCodeRessource: Code[20])
    var
#pragma warning disable AL0432
        ResourcePrice: Record "Resource Price";
        ResourcePriceCopy: Record "Resource Price";
        ResourceCost: Record "Resource Cost";
        ResourceCostCopy: Record "Resource Cost";
#pragma warning restore AL0432
    begin
        ResourcePrice.SETRANGE(Code, piCodeRessource);
        IF NOT ResourcePrice.ISEMPTY() THEN
            ResourcePrice.DELETEALL();

        ResourceCost.SETRANGE(Type, ResourceCost.Type::Resource);
        ResourceCost.SETRANGE(Code, piCodeRessource);
        IF NOT ResourceCost.ISEMPTY() THEN
            ResourceCost.DELETEALL();

        ResourcePrice.RESET();
        ResourcePrice.SETRANGE(Type, ResourcePrice.Type::"Group(Resource)");
        ResourcePrice.SETRANGE(Code, piCodeGroupe);
        IF ResourcePrice.FINDSET() THEN
            REPEAT
                ResourcePriceCopy.INIT();
                ResourcePriceCopy.TRANSFERFIELDS(ResourcePrice);
                ResourcePriceCopy.Type := ResourcePriceCopy.Type::Resource;
                ResourcePriceCopy.Code := piCodeRessource;
                ResourcePriceCopy.INSERT();
            UNTIL ResourcePrice.NEXT() = 0;

        ResourceCost.RESET();
        ResourceCost.SETRANGE(Type, ResourceCost.Type::"Group(Resource)");
        ResourceCost.SETRANGE(Code, piCodeGroupe);
        IF ResourceCost.FINDSET() THEN
            REPEAT
                ResourceCostCopy.INIT();
                ResourceCostCopy.TRANSFERFIELDS(ResourceCost);
                ResourceCostCopy.Type := ResourceCostCopy.Type::Resource;
                ResourceCostCopy.Code := piCodeRessource;
                ResourceCostCopy.INSERT();
            UNTIL ResourceCost.NEXT() = 0;
    end;

    //Calcul des prix pour V16
    //Todo : doit être contrôlé et vérifié le nouveau calcul des couts ressources.
    procedure NewCreateResourcePrice(piCodeGroupe: Code[20]; piCodeRessource: Code[20])
    var

        PriceListLine: Record "Price List Line";
        PriceListLineCopy: Record "Price List Line";

        NewLineNo: Integer;
    begin
        PriceListLine.SETRANGE("Asset Type", PriceListLine."Asset Type"::Resource);
        PriceListLine.SETRANGE("Asset No.", piCodeRessource);
        IF NOT PriceListLine.ISEMPTY() THEN
            PriceListLine.DELETEALL();

        NewLineNo := 0;
        PriceListLine.RESET();
        PriceListLine.SETRANGE("Asset Type", PriceListLine."Asset Type"::"Resource Group");
        PriceListLine.SETRANGE("Asset No.", piCodeGroupe);
        IF PriceListLine.FINDSET() THEN
            REPEAT
                PriceListLineCopy.INIT();
                PriceListLineCopy.TRANSFERFIELDS(PriceListLine);
                PriceListLineCopy."Line No." := NewLineNo + 10000;
                PriceListLineCopy."Asset Type" := PriceListLineCopy."Asset Type"::Resource;
                PriceListLineCopy."Asset No." := piCodeRessource;
                PriceListLineCopy.INSERT();
            UNTIL PriceListLine.NEXT() = 0;
    end;
}