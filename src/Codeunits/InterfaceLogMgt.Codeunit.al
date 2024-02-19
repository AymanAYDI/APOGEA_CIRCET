codeunit 50024 "Interface Log Mgt."
{
    internal procedure CreateLogInterface(pInterfaceName: Enum "Interface Name"; pFileName: Text[100]; pAckFileName: Text[100]; pInvoiceID: Text[100]; pInvoiceType: Option; pPurchDocumentType: Enum "Purchase Document Type"; pPurchDocumentNo: Code[20]; pCompanyName: text[30]): Integer
    var
        InterfaceLogEntry: Record "Interface Log Entry";
    begin
        InterfaceLogEntry.Init();
        InterfaceLogEntry."Entry No." := 0;
        InterfaceLogEntry."Date and Time" := CurrentDateTime();
        InterfaceLogEntry."Interface Name" := pInterfaceName;
        InterfaceLogEntry."Filename" := pFileName;
        InterfaceLogEntry."Invoice ID" := pInvoiceID;
        InterfaceLogEntry."Invoice Type" := pInvoiceType;
        InterfaceLogEntry."Purch. Document Type" := pPurchDocumentType;
        InterfaceLogEntry."Purch. Document No." := pPurchDocumentNo;
        InterfaceLogEntry."User Name" := CopyStr(UserID(), 1, MaxStrLen(InterfaceLogEntry."User Name"));
        InterfaceLogEntry."Company Name" := pCompanyName;
        InterfaceLogEntry."Ack Filename" := pAckFileName;
        InterfaceLogEntry.Insert();

        EXIT(InterfaceLogEntry."Entry No.");
    end;

    internal procedure ModifyLogInterface(pEntryNo: Integer; pFileName: Text[100]; pAckFileName: Text[100]; pInvoiceID: Text[100]; pInvoiceType: Option; pPurchDocumentType: Enum "Purchase Document Type"; pPurchDocumentNo: Code[20]; pStatementType: Option; pBankAccountNo: Code[20]; pStatementNo: Code[20]; pNumberLines: Integer; pCompanyName: Text[30]; pError: Boolean; pErrorMessage: Text[2048])
    var
        InterfaceLogEntry: Record "Interface Log Entry";
    begin
        IF NOT InterfaceLogEntry.GET(pEntryNo) THEN
            EXIT;

        InterfaceLogEntry."Filename" := pFileName;
        InterfaceLogEntry."Invoice ID" := pInvoiceID;
        InterfaceLogEntry."Invoice Type" := pInvoiceType;
        InterfaceLogEntry."Purch. Document Type" := pPurchDocumentType;
        InterfaceLogEntry."Purch. Document No." := pPurchDocumentNo;
        InterfaceLogEntry."Statement Type" := pStatementType;
        InterfaceLogEntry."Bank Account No." := pBankAccountNo;
        InterfaceLogEntry."Statement No." := pStatementNo;
        InterfaceLogEntry."Number of Lines Recon." := pNumberLines;
        InterfaceLogEntry."Ack Filename" := pAckFileName;
        IF pCompanyName <> '' THEN
            InterfaceLogEntry."Company Name" := pCompanyName;
        IF pError then begin
            InterfaceLogEntry.Error := pError;
            IF pErrorMessage <> '' THEN
                InterfaceLogEntry."Error Message" := pErrorMessage
            ELSE
                InterfaceLogEntry."Error Message" := CopyStr(GETLASTERRORTEXT(), 1, MaxStrLen(InterfaceLogEntry."Error Message"));
        end;
        InterfaceLogEntry.Modify();
    end;
}