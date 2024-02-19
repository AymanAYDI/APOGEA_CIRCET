/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.ACH012       JCO       19/07/2021     ACH012 : gestion des paiements directs
*/
tableextension 50028 "CIR Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
    }

    trigger OnModify()
    var
        PurchaseInvoiceMgmt: Codeunit "Purchase Invoice Mgmt";
    begin
        If "Vendor Cr. Memo No." <> xRec."Vendor Cr. Memo No." then
            PurchaseInvoiceMgmt.ConfirmVendorCrMemoNo_AndChangeInAssociatedGL(Rec, "Vendor Cr. Memo No.");
    end;
}