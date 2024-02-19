pageextension 50051 "CIR Accounting Periods" extends "Accounting Periods"
{
    layout
    {
        addafter("Fiscally Closed")
        {
            field("Purchases Closing Date"; Rec."Purchases Closing Date")
            {
                ToolTip = 'Specifies the value of the Purchases Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture achats"}]}';
                ApplicationArea = All;
            }
            field("Sales Closing Date"; Rec."Sales Closing Date")
            {
                ToolTip = 'Specifies the value of the Sales Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture ventes"}]}';
                ApplicationArea = All;
            }
            field("GL Closing Date"; Rec."GL Closing Date")
            {
                ToolTip = 'Specifies the value of the GL Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture comptabilité"}]}';
                ApplicationArea = All;
            }
            field("Activity Closing Date"; rec."Activity Closing Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Activity Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de clôture activité"}]}';
            }
        }
    }
}