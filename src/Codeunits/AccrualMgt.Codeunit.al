codeunit 50016 "Accrual Mgt."
{

    procedure SetFiltersForAccruedExpenses(var PurchaseLine: Record "Purchase Line"; SituationDate: Date; StartingDate: Date)
    begin
        PurchaseLine.SetCurrentKey("Document No.", "Line No.");
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetFilter(Type, '<>%1&<>%2', "Sales Line Type"::" ", "Sales Line Type"::"Fixed Asset");
        PurchaseLine.SetFilter("Order Date", '%1..%2', StartingDate, SituationDate);
        PurchaseLine.SetRange(Accrue, TRUE);
    end;

    procedure TransfertFieldsForAccruedExpenses(var AccrualLine: Record "ACY_AAC Accruals Line" temporary; SituationDate: Date; StartingDate: Date)
    var
        PurchaseLine: Record "Purchase Line";
        TempPurchaseLine: Record "Purchase Line" temporary;
    begin
        SetFiltersForAccruedExpenses(PurchaseLine, SituationDate, StartingDate);
        DoGetPurchaseLinesWithPeriod(PurchaseLine, TempPurchaseLine);

        DoTransfertFieldsForAccruedExpenses(TempPurchaseLine, AccrualLine);
    end;

    Internal procedure GetLines(var TempAccrualLine: Record "ACY_AAC Accruals Line" temporary; SituationDate: Date; StartingDate: Date)
    var
    begin
        TransfertFieldsForAccruedExpenses(TempAccrualLine, SituationDate, StartingDate)
    end;

    local procedure DoGetPurchaseLinesWithPeriod(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary)
    var
        NoThingToDoMsg: Label 'Nothing to do !', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rien à Traiter !"},{"lang":"FRB","txt":"Rien à Traiter !"},{"lang":"DEU","txt":"Nichts zu verarbeiten!"},{"lang":"ESP","txt":"¡Nada que procesar!"},{"lang":"ITA","txt":"Niente da elaborare!"},{"lang":"NLB","txt":"<ToComplete>"},{"lang":"NLD","txt":"<ToComplete>"},{"lang":"PTG","txt":"Nada a processar!"}]}';
    begin
        if not PurchaseLine.FindSet() then begin
            Message(NoThingToDoMsg);
            exit;
        end;

        repeat
            TempPurchaseLine.Init();
            TempPurchaseLine.TransferFields(PurchaseLine);
            TempPurchaseLine.Insert();
        until PurchaseLine.Next() = 0;
    end;

    local procedure DoTransfertFieldsForAccruedExpenses(var TempPurchaseLine: Record "Purchase Line" temporary; var TempAccrualLine: Record "ACY_AAC Accruals Line" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        Incrementkey: Integer;
    begin
        IF TempAccrualLine.FindLast() then
            Incrementkey := TempAccrualLine."Accrual Line No.";

        If TempPurchaseLine.FindSet() then
            repeat
                Incrementkey += 10000;
                Vendor.Get(TempPurchaseLine."Buy-from Vendor No.");
                PurchaseHeader.Get(TempPurchaseLine."Document Type", TempPurchaseLine."Document No.");
                TempAccrualLine.Init();
                TempAccrualLine.TransferFields(TempPurchaseLine);
                TempAccrualLine."Order No." := TempPurchaseLine."Document No.";
                TempAccrualLine."Order Line No." := TempPurchaseLine."Line No.";
                TempAccrualLine."Accrual Line No." := Incrementkey;
                TempAccrualLine."Accrual Type" := "ACY_AAC Accruals Type"::FNP;
                TempAccrualLine."Third Party Name" := Vendor.Name;
                TempAccrualLine."Third Party Posting Group" := PurchaseHeader."Vendor Posting Group";
                TempAccrualLine."Amount Excl. VAT (LCY)" := TempAccrualLine."Unit Cost (LCY)" * TempAccrualLine.Quantity;
                TempAccrualLine."Delivered Qty. Not Invoiced" := TempAccrualLine.Quantity;
                TempAccrualLine."VAT Amount (LCY)" := ((TempAccrualLine."Amount Excl. VAT (LCY)" * TempAccrualLine."VAT %") / 100);
                TempAccrualLine.Insert();
            until TempPurchaseLine.Next() = 0;
    end;
}