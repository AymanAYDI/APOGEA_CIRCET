tableextension 50049 "CIR Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50001; Site; Text[50]) //Transfer field from purchase line
        {
            Caption = 'Site', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Site"}]}';
            DataClassification = CustomerContent;
        }
    }
}