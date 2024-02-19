codeunit 50504 "CIR Situation Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure OnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        SourceCode: Record "Source Code";
    begin
        GenJournalLine.TestField("Source Code");
        SourceCode.GET(GenJournalLine."Source Code");
        IF SourceCode."CIR Situation" THEN BEGIN
            IF (GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"G/L Account") OR
               (GenJournalLine."Bal. Account Type" <> GenJournalLine."Bal. Account Type"::"G/L Account") THEN
                Error(SituationBalAccountErr);
            IF (GenJournalLine."Gen. Posting Type" <> GenJournalLine."Gen. Posting Type"::" ") OR (GenJournalLine."VAT Bus. Posting Group" <> '') OR (GenJournalLine."VAT Prod. Posting Group" <> '')
               OR (GenJournalLine."Bal. Gen. Posting Type" <> GenJournalLine."Bal. Gen. Posting Type"::" ") OR (GenJournalLine."Bal. VAT Bus. Posting Group" <> '') OR
               (GenJournalLine."Bal. VAT Prod. Posting Group" <> '') THEN
                Error(SituationAccountTypeErr);
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"G/L Detail Trial Balance" then
            NewReportId := Report::"CIR G/L Detail Trial Balance";

        if ReportId = Report::"G/L Trial Balance" then
            NewReportId := Report::"CIR G/L Trial Balance";
    end;

    var
        SituationAccountTypeErr: Label 'You must not specify Gen. Posting Type, VAT Bus. Posting Group or VAT Prod. Posting Group in a situation journal.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous ne devez pas spécifier de Type compta. TVA, de Groupe compta. marché TVA ni de Groupe compta. produit TVA dans un journal de situation." }, { "lang": "FRB", "txt": "Vous ne devez pas spécifier de Type compta. TVA, de Groupe compta. marché TVA ni de Groupe compta. produit TVA dans un journal de simulation." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        SituationBalAccountErr: Label 'Situation journals only work with G/L accounts.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les journaux de situation ne fonctionnent qu''avec des comptes généraux." }, { "lang": "FRB", "txt": "Les journaux de siuation ne fonctionnent qu''avec des comptes généraux." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
}