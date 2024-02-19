tableextension 50006 "CIR Job" extends Job
{
    fields
    {
        field(50003; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50010; "Work In Progress Support"; Boolean)
        {
            Caption = 'Work In Progress Support', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Support d''encours"}]}';
            DataClassification = CustomerContent;
        }
        field(50020; "Situation Status"; Enum ARBCIRFRJobStatus)
        {
            Caption = 'Situation Status', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut situation"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                JobSituationMgt: Codeunit "Job Situation Mgt.";
                StatusNotAuthorizedErr: Label 'Status not authorized.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut non autorisé"}]}';
            begin
                IF (ARBCIRFRJobType = ARBCIRFRJobType::"Workside Job") THEN
                    // les statuts autorisés sont :
                    IF NOT ("Situation Status" IN ["Situation Status"::"In Progress", "Situation Status"::"Completed/Invoiced", "Situation Status"::"PV Recovery"]) THEN
                        ERROR(StatusNotAuthorizedErr);

                if (Rec."Situation Status" <> xRec."Situation Status"::"In Progress") and (xRec."Situation Status" = xRec."Situation Status"::"In Progress") then
                    "Estimate Production Progress" := JobSituationMgt.GetDefaultValueEstimateProd();
                if Rec."Situation Status" = Rec."Situation Status"::"Completed/Invoiced" then
                    JobSituationMgt.CheckQuantityByDocType(Rec."No.");
            end;
        }
        field(50030; "Inventory"; Decimal)
        {
            Caption = 'Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Inventaire"}]}';
            DataClassification = CustomerContent;
        }
        field(50040; "Estimate Production Progress"; Decimal)
        {
            Caption = 'Estimate Production Progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Estimation avancement prod."}]}';
            DataClassification = CustomerContent;
            InitValue = -99999;
        }

        modify("Search Description")
        {
            Caption = 'Site', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Site"}]}';
        }

        modify(ARBCIRFRJobStatus)
        {
            trigger OnAfterValidate()
            begin
                JobMgt.ControlOnJobStatus(rec, xrec);
            end;
        }
    }

    var
        JobMgt: Codeunit "Job Mgt.";
}