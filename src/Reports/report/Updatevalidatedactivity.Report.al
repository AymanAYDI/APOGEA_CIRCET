report 50023 "Update Validated Activity"
{
    Caption = 'Update Validated Activity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MAJ activité validée"}]}';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Permissions = TableData "Job Ledger Entry" = rimd;
    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("No.", "Type", "Entry Type", "Job No.", "Posting Date")
                                ORDER(Ascending)
                                WHERE("Entry Type" = CONST(Usage), Type = CONST(Resource));
            RequestFilterFields = "Posting Date", "Start Date", "No.", "Work Type Code", "Unit of Measure Code";

            trigger OnAfterGetRecord()
            var
                Resource: Record "Resource";
                JobJournalLine: Record "Job Journal Line";
            begin
                // Actualisation de la fenêtre de progression du traitement
                numJobLedgEntry += 1;
                dialogProgress.UPDATE(1, ROUND(10000.0 * numJobLedgEntry / NbJobLedgEntry, 1));

                IF NOT Resource.GET("No.") THEN
                    CurrReport.SKIP();

                JobJournalLine.INIT();
                JobJournalLine.Type := JobJournalLine.Type::Resource;
                JobJournalLine."No." := "No.";
                JobJournalLine."Job No." := "Job No.";
                JobMgt.InitDim1CodeLine(JobJournalLine);

                "Resource Group No." := Resource."Resource Group No.";
                "Global Dimension 1 Code" := JobJournalLine."Shortcut Dimension 1 Code";
                "Dimension Set ID" := JobJournalLine."Dimension Set ID";
                IF NOT ((((COPYSTR("Work Type Code", 1, 2) = 'FR') OR (COPYSTR("Work Type Code", 1, 3) = 'RFR'))) OR ("Work Type Code" = 'PRIMES')) THEN BEGIN
                    SetCostGrpResource("Resource Group No.", "Work Type Code", /* "Start Date" ,*/ "Unit Cost");
                    "Direct Unit Cost (LCY)" := 0;
                    "Total Cost" := ROUND("Unit Cost" * Quantity);
                    "Unit Cost (LCY)" := "Unit Cost";
                    "Total Cost (LCY)" := "Total Cost";
                    "Original Unit Cost (LCY)" := "Unit Cost";
                    "Original Total Cost (LCY)" := "Total Cost";
                    "Original Unit Cost" := "Unit Cost";
                    "Original Total Cost" := "Total Cost";
                END;

                // Sauvegarde des modifications
                MODIFY(FALSE);
            end;

            trigger OnPostDataItem()
            begin
                // Fermeture de la fenêtre de progression du traitement
                dialogProgress.CLOSE();
            end;

            trigger OnPreDataItem()
            var
                DialogLabelMsg: Label 'Update validated activity \', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mise à jour activité validée\\"}]}';
            begin
                // Initialisation de la fenêtre de progression du traitement
                numJobLedgEntry := 0;
                NbJobLedgEntry := COUNT;
                dialogProgress.OPEN(DialogLabelMsg + '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            end;
        }
    }

    var
        JobMgt: Codeunit "Job Mgt.";
        dialogProgress: Dialog;
        numJobLedgEntry, NbJobLedgEntry : Integer;

    local procedure SetCostGrpResource(grpRessource: Code[20]; workType: Code[10]; /* dateVal: Date; */ var costVal: Decimal)
    var
#pragma warning disable AL0432
        ResourceCost: Record "Resource Cost";
#pragma warning restore AL0432
    begin
        ResourceCost.RESET();
        ResourceCost.SETRANGE(Type, ResourceCost.Type::"Group(Resource)");
        ResourceCost.SETRANGE(Code, grpRessource);
        ResourceCost.SETRANGE("Work Type Code", workType);
        IF ResourceCost.FINDLAST() THEN
            costVal := ResourceCost."Unit Cost";
    end;
}