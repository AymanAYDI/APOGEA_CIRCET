enum 50005 "CIR Attachment Document Type"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; " ")
    {
        Caption = ' ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": " " } ] }';
    }
    value(1; PV)
    {
        Caption = 'PV', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PV" } ] }';
    }
    value(2; Order)
    {
        Caption = 'Order', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commande" } ] }';
    }
    value(3; Other)
    {
        Caption = 'Other', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Autre" } ] }';
    }
}