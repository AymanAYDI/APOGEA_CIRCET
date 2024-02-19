tableextension 50054 "CIRPurchaseHeaderArchive" extends "Purchase Header Archive"
{
    fields
    {
        field(50010; "Direct Customer Payment"; Boolean)
        {
            Caption = 'Direct Customer Payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paiement direct client"}]}';
            DataClassification = CustomerContent;
        }
        field(50020; Approved; Boolean)
        {
            Caption = 'Approved', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Approuvé"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(50030; "ITESOFT User ID"; Code[50])
        {
            Caption = 'ITESOFT User ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code utilisateur ITESOFT"}]}';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Description = 'ITESOFT';
        }
        field(50100; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}
