pageextension 50081 "CIR Bank Account Ledg. Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Value Date"; Rec."Value Date")
            {
                ApplicationArea = All;
                ToolTip = 'Value Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de valeur"}]}';
            }
        }
    }
}