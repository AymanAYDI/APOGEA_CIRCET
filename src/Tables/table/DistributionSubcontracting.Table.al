table 50011 "Distribution Subcontracting"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Amount To Distributed"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount to be distributed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant à distribuer"}]}';
            Editable = true;
        }
    }
}