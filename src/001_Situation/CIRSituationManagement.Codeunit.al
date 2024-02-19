codeunit 50505 "CIR Situation Management"
{
    Permissions = tabledata "G/L Entry" = rmid,
                  tabledata "G/L Register" = rimd;

    var
        DocNo: Code[20];
        DocType: Enum "Gen. Journal Document Type";
        DocNoJnl: Code[20];
        DocTypeJnl: Enum "Gen. Journal Document Type";

    internal procedure delete(GLRegister: Record "G/L Register")
    var
        GLEntry: Record "G/L Entry";
        Text006Lbl: Label 'Do you want to delete situation entry ?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Voulez-vous supprimer les écritures de situation de cette transaction ?" }, { "lang": "FRB", "txt": "Voulez-vous supprimer les écritures de situation de cette transaction ?" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        IF CONFIRM(Text006Lbl) THEN
            IF GLRegister."From Entry No." < 0 THEN BEGIN
                GLEntry.SETRANGE("Entry No.", GLRegister."To Entry No.", GLRegister."From Entry No.");
                GLEntry.DELETEALL();
                GLRegister.DELETE();
            END;
    end;

    internal procedure DeleteCreate(GLRegister: Record "G/L Register")
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GLEntry: Record "G/L Entry";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        JnlSelected: Boolean;
        LineNumber: Integer;
        Text004Lbl: Label 'DEFAULT', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "DEFAUT" }, { "lang": "FRB", "txt": "DEFAUT" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text005Lbl: Label 'Default Journal', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille par défaut" }, { "lang": "FRB", "txt": "Feuille par défaut" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        JnlSelected := TRUE;

        GenJournalTemplate.RESET();
        GenJournalTemplate.SETRANGE(Type, 0);
        GenJournalTemplate.SETRANGE(GenJournalTemplate.Recurring, FALSE);

        CASE GenJournalTemplate.COUNT OF
            0:
                BEGIN
                    GenJournalTemplate.INIT();
                    GenJournalTemplate.Type := GenJournalTemplate.Type::General;
                    GenJournalTemplate.Recurring := FALSE;
                    GenJournalTemplate.Name := FORMAT(GenJournalTemplate.Type, MAXSTRLEN(GenJournalTemplate.Name));
                    GenJournalTemplate.VALIDATE(Type);
                    GenJournalTemplate.INSERT();
                    COMMIT();
                END;
            1:
                GenJournalTemplate.FindFirst();
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJournalTemplate) = ACTION::LookupOK;
        END;

        IF NOT JnlSelected THEN
            EXIT;

        GenJournalBatch.RESET();
        GenJournalBatch.SETRANGE("Journal Template Name", GenJournalTemplate.Name);
        CASE GenJournalBatch.COUNT OF
            0:
                BEGIN
                    GenJournalBatch.INIT();
                    GenJournalBatch."Journal Template Name" := GenJournalTemplate.Name;
                    GenJournalBatch.Name := Text004Lbl;
                    GenJournalBatch.Description := Text005Lbl;
                    GenJournalBatch."Reason Code" := GenJournalTemplate."Reason Code";
                    GenJournalBatch."Bal. Account Type" := GenJournalTemplate."Bal. Account Type";
                    GenJournalBatch."Bal. Account No." := GenJournalTemplate."Bal. Account No.";
                    GenJournalBatch."No. Series" := GenJournalTemplate."No. Series";
                    GenJournalBatch."Posting No. Series" := GenJournalTemplate."Posting No. Series";
                    GenJournalBatch."Copy VAT Setup to Jnl. Lines" := GenJournalTemplate."Copy VAT Setup to Jnl. Lines";
                    GenJournalBatch."Allow VAT Difference" := GenJournalTemplate."Allow VAT Difference";
                    GenJournalBatch.INSERT();
                    COMMIT();
                END;
            1:
                GenJournalBatch.FindFirst();
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, GenJournalBatch) = ACTION::LookupOK;
        END;

        IF NOT JnlSelected THEN
            EXIT;

        GLEntry.SETRANGE(GLEntry."Entry No.", GLRegister."To Entry No.", GLRegister."From Entry No.");

        GenJournalLine.FILTERGROUP := 2;
        GenJournalLine.SETRANGE("Journal Template Name", GenJournalTemplate.Name);
        GenJournalLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
        GenJournalLine.FILTERGROUP := 0;
        IF GenJournalLine.FindLast() THEN
            LineNumber := GenJournalLine."Line No." + 100
        ELSE
            LineNumber := 100;
        GenJournalLine.RESET();

        IF GLEntry.FindSet() THEN
            REPEAT
                GenJournalLine."Journal Template Name" := GenJournalTemplate.Name;
                GenJournalLine."Journal Batch Name" := GenJournalBatch.Name;
                GenJournalLine."Line No." := LineNumber;
                LineNumber += 100;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No." := GLEntry."G/L Account No.";
                GenJournalLine."Posting Date" := GLEntry."Posting Date";
                IF ((DocNo <> GLEntry."Document No.") OR (DocType <> GLEntry."Document Type")) THEN BEGIN
                    GenJournalLine."Document Type" := GLEntry."Document Type";
                    GenJournalLine."Document No." := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", GenJournalLine."Posting Date", FALSE);
                END ELSE BEGIN
                    GenJournalLine."Document Type" := DocTypeJnl;
                    GenJournalLine."Document No." := DocNoJnl;
                END;
                GenJournalLine.Description := GLEntry.Description;
                GenJournalLine.Amount := GLEntry.Amount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine.VALIDATE("Dimension Set ID", GLEntry."Dimension Set ID");
                GenJournalLine.VALIDATE("External Document No.", GLEntry."External Document No.");
                GenJournalLine."Source Code" := GenJournalTemplate."Source Code";
                GenJournalLine.INSERT(TRUE);
                DocNo := GLEntry."Document No.";
                DocType := GLEntry."Document Type";
                DocTypeJnl := GenJournalLine."Document Type";
                DocNoJnl := GenJournalLine."Document No.";
            UNTIL GLEntry.NEXT() = 0;

        GenJournalLine.FILTERGROUP := 2;
        GenJournalLine.SETRANGE("Journal Template Name", GenJournalTemplate.Name);
        GenJournalLine.FILTERGROUP := 0;
        Delete(GLRegister);
        COMMIT();
        PAGE.RUN(GenJournalTemplate."Page ID", GenJournalLine);
    end;
}