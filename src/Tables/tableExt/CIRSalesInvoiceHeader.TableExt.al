tableextension 50010 "CIR Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Breakdown Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Breakdown Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture ventilée" }, { "lang": "FRB", "txt": "N° facture ventilée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Sales Invoice Header";
            Editable = false;
        }

        field(50010; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
            Editable = false;
        }
#pragma warning disable AA0232
        field(50020; "Reminder Level Max"; Integer)
#pragma warning restore AA0232
        {
            Caption = 'Reminder Level Max', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Niveau relance max" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Max("Reminder/Fin. Charge Entry"."Reminder Level" where("Document No." = FIELD("No."), Canceled = const(false)));
            Editable = false;
        }
        field(50040; "Number of packages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
        }
        field(50041; "Total weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
        }
        field(50080; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
            NotBlank = false;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"), "Dimension Code" = const('AFFAIRE')));
        }
        field(50090; "Dimension Value Name"; Text[50])
        {
            Caption = 'Dimension Value Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('AFFAIRE'), Code = FIELD("Dimension Value")));
        }
    }

    trigger OnModify()
    var
        SalesInvoiceMgmt: Codeunit "Sales Mgt.";
    begin
        if "External Document No." <> xRec."External Document No." then
            SalesInvoiceMgmt.ConfirmExternalDoc_AndChangeInAssociatedGL("No.", "Posting Date", "External Document No.");
    end;
}