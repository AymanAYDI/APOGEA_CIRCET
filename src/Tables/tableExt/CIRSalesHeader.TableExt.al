tableextension 50013 "CIR Sales Header" extends "Sales Header"
{
    fields
    {
        field(50000; "Breakdown Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Breakdown Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture ventilée" }, { "lang": "FRB", "txt": "N° facture ventilée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Sales Invoice Header";
        }

        field(50010; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50020; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code site"}]}';
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
        modify(ARBVRNJobNo)
        {
            trigger OnAfterValidate()
            var
                Job: Record Job;
            begin
                if Job.Get(ARBVRNJobNo) then begin
                    JobMgt.ControlStatusOnSalesDocument(Rec);

                    Job.TestField("Bill-to Customer No.");
                    Validate("Sell-to Customer No.", Job."Bill-to Customer No.");
                    Validate("Bill-to Customer No.", Job."Bill-to Customer No.");
                    Validate("Salesperson Code", Job.ARBCIRFRSalespersonCode);
                end;
            end;
        }
    }

    var
        JobMgt: Codeunit "Job Mgt.";
}