tableextension 50026 "CIR Res. Capacity Entry" extends "Res. Capacity Entry"
{
    fields
    {
        field(50000; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
    }
}