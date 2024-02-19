codeunit 50025 "Distri. Cost Mgt."
{
    internal procedure SetCalculDistriSubContracting(PurchaseHeader: Record "Purchase Header"; AmountToDistributed: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
        TotalWeight: Decimal;
        LineWeight: Decimal;
    begin
        TotalWeight := 0;
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter(Quantity, '>0');
        if PurchaseLine.FindSet() then
            repeat
                Item.GET(PurchaseLine."No.");
                TotalWeight += Item."Net Weight" * PurchaseLine.Quantity;
            until PurchaseLine.Next() = 0;

        if TotalWeight <> 0 then
            if PurchaseLine.FindSet(TRUE) then
                repeat
                    Item.GET(PurchaseLine."No.");
                    LineWeight := Item."Net Weight" * PurchaseLine.Quantity;
                    PurchaseLine.validate("Direct Unit Cost", (LineWeight / TotalWeight * AmountToDistributed) / PurchaseLine.Quantity);
                    PurchaseLine."Line Weight" := LineWeight;
                    PurchaseLine.modify();
                until PurchaseLine.next() = 0;
    end;

    internal procedure CheckIsSubContractingOrder(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Prod. Order No.", '=%1', '');
        if PurchaseLine.IsEmpty() then
            exit(true)
        else
            exit(false);
    end;
}