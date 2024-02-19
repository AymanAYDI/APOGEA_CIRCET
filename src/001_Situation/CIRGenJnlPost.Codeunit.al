codeunit 50501 "CIR Gen. Jnl.-Post"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Copy(Rec);
        Code(GenJournalLine);
        Rec.Copy(GenJournalLine);
    end;

    var
        Text000Lbl: Label 'cannot be filtered when posting recurring journals', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "ne peut pas être filtré(e) lors de la validation de feuilles abonnement" }, { "lang": "FRB", "txt": "ne peut pas être filtré(e) lors de la validation de feuilles abonnement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text001Lbl: Label 'Do you want to post the journal lines?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Souhaitez-vous valider les lignes de la feuille ?" }, { "lang": "FRB", "txt": "Souhaitez-vous valider les lignes de la feuille ?" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text003Lbl: Label 'The journal lines were successfully posted.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les lignes de la feuille ont été validées avec succès." }, { "lang": "FRB", "txt": "Les lignes de la feuille ont été validées avec succès." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text004Lbl: Label 'The journal lines were successfully posted. You are now in the %1 journal.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les lignes de la feuille ont été validées avec succès. Vous vous trouvez maintenant dans la feuille %1." }, { "lang": "FRB", "txt": "Les lignes de la feuille ont été validées avec succès. Vous vous trouvez maintenant dans la feuille %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text005Lbl: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "L''utilisation de %1 pour le solde dégressif peut entraîner des chiffres trompeurs pour les années suivantes. Vous devez vérifier manuellement les écritures et les corriger si nécessaire. Voulez-vous continuer ?" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text006Lbl: Label '%1 in %2 must not be equal to %3 in %4.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 dans %2 ne doit pas être égal à %3 dans %4." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PreviewMode: Boolean;

    local procedure "Code"(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        FALedgerEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CIRGenJnlPostBatch: Codeunit "CIR Gen. Jnl.-Post Batch";
        ConfirmManagement: Codeunit "Confirm Management";
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
    begin
        HideDialog := false;
        OnBeforeCode(GenJournalLine, HideDialog);

        GenJournalTemplate.Get(GenJournalLine."Journal Template Name");
        if GenJournalTemplate.Type = GenJournalTemplate.Type::Jobs then begin
            SourceCodeSetup.Get();
            if GenJournalTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                Error(Text006Lbl, GenJournalTemplate.FieldCaption("Source Code"), GenJournalTemplate.TableCaption(),
                  SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption());
        end;
        GenJournalTemplate.TestField("Force Posting Report", false);
        if GenJournalTemplate.Recurring and (GenJournalLine.GetFilter("Posting Date") <> '') then
            GenJournalLine.FieldError("Posting Date", Text000Lbl);

        if not (PreviewMode or HideDialog) then
            if not ConfirmManagement.GetResponseOrDefault(Text001Lbl, true) then
                exit;

        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Fixed Asset" then begin
            FALedgerEntry.SetRange("FA No.", GenJournalLine."Account No.");
            FALedgerEntry.SetRange("FA Posting Type", GenJournalLine."FA Posting Type"::"Acquisition Cost");
            if not FALedgerEntry.IsEmpty and GenJournalLine."Depr. Acquisition Cost" and not HideDialog then
                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text005Lbl, GenJournalLine.FieldCaption("Depr. Acquisition Cost")), true) then
                    exit;
        end;

        TempJnlBatchName := GenJournalLine."Journal Batch Name";

        GeneralLedgerSetup.Get();
        CIRGenJnlPostBatch.SetPreviewMode(PreviewMode);
        CIRGenJnlPostBatch.Run(GenJournalLine);

        if PreviewMode then
            exit;
        if TempJnlBatchName = GenJournalLine."Journal Batch Name" then
            Message(Text003Lbl)
        else
            Message(
            Text004Lbl,
            GenJournalLine."Journal Batch Name");

        if not GenJournalLine.Find('=><') or (TempJnlBatchName <> GenJournalLine."Journal Batch Name") or GeneralLedgerSetup."Post with Job Queue" then begin
            GenJournalLine.Reset();
            GenJournalLine.FilterGroup(2);
            GenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            OnGenJnlLineSetFilter(GenJournalLine);
            GenJournalLine.FilterGroup(0);
            GenJournalLine."Line No." := 1;
        end;
    end;

    local procedure InitLastDocumentNo(var PostedGenJournalLine: Record "Posted Gen. Journal Line")
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        PostedGenJournalLine."Document No." := NoSeriesManagement.GetNextNo(PostedGenJournalLine."Posting No. Series", PostedGenJournalLine."Posting Date", FALSE);
    end;

    local procedure cleanJournalLines(var CopyGenJournalParameters: Record "Copy Gen. Journal Parameters") ReturnValue: Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        Text901Lbl: Label 'Do you want to delete existing lines in the journal ?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Voulez vous supprimer les lignes existantes dans le journal ?" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        GenJnlLine.SETRANGE("Journal Template Name", CopyGenJournalParameters."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", CopyGenJournalParameters."Journal Batch Name");
        if GenJnlLine.Count > 0 then
            if confirm(Text901Lbl) then
                GenJnlLine.DeleteAll();
        ReturnValue := True;
    end;

    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost, GenJournalLineSource);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 19, 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJnlPost := Subscriber;
        GenJournalLine.Copy(RecVar);
        PreviewMode := true;
        Result := GenJnlPost.Run(GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Gen. Journal Mgt.", 'OnBeforeInsertGenJournalLine', '', false, false)]
    local procedure OnBeforeInsertGenJournalLine(var PostedGenJournalLine: Record "Posted Gen. Journal Line"; var CopyGenJournalParameters: Record "Copy Gen. Journal Parameters");
    begin
        InitLastDocumentNo(PostedGenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Gen. Journal Mgt.", 'OnAfterGetCopyParameters', '', false, false)]
    local procedure OnAfterGetCopyParameters(var CopyGenJournalParameters: Record "Copy Gen. Journal Parameters"; var Result: Boolean);
    begin
        Result := cleanJournalLines(CopyGenJournalParameters);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenJnlLineSetFilter(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}
