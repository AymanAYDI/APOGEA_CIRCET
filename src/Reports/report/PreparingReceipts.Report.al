report 50027 "Preparing Receipts"
{
    Caption = 'Preparing Receipts', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Préparation des réceptions"}]}';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "Buy-from Vendor No.", "Document No.", "Location Code", "Expected Receipt Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";

            trigger OnAfterGetRecord()
            begin
                CurrReport.BREAK();
            end;
        }
    }

    trigger OnPostReport()
    begin
        PAGE.RUNMODAL(PAGE::"Open purchase lines", "Purchase Line");
    end;
}