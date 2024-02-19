tableextension 50503 "CIR SourceCode" extends "Source Code"
{
    fields
    {
        field(50500; "CIR Situation"; Boolean)
        {
            Caption = 'Situation', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Situation" }, { "lang": "FRB", "txt": "Situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "CIR Situation" then
                    CheckSituationEntries();
            end;
        }
    }

    trigger OnDelete()
    begin
        if "CIR Situation" then
            CheckSituationEntries();
    end;

    local procedure CheckSituationEntries()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
    begin
        GenJournalLine.SETRANGE(GenJournalLine."Source Code", Code);
        GLEntry.SETRANGE(GLEntry."Source Code", Code);
        IF (not GenJournalLine.IsEmpty()) OR (not GLEntry.IsEmpty) THEN
            ERROR(SituationErr);
    end;

    var
        SituationErr: Label 'This source code is used on situated posted entries.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ce code journal est utilisé sur les entrées enregistrées de situation." }, { "lang": "FRB", "txt": "Ce code journal est utilisé sur les entrées enregistrées simulées." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
}