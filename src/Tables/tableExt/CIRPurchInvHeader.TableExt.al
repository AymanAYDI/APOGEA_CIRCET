tableextension 50011 "CIR Purch. Inv. Header" extends "Purch. Inv. Header"
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
        field(50100; "Description"; text[50])
        {
            Caption = 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
            DataClassification = CustomerContent;
        }
    }

    trigger OnModify()
    var
        PurchaseInvoiceMgmt: Codeunit "Purchase Invoice Mgmt";
    begin
        If "Vendor Invoice No." <> xRec."Vendor Invoice No." then
            PurchaseInvoiceMgmt.ConfirmVendorInvoiceNo_AndChangeInAssociatedGL(Rec, "Vendor Invoice No.");
    end;
}