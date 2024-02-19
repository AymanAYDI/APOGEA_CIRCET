tableextension 50053 "ACY Bank Account Buffer" extends "Bank Account Buffer"
{
    fields
    {
        field(50000; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° ligne"}]}';
            DataClassification = CustomerContent;
        }
    }
}