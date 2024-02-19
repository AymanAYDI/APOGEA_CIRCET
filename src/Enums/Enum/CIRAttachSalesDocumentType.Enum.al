enum 50004 "CIR Attach Sales Document Type"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; Invoice)
    {
        Caption = 'Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Facture" } ] }';
    }
    value(1; "Credit Memo")
    {
        Caption = 'Credit Memo', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Avoir" } ] }';
    }
}