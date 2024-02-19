report 50032 "Update Job Situation"
{
    Caption = 'Update Job Situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mise à jour de la situation"}]}';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            trigger OnPreDataItem()
            begin
                IF NOT ActivateSituation then
                    CurrReport.Break();

                SETRANGE(ARBCIRFRJobType, Job.ARBCIRFRJobType::"Workside Job");

                jobNber := Job.COUNT();
                jobNum := 0;
                dlgProgress.OPEN(ResetSettingsEnterPeriod_Msg + ResetSettingsProgressBar_Msg);
            end;

            trigger OnAfterGetRecord()
            begin
                // Actualisation de la fenêtre de progression du traitement
                jobNum += 1;
                dlgProgress.UPDATE(1, ROUND(10000.0 * jobNum / jobNber, 1));

                // Reset des paramètres
                CASE ARBCIRFRJobStatus OF
                    ARBCIRFRJobStatus::"In Progress":
                        "Situation Status" := "Situation Status"::"In Progress";
                    ARBCIRFRJobStatus::"PV Recovery":
                        "Situation Status" := "Situation Status"::"PV Recovery";
                    ELSE
                        "Situation Status" := "Situation Status"::"Completed/Invoiced";
                END;

                "Estimate Production Progress" := GetDefaultValueEstimateProd();
                IF NOT ("Situation Status" = "Situation Status"::"Completed/Invoiced") THEN
                    Inventory := 0;

                MODIFY();
            end;

            trigger OnPostDataItem()
            begin
                IF ActivateSituation then
                    dlgProgress.Close();
            end;
        }

        dataitem("Purchase Line"; "Purchase Line")
        {
            trigger OnPreDataItem()
            begin
                IF ActivateSituation then
                    CurrReport.Break();

                SETCURRENTKEY("Document Type", Type, "Job No.");
                SETRANGE("Document Type", "Document Type"::Order);
                SETRANGE(Type, Type::Item);
                SETFILTER("Job No.", '<>%1', '');

                orderLineNber := COUNT();
                orderLineNum := 0;

                dlgProgress.OPEN(AccrueProgressBar_Msg);
            end;

            trigger OnAfterGetRecord()
            begin
                // Actualisation de la fenêtre de progression du traitement
                orderLineNum += 1;
                dlgProgress.UPDATE(1, ROUND(10000.0 * orderLineNum / orderLineNber, 1));

                // Traitement du reset de l'indicateur FNP
                PurchaseHeader.GET("Document Type", "Document No.");
                if not PurchaseHeader."Direct Customer Payment" then
                    IF Accrue THEN BEGIN
                        Accrue := false;
                        MODIFY();
                    END;
            end;

            trigger OnPostDataItem()
            begin
                IF NOT ActivateSituation then
                    dlgProgress.Close();
            end;
        }
    }

    internal procedure GetDefaultValueEstimateProd(): Decimal
    begin
        exit(-99999)
    end;

    internal procedure ActivatePeriodSituation(pActivate: Boolean)
    begin
        ActivateSituation := pActivate;
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine, PurchaseLine2 : Record "Purchase Line";
        orderLineNum, orderLineNber : Integer;
        ActivateSituation: Boolean;
        jobNber, jobNum : Integer;
        dlgProgress: Dialog;
        ResetSettingsEnterPeriod_Msg: Label 'Reset of the evaluation parameters of the situation \\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Reset des paramètres d''évaluation de la situation\\"}]}';
        ResetSettingsProgressBar_Msg: Label 'Projects @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Projets @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\"}]}';
        AccrueProgressBar_Msg: Label 'Update lines accrue  @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mise à jour des lignes de FNP  @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"}]}';
}