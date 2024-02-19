enum 50000 "Invoice Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "N/A")
    {
        Caption = 'N/A', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Sans Objet"}]}';
    }
    value(1; "On hold")
    {
        Caption = 'On hold', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Attente"}]}';
    }
    value(2; Issue)
    {
        Caption = 'Issue', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Litige"}]}';
    }
    value(3; Received)
    {
        Caption = 'Received', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Reçu"}]}';
    }
}