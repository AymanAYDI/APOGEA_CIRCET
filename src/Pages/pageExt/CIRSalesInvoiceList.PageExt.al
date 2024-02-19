pageextension 50085 "CIR Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Your Reference62724"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
            }
        }
    }
}
