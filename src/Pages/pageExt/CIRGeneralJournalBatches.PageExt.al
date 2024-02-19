pageextension 50091 "CIR General Journal Batches" extends "General Journal Batches"
{
    layout
    {
        addafter("Allow VAT Difference")
        {
            field(Check; Rec.Check)
            {
                ToolTip = 'Specifies the value of the Check ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chèque"}]}';
                ApplicationArea = All;
            }
        }
    }
}