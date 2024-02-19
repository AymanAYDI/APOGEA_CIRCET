pageextension 50000 "CIR General Journal" extends "General Journal"
{
    layout
    {
        addafter(CurrentJnlBatchName)
        {
            field("CIR Disabled Job Status"; gDisabledJobStatus)
            {
                ApplicationArea = All;
                Caption = 'Disabled Job Status', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désactiver statut projet"}]}';
                ToolTip = 'Specifies the value of the Disabled Job Status field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désactiver statut projet"}]}';

                trigger OnValidate()
                begin
                    if gDisabledJobStatus then
                        BindSubscription(ACYGenJournalLineESI)
                    else
                        UnbindSubscription(ACYGenJournalLineESI);
                end;
            }
        }
        addafter("Total Balance")
        {
            group("CIR TotalAmount")
            {
                Caption = 'Total amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total sélection" }, { "lang": "FRB", "txt": "Total sélection" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                field("CIR Total Amount"; TotalAmount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total selected amounts', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total des montants sélectionnés" }, { "lang": "FRB", "txt": "Total des montants sélectionnés" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Editable = false;
                    ToolTip = 'Specifies the total amount in the general journal.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le montant total dans les feuilles comptabilité" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Visible = true;
                }
                field("CIR Selected Lines"; LinesCount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Number of selected lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre de lignes sélectionnées" }, { "lang": "FRB", "txt": "Nombre de lignes sélectionnées" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Editable = false;
                    ToolTip = 'Number of selected lines.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre de lignes sélectionnées dans les feuilles comptabilité" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        modify(Post)
        {
            Visible = not gVisiblePostSimu;
        }
        modify(PostAndPrint)
        {
            Visible = not gVisiblePostSimu;
        }
        addlast(processing)
        {
            action(ImportGeneralLedgerEntry)
            {
                Caption = 'Import general ledger entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import écritures comptables"}]}';
                ToolTip = 'Allows you to launch the import of general ledger entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import des lignes d''écritures comptables"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                trigger OnAction()
                begin
                    XMLPORT.RUN(XMLPORT::"Import general ledger entry");
                    CurrPage.Update();
                end;
            }
        }
        addafter("F&unctions")
        {
            action("CIR Calculate selection")
            {
                ApplicationArea = ALL;
                Caption = 'Calc. sum of selection', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Calculer la sélection" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ToolTip = 'Calculate the amount of the selected lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Calculer le montant des lignes sélectionnées" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SelectedGeneralJournalLines: Record "Gen. Journal Line";
                begin
                    SelectedGeneralJournalLines.Reset();
                    LinesCount := 0;
                    TotalAmount := 0;
                    CurrPage.SetSelectionFilter(SelectedGeneralJournalLines);
                    if SelectedGeneralJournalLines.FindSet() then
                        repeat
                            LinesCount += 1;
                            TotalAmount += SelectedGeneralJournalLines.Amount;
                        until SelectedGeneralJournalLines.Next() = 0;
                end;
            }
        }
        addafter(Post)
        {
            action("CIR Post")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post situation registers', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Valider écritures situation" }, { "lang": "FRB", "txt": "Valider écritures situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = PostOrder;
                Visible = gVisiblePostSimu;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Finalisez le document ou la feuille en validant les montants et les quantités sur les comptes concernés dans la comptabilité de la société." }, { "lang": "FRB", "txt": "Finalisez le document ou la feuille en validant les montants et les quantités sur les comptes concernés dans la comptabilité de la société." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"CIR Gen. Jnl.-Post", Rec);
                end;
            }
        }
        addlast(processing)
        {
            action(Replace)
            {
                Caption = 'Replace', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remplacer"}]}';
                ToolTip = 'Replace the date of selected lines.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remplacer la date des lignes sélectionnées."}]}';
                ApplicationArea = All;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    CallReplacePage();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ClearTotalAmount();
        gDisabledJobStatus := false;
    end;

    trigger OnClosePage()
    begin
        UnbindSubscription(ACYGenJournalLineESI);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        IF GenJournalTemplate.Get(Rec."Journal Template Name") THEN
            if SourceCode.Get(GenJournalTemplate."Source Code") then
                gVisiblePostSimu := SourceCode."CIR Situation";
    end;

    trigger OnAfterGetRecord()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        IF GenJournalTemplate.Get(Rec."Journal Template Name") THEN
            if SourceCode.Get(GenJournalTemplate."Source Code") then
                gVisiblePostSimu := SourceCode."CIR Situation";
    end;

    local procedure ClearTotalAmount()
    begin
        TotalAmount := 0;
        LinesCount := 0;
    end;

    local procedure CallReplacePage()
    var
        GenJournalLine: Record "Gen. Journal Line";
        ReplaceMgt: Codeunit "Replace Mgt";
        RecRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(GenJournalLine);
        RecRef.GETTABLE(GenJournalLine);
        ReplaceMgt.FindAndReplace(RecRef, Rec.FIELDNO("Posting Date"));
    end;

    var
        SourceCode: Record "Source Code";
        ACYGenJournalLineESI: Codeunit "ACY Gen. Journal Line ESI";
        gVisiblePostSimu: Boolean;
        gDisabledJobStatus: Boolean;
        TotalAmount: Decimal;
        LinesCount: Integer;
}