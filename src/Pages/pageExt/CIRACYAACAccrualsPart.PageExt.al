pageextension 50046 "CIR ACY_AAC Accruals Part" extends "ACY_AAC Accruals Overview Part"
{
    layout
    {
        addafter("Delivered Qty. Not Invoiced")
        {
            field(DeliveredQtyNotInvoiced; DeliveredQtyNotInvoiced)
            {
                ApplicationArea = ALL;
                Caption = 'Delivered Qty. Not Invoiced', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Qté livrée non facturée"}]}';
                DecimalPlaces = 0 : 5;
                Editable = false;
                ToolTip = 'Delivered Qty. Not Invoiced', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Qté livrée non facturée"}]}';
                Visible = VisibilityQty;
            }
        }
        modify("Delivered Qty. Not Invoiced")
        {
            Visible = NOT VisibilityQty;
        }
    }

    var
        VisibilityQty: Boolean;
        DeliveredQtyNotInvoiced: Decimal;

    procedure GetOrderLines(pAccrualType: Enum "ACY_AAC Accruals Type"; pSituationDate: Date; pPeriodicity: DateFormula)
    var
        AccrualMgt: Codeunit "Accrual Mgt.";
        AccrualsSetupMeth: Codeunit "ACY_AAC Accruals Setup Lib";
        PeriodStartDate: Date;
    begin
        Rec.DeleteAll();
        PeriodStartDate := CalcDate(pPeriodicity, pSituationDate);
        AccrualsSetupMeth.TestSituationDate(pSituationDate);
        AccrualsSetupMeth.TestPeriodStartDate(PeriodStartDate, pSituationDate);
        AccrualMgt.GetLines(Rec, pSituationDate, PeriodStartDate);
        CurrPage.Update(false);

        SetVisibility(FALSE);
    end;

    procedure SetVisibility(pVisibilityQty: Boolean)
    begin
        VisibilityQty := pVisibilityQty;
    end;

}