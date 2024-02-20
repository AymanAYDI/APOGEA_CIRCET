codeunit 50013 "CFONB Mapping"
{
    Permissions = TableData "Data Exch." = rimd,
                  TableData "Bank Account" = r,
                  TableData "Bank Acc. Reconciliation" = r,
                  TableData "Bank Acc. Reconciliation Line" = r;
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.GET(Rec."Data Exch. Entry No.");
        RecRef.GETTABLE(Rec);
        ProcessAllLinesColumnMapping(DataExch, RecRef);
    end;

    var
        BankAccount: Record "Bank Account";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        CurrBankAccount: Record "Bank Account";
        TempCompany: Record Company temporary;
        BankAccReconciliationLineNo: Integer;
        HideMessage: Boolean;
        MissingAccountCount: Integer;
        BankAccReconciliationCount: Integer;
        ImportEmptyStatement: Boolean;
        MissingValueErr: Label 'The file that you are trying to import, %1, is different from the specified %2, %3.\\The value in line %4, column %5 is missing.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le fichier que vous essayez d''importer, %1, est différent des %2, %3 spécifiés. La valeur de la ligne %4, colonne %5 est manquante."}]}';
        DecimalNotSupportedErr: Label 'The decimal format of the value %1 is not supported.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le format décimal de la valeur %1 n''est pas pris en charge."}]}';
        DataTypeNotSupportedErr: Label 'The %1 column is mapped in the %2 format to a %3 field, which is not supported.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La colonne %1 est mappée au format %2 sur un champ %3, ce qui n''est pas pris en charge."}]}';
        MissingBankAccountErr: Label 'The Bank Account %1=%2;%3=%4;%5=%6 doesn''t exist in any company.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le compte bancaire %1=%2;%3=%4;%5=%6 n''existe dans aucune entreprise."}]}';


    procedure ProcessColumnMapping(DataExch: Record "Data Exch."; DataExchLineDef: Record "Data Exch. Line Def"; RecRefTemplate: RecordRef)
    var
        DataExchField: Record "Data Exch. Field";
        DataExchFieldGroupByLineNo: Record "Data Exch. Field";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        RecRef: RecordRef;
        LastKeyFieldId: Integer;
        LineNoOffset: Integer;
        CurrLineNo: Integer;
    begin
        LastKeyFieldId := GetLastIntegerKeyField(RecRefTemplate);
        LineNoOffset := GetLastKeyValueInRange(RecRefTemplate, LastKeyFieldId);

        DataExchMapping.GET(DataExch."Data Exch. Def Code", DataExchLineDef.Code, RecRefTemplate.NUMBER);

        DataExchFieldMapping.SETRANGE("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        DataExchFieldMapping.SETRANGE("Data Exch. Line Def Code", DataExchLineDef.Code);
        DataExchFieldMapping.SETRANGE("Table ID", RecRefTemplate.NUMBER);

        DataExchField.SETRANGE("Data Exch. No.", DataExch."Entry No.");
        DataExchField.SETRANGE("Data Exch. Line Def Code", DataExchLineDef.Code);

        DataExchFieldGroupByLineNo.SETRANGE("Data Exch. No.", DataExch."Entry No.");
        DataExchFieldGroupByLineNo.SETRANGE("Data Exch. Line Def Code", DataExchLineDef.Code);
        DataExchFieldGroupByLineNo.ASCENDING(TRUE);
        IF NOT DataExchFieldGroupByLineNo.FINDSET() THEN
            EXIT;

        REPEAT
#pragma warning disable AA0205
            IF DataExchFieldGroupByLineNo."Line No." <> CurrLineNo THEN BEGIN
#pragma warning restore AA0205
                CurrLineNo := DataExchFieldGroupByLineNo."Line No.";

                RecRef := RecRefTemplate.DUPLICATE();
                IF (DataExchMapping."Data Exch. No. Field ID" <> 0) AND (DataExchMapping."Data Exch. Line Field ID" <> 0) THEN BEGIN
                    SetFieldValue(RecRef, DataExchMapping."Data Exch. No. Field ID", DataExch."Entry No.");
                    SetFieldValue(RecRef, DataExchMapping."Data Exch. Line Field ID", CurrLineNo);
                END;
                SetFieldValue(RecRef, LastKeyFieldId, CurrLineNo * 10000 + LineNoOffset);
                DataExchFieldMapping.FINDSET();
                REPEAT
                    DataExchField.SETRANGE("Line No.", CurrLineNo);
                    DataExchField.SETRANGE("Column No.", DataExchFieldMapping."Column No.");
                    IF DataExchField.FINDSET() THEN
                        REPEAT
                            SetField(RecRef, DataExchFieldMapping, DataExchField)
                        UNTIL DataExchField.NEXT() = 0
                    ELSE
                        IF NOT DataExchFieldMapping.Optional THEN
                            ERROR(
                              MissingValueErr, DataExch."File Name", GetType(DataExch."Data Exch. Def Code"),
                              DataExch."Data Exch. Def Code", CurrLineNo, DataExchFieldMapping."Column No.");
                UNTIL DataExchFieldMapping.NEXT() = 0;

                InsertRecRef(RecRef);
            END;
        UNTIL DataExchFieldGroupByLineNo.NEXT() = 0;
    end;

    procedure ProcessAllLinesColumnMapping(DataExch: Record "Data Exch."; RecRef: RecordRef)
    var
        DataExchLineDef: Record "Data Exch. Line Def";
    begin
        DataExchLineDef.SETRANGE("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        IF DataExchLineDef.FINDSET() THEN
            REPEAT
                ProcessColumnMapping(DataExch, DataExchLineDef, RecRef);
            UNTIL DataExchLineDef.NEXT() = 0;
    end;

    local procedure GetLastIntegerKeyField(RecRef: RecordRef): Integer
    var
        FieldRef: FieldRef;
        KeyRef: KeyRef;
    begin
        KeyRef := RecRef.KEYINDEX(1);
        FieldRef := KeyRef.FIELDINDEX(KeyRef.FIELDCOUNT);
        IF FORMAT(FieldRef.TYPE) <> 'Integer' THEN
            EXIT(0);

        EXIT(FieldRef.NUMBER);
    end;

    local procedure GetLastKeyValueInRange(RecRefTemplate: RecordRef; FieldId: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef := RecRefTemplate.DUPLICATE();
        SetKeyAsFilter(RecRef);
        FieldRef := RecRef.FIELD(FieldId);
        FieldRef.SETRANGE();
        IF RecRef.FINDLAST() THEN
            EXIT(RecRef.FIELD(FieldId).VALUE);
        EXIT(0);
    end;

    local procedure SetFieldValue(RecRef: RecordRef; FieldID: Integer; Value: Variant)
    var
        FieldRef: FieldRef;
    begin
        IF FieldID = 0 THEN
            EXIT;
        FieldRef := RecRef.FIELD(FieldID);
        FieldRef.VALIDATE(Value);
    end;

    procedure SetField(RecRef: RecordRef; DataExchFieldMapping: Record "Data Exch. Field Mapping"; var DataExchField: Record "Data Exch. Field")
    var
        DataExchColumnDef: Record "Data Exch. Column Def";
        TransformationRule: Record "Transformation Rule";
        FieldRef: FieldRef;
        TransformedValue: Text;
    begin
        DataExchColumnDef.GET(
          DataExchFieldMapping."Data Exch. Def Code",
          DataExchFieldMapping."Data Exch. Line Def Code",
          DataExchField."Column No.");

        FieldRef := RecRef.FIELD(DataExchFieldMapping."Field ID");

        TransformedValue := DELCHR(DataExchField.Value, '>');
        IF TransformationRule.GET(DataExchFieldMapping."Transformation Rule") THEN
            TransformedValue := TransformationRule.TransformText(DataExchField.Value);

        CASE FORMAT(FieldRef.TYPE) OF
            'Text',
          'Code':
                SetAndMergeTextCodeField(TransformedValue, FieldRef);
            'Date':
                SetDateField(TransformedValue, FieldRef, DataExchFieldMapping.Optional);
            'Decimal':
                IF DataExchColumnDef."Data Format" = 'CFONB' THEN
                    SetDecimalFieldCFONB(TransformedValue, FieldRef, DataExchFieldMapping.Multiplier, DataExchFieldMapping.Optional)
                ELSE
                    SetDecimalField(TransformedValue, FieldRef, DataExchFieldMapping.Multiplier, DataExchFieldMapping.Optional);
            'Option':
                SetOptionField(TransformedValue, FieldRef);
            ELSE
                ERROR(DataTypeNotSupportedErr, DataExchColumnDef.Description, DataExchFieldMapping."Data Exch. Def Code", FieldRef.TYPE);
        END;
    end;

    local procedure GetType(DataExchDefCode: Code[20]): Text
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchDef.GET(DataExchDefCode);
        EXIT(FORMAT(DataExchDef.Type));
    end;

    local procedure SetKeyAsFilter(var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        i: Integer;
    begin
        KeyRef := RecRef.KEYINDEX(1);
        FOR i := 1 TO KeyRef.FIELDCOUNT() DO BEGIN
            FieldRef := RecRef.FIELD(KeyRef.FIELDINDEX(i).NUMBER);
            FieldRef.SETRANGE(FieldRef.VALUE);
        END
    end;

    local procedure SetOptionField(ValueText: Text; FieldRef: FieldRef)
    var
        OptionValue: Integer;
    begin
        WHILE TRUE DO BEGIN
            OptionValue += 1;
            IF UPPERCASE(ValueText) = UPPERCASE(SELECTSTR(OptionValue, FieldRef.OPTIONCAPTION)) THEN BEGIN
                FieldRef.VALUE := OptionValue - 1;
                EXIT;
            END;
        END;
    end;

    local procedure SetAndMergeTextCodeField(Value: Text; var FieldRef: FieldRef)
    var
        CurrentLength: Integer;
    begin
        CurrentLength := STRLEN(FORMAT(FieldRef.VALUE));
        IF FieldRef.LENGTH = CurrentLength THEN
            EXIT;
        IF CurrentLength = 0 THEN
            FieldRef.VALUE := COPYSTR(Value, 1, FieldRef.LENGTH)
        ELSE
#pragma warning disable AA0217
            FieldRef.VALUE := STRSUBSTNO('%1 %2', FORMAT(FieldRef.VALUE), COPYSTR(Value, 1, FieldRef.LENGTH() - CurrentLength - 1));
#pragma warning restore AA0217
    end;

    local procedure SetDateField(Value: Text; var FieldRef: FieldRef; Optional: Boolean)
    var
        ValueAsDate: Date;
    begin
        IF NOT Optional THEN BEGIN
            EVALUATE(ValueAsDate, Value);
            FieldRef.VALUE := ValueAsDate;
        END ELSE
            IF EVALUATE(ValueAsDate, Value) THEN
                FieldRef.VALUE := ValueAsDate;
    end;

    local procedure SetDecimalField(ValueText: Text; var FieldRef: FieldRef; Multiplier: Decimal; Optional: Boolean)
    var
        ValueAsDecimal: Decimal;
    begin
        IF FORMAT(ValueText) = '' THEN
            ValueAsDecimal := 0
        ELSE
            IF NOT Optional THEN BEGIN
                IF NOT EVALUATE(ValueAsDecimal, ValueText) THEN
                    ERROR(DecimalNotSupportedErr, ValueText);

                FieldRef.VALUE := Multiplier * ValueAsDecimal;
            END ELSE
                IF EVALUATE(ValueAsDecimal, ValueText) THEN
                    FieldRef.VALUE := Multiplier * ValueAsDecimal;
    end;

    local procedure SetDecimalFieldCFONB(ValueText: Text; var FieldRef: FieldRef; Multiplier: Decimal; Optional: Boolean)
    var
        AmountTxt: Text[13];
        QualifierTxt: Text[1];
        // DecTypeNotSupportedErr: Label 'The %1 column is mapped in the %2 format to a %3 field, which is not supported.', Comment = '%1=Field Value;%2=Field Value;%3=Filed Type';
        ValueAsDecimal: Decimal;
    begin
        IF (FORMAT(ValueText) = '') AND Optional THEN
            EXIT;
        AmountTxt := CopyStr(COPYSTR(ValueText, 1, STRLEN(ValueText) - 1), 1, MaxStrLen(AmountTxt));
        QualifierTxt := COPYSTR(ValueText, STRLEN(ValueText), 1);
        IF NOT EVALUATE(ValueAsDecimal, AmountTxt) THEN BEGIN
            IF Optional THEN
                EXIT;
            ERROR(DecimalNotSupportedErr, ValueText);
        END;

        CASE QualifierTxt OF
            '{', '}':
                EVALUATE(ValueAsDecimal, AmountTxt + '0');
            'A', 'J':
                EVALUATE(ValueAsDecimal, AmountTxt + '1');
            'B', 'K':
                EVALUATE(ValueAsDecimal, AmountTxt + '2');
            'C', 'L':
                EVALUATE(ValueAsDecimal, AmountTxt + '3');
            'D', 'M':
                EVALUATE(ValueAsDecimal, AmountTxt + '4');
            'E', 'N':
                EVALUATE(ValueAsDecimal, AmountTxt + '5');
            'F', 'O':
                EVALUATE(ValueAsDecimal, AmountTxt + '6');
            'G', 'P':
                EVALUATE(ValueAsDecimal, AmountTxt + '7');
            'H', 'Q':
                EVALUATE(ValueAsDecimal, AmountTxt + '8');
            'I', 'R':
                EVALUATE(ValueAsDecimal, AmountTxt + '9');
        END;

        ValueAsDecimal := ValueAsDecimal / 100;
        IF STRPOS('}JKLMNOPQR', QualifierTxt) > 0 THEN
            ValueAsDecimal := ValueAsDecimal * -1;
        FieldRef.VALUE := Multiplier * ValueAsDecimal;
    end;

    procedure InsertRecRef(RecRef: RecordRef)
    begin
        CASE RecRef.NUMBER OF
            274:
                InsertBankAccReconciliationLine(RecRef);
            ELSE
                RecRef.INSERT();
        END;
    end;

    local procedure GetBankAccount(var pBankAccount: Record "Bank Account"; ValueText: Text; Pos: Integer; var BankBranchNo: Text[5]; var AgencyCode: Text[5]; var BankAccountNo: Text[11]): Boolean
    var
        Company: Record Company;
    begin
        Pos += 1;
        BankBranchNo := COPYSTR(ValueText, Pos, MAXSTRLEN(BankBranchNo));
        Pos += MAXSTRLEN(BankBranchNo) + 1;
        AgencyCode := COPYSTR(ValueText, Pos, MAXSTRLEN(AgencyCode));
        Pos += MAXSTRLEN(AgencyCode) + 1;
        BankAccountNo := COPYSTR(ValueText, Pos, MAXSTRLEN(BankAccountNo));

        pBankAccount.LockTable();
        pBankAccount.SETRANGE("Bank Branch No.", BankBranchNo);
        pBankAccount.SETRANGE("Agency Code", AgencyCode);
        pBankAccount.SETRANGE("Bank Account No.", BankAccountNo);
        IF pBankAccount.FINDSET() THEN BEGIN
            FillTempCompany(CopyStr(pBankAccount.CURRENTCOMPANY(), 1, 30));
            EXIT(TRUE);
        END ELSE BEGIN
            Company.SETFILTER(Name, '<>%1', pBankAccount.CURRENTCOMPANY());
            IF Company.FINDSET() THEN
                REPEAT
                    pBankAccount.CHANGECOMPANY(Company.Name);
                    pBankAccount.SETRANGE("Bank Branch No.", BankBranchNo);
                    pBankAccount.SETRANGE("Agency Code", AgencyCode);
                    pBankAccount.SETRANGE("Bank Account No.", BankAccountNo);
                    IF pBankAccount.FINDSET() THEN BEGIN
                        FillTempCompany(Company.Name);
                        EXIT(TRUE);
                    END;
                UNTIL Company.NEXT() = 0;
        END;

        EXIT(FALSE);
    end;

    local procedure IsSameBankAccount(BankAccount1: Record "Bank Account"; BankAccount2: Record "Bank Account"): Boolean
    begin
        EXIT(
             (BankAccount1."Bank Branch No." = BankAccount2."Bank Branch No.") AND
             (BankAccount1."Agency Code" = BankAccount2."Agency Code") AND
             (BankAccount1."Bank Account No." = BankAccount2."Bank Account No.")
            );
    end;

    local procedure InsertBankAccReconciliationLine(RecRef: RecordRef)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        BankAccReconciliation2: Record "Bank Acc. Reconciliation";
        TypeOfLine: Text[2];
        BankBranchNo: Text[5];
        AgencyCode: Text[5];
        BankAccountNo: Text[11];
        NewBankAccReconciliation: Boolean;
    begin
        CLEAR(BankAccReconciliationLine);
        RecRef.SETTABLE(BankAccReconciliationLine);

        TypeOfLine := COPYSTR(BankAccReconciliationLine."Additional Transaction Info", 1, MAXSTRLEN(TypeOfLine));
        CASE TypeOfLine OF
            '01':
                BEGIN
                    IF NOT GetBankAccount(BankAccount, BankAccReconciliationLine."Additional Transaction Info", 1 + MAXSTRLEN(TypeOfLine), BankBranchNo, AgencyCode, BankAccountNo) THEN BEGIN
                        IF NOT HideMessage THEN
                            MESSAGE(MissingBankAccountErr, BankAccount.FIELDCAPTION("Bank Branch No."), BankBranchNo
                                                        , BankAccount.FIELDCAPTION("Agency Code"), AgencyCode
                                                        , BankAccount.FIELDCAPTION("Bank Account No."), BankAccountNo);
                        CLEAR(BankAccount);
                        MissingAccountCount += 1;
                    END;
                    IF BankAccount."No." <> '' THEN BEGIN
                        BankAccReconciliation.CHANGECOMPANY(BankAccount.CURRENTCOMPANY);
                        NewBankAccReconciliation := TRUE;
                        IF IsSameBankAccount(CurrBankAccount, BankAccount) THEN BEGIN
                            BankAccReconciliationLine2.SETRANGE("Statement Type", BankAccReconciliationLine."Statement Type");
                            BankAccReconciliationLine2.SETRANGE("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
                            BankAccReconciliationLine2.SETRANGE("Statement No.", BankAccReconciliationLine."Statement No.");
                            NewBankAccReconciliation := BankAccReconciliationLine2.FINDSET();
                        END ELSE
                            NewBankAccReconciliation := TRUE;

                        NewBankAccReconciliation := FALSE;

                        IF NewBankAccReconciliation THEN BEGIN
                            BankAccReconciliation.INIT();
                            BankAccReconciliation.VALIDATE("Statement Type", BankAccReconciliationLine."Statement Type"::"Bank Reconciliation");
                            BankAccReconciliation."Bank Account No." := BankAccount."No.";
                            BankAccReconciliation."Statement No." := FORMAT(BankAccReconciliationLine."Transaction Date", 0, '<Year><Month,2><Day,2>');
                            BankAccReconciliation2.CHANGECOMPANY(BankAccount.CURRENTCOMPANY);
                            BankAccReconciliation2.SETRANGE("Statement Type", BankAccReconciliationLine."Statement Type"::"Bank Reconciliation");
                            BankAccReconciliation2.SETRANGE("Bank Account No.", BankAccount."No.");
                            BankAccReconciliation2.SETFILTER("Statement No.", '%1|%2', BankAccReconciliation."Statement No.", BankAccReconciliation."Statement No." + '-*');
                            IF BankAccReconciliation2.FINDLAST() THEN
                                BankAccReconciliation."Statement No." := IncStatementNo(BankAccReconciliation2."Statement No.");

                            BankAccReconciliation.INSERT(TRUE);
                            BankAccReconciliationCount += 1;
                        END ELSE
                            BankAccReconciliation.GET(BankAccReconciliationLine."Statement Type", BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.");

                        BankAccReconciliation."Balance Last Statement" := BankAccReconciliationLine."Statement Amount";
                        BankAccReconciliation.MODIFY(TRUE);
                        BankAccReconciliationLineNo := 10000;
                    END;
                END;
            '07':
                IF BankAccount."No." <> '' THEN BEGIN
                    BankAccReconciliationLine2.CHANGECOMPANY(BankAccount.CURRENTCOMPANY);
                    BankAccReconciliationLine2.SETRANGE("Statement Type", BankAccReconciliation."Statement Type");
                    BankAccReconciliationLine2.SETRANGE("Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE("Statement No.", BankAccReconciliation."Statement No.");
                    IF not BankAccReconciliationLine2.IsEmpty() OR ImportEmptyStatement THEN BEGIN
                        BankAccReconciliation.VALIDATE("Statement Ending Balance", BankAccReconciliationLine."Statement Amount");
                        BankAccReconciliation.VALIDATE("Statement Date", BankAccReconciliationLine."Transaction Date");
                        BankAccReconciliation.MODIFY(TRUE);
                        BankAccount."Last Statement No." := BankAccReconciliation."Statement No.";
                        BankAccount.MODIFY();
                    END ELSE BEGIN
                        BankAccReconciliation.DELETE(TRUE);
                        IF BankAccReconciliationCount > 0 THEN
                            BankAccReconciliationCount -= 1;
                    END;
                END;
            '04':
                IF BankAccount."No." <> '' THEN BEGIN
                    BankAccReconciliationLine.CHANGECOMPANY(BankAccount.CURRENTCOMPANY);
                    BankAccReconciliationLine."Bank Account No." := BankAccReconciliation."Bank Account No.";
                    BankAccReconciliationLine."Statement No." := BankAccReconciliation."Statement No.";
                    BankAccReconciliationLine."Statement Line No." := BankAccReconciliationLineNo;
                    BankAccReconciliationLineNo += 10000;
                    CLEAR(BankAccReconciliationLine."Additional Transaction Info");
                    BankAccReconciliationLine.VALIDATE("Transaction Date");
                    BankAccReconciliationLine.VALIDATE("Statement Amount");
                    BankAccReconciliationLine.VALIDATE(Description);
                    BankAccReconciliationLine.INSERT();
                END;
            '05':
                IF BankAccount."No." <> '' THEN BEGIN
                    BankAccReconciliationLine2.CHANGECOMPANY(BankAccount.CURRENTCOMPANY);
                    BankAccReconciliationLine2.SETRANGE("Statement Type", BankAccReconciliation."Statement Type");
                    BankAccReconciliationLine2.SETRANGE("Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE("Statement No.", BankAccReconciliation."Statement No.");
                    IF BankAccReconciliationLine2.FINDLAST() THEN BEGIN
                        BankAccReconciliationLine2.VALIDATE("Additional Transaction Info", BankAccReconciliationLine.Description);
                        BankAccReconciliationLine2.MODIFY(TRUE);
                    END;
                END;
        END;

    end;

    local procedure IncStatementNo(OldStatementNo: Code[20]) NewStatementNo: Code[20]
    begin
        IF STRPOS(OldStatementNo, '-') > 0 THEN
            NewStatementNo := INCSTR(OldStatementNo)
        ELSE
            NewStatementNo := Format(OldStatementNo + '-002');
    end;

    procedure GetMissingAccountCount(): Integer
    begin
        EXIT(MissingAccountCount);
    end;

    local procedure FillTempCompany(CompanyName: Text[30])
    begin
        TempCompany.SETRANGE(Name, CompanyName);
        IF NOT TempCompany.FINDSET() THEN BEGIN
            TempCompany.INIT();
            TempCompany.Name := CompanyName;
            TempCompany.INSERT();
        END;
        TempCompany.RESET();
    end;


    procedure GetTempCompanyCount(): Integer
    begin
        EXIT(TempCompany.COUNT);
    end;

    procedure SetHideMessage(pHideMessage: Boolean)
    begin
        HideMessage := pHideMessage;
    end;

    procedure GetBankAccReconciliationCount(): Integer
    begin
        EXIT(BankAccReconciliationCount);
    end;

    procedure SetImportEmptyStatement(pImportEmptyStatement: Boolean)
    begin
        ImportEmptyStatement := pImportEmptyStatement;
    end;
}

