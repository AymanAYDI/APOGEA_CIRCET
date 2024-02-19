codeunit 50028 "PDF Send Report Mgt"
{
    var
        GeneralApplicationSetup: Record "General Application Setup";

    procedure SendPaymentDocPDF(pPaymentStep: Record "Payment Step"; var pPaymentLine: Record "Payment Line")
    var
        ExtTextHeader: Record "Extended Text Header";
        ExtTextLine: Record "Extended Text Line";
        TempExtTextLine: Record "Extended Text Line" temporary;
        PaymentHeader: Record "Payment Header";
        PaymentLine, PaymentLineReport : Record "Payment Line";
        StandardText: Record "Standard Text";
        Vendor: Record "Vendor";
        extendedTextOk, return : Boolean;
        i, nbMails : Integer;
        TxtMessageLbl: Label '%1 mails are sent', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 e-mails envoyés"}]}';
        TxtNameLbl: Label '%1 %2 %3.pdf', Locked = true;
        Body, Subject : Text;
        FileName: Text[250];
        FileDirectory, ServerFileName : Text[1024];
    begin
        PaymentLine.COPY(pPaymentLine);
        pPaymentStep.TESTFIELD("Report No.");
        pPaymentStep.TESTFIELD("Mail Subject Text Code");
        pPaymentStep.TESTFIELD("Sender Email Address");

        GeneralApplicationSetup.GET();
        GeneralApplicationSetup.TestField("Mail Notice Of Transfer");

        StandardText.GET(pPaymentStep."Mail Subject Text Code");
        Subject := StandardText.Description;

        PaymentLine.SETCURRENTKEY("No.", "Account No.");
        PaymentLine.SetRange("Account Type", PaymentLine."Account Type"::Vendor);
        PaymentLine.SetFilter("Vendor E-Mail", '<>%1', '');
        if PaymentLine.FINDSET() then begin
            nbMails := 0;
            repeat
                if i = 0 then begin
                    PaymentHeader.GET(PaymentLine."No.");
                    ExtTextHeader.SETCURRENTKEY("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    ExtTextHeader.SETRANGE("Table Name", ExtTextHeader."Table Name"::"Standard Text");
                    ExtTextHeader.SETRANGE("No.", pPaymentStep."Mail Subject Text Code");
                    ExtTextHeader.SETRANGE("Starting Date", 0D, PaymentHeader."Document Date");
                    ExtTextHeader.SETFILTER("Ending Date", '%1..|%2', PaymentHeader."Document Date", 0D);
                    i := 1;
                end;

                // Génération fichier pdf
                FileName := STRSUBSTNO(TxtNameLbl, pPaymentStep."PDF File Name", PaymentLine."Document No.", PaymentLine."Account Name");

                // Correction nommage du fichier d'avis de virement afin d'exclure les caractères interdits qui doivent être remplacés par le caractère _.
                FileName := CONVERTSTR(FileName, '\/:*?"<>|', '_________');

                FileDirectory := CopyStr(TEMPORARYPATH, 1, MaxStrLen(FileDirectory));
                ServerFileName := CopyStr(CopyStr(FileDirectory, 1, MaxStrLen(FileDirectory)) + CopyStr(FileName, 1, MaxStrLen(FileName)), 1, MaxStrLen(ServerFileName));
                if EXISTS(ServerFileName) then
                    FILE.ERASE(ServerFileName);

                PaymentLineReport.Reset();
                PaymentLineReport.CopyFilters(PaymentLine);
                PaymentLineReport.SETRANGE("Line No.", PaymentLine."Line No.");
                PaymentLineReport.SETRANGE("Account No.", PaymentLine."Account No.");
                REPORT.SAVEASPDF(pPaymentStep."Report No.", ServerFileName, PaymentLineReport);

                // Envoi du fichier par mail
                extendedTextOk := true;
                Body := '';
                TempExtTextLine.DELETEALL();
                if Vendor."Language Code" = '' then begin
                    ExtTextHeader.SETRANGE("Language Code", '');
                    if not ExtTextHeader.FINDLAST() then
                        extendedTextOk := false;
                end else begin
                    ExtTextHeader.SETRANGE("Language Code", Vendor."Language Code");
                    if not ExtTextHeader.FINDLAST() then begin
                        ExtTextHeader.SETRANGE("All Language Codes", true);
                        ExtTextHeader.SETRANGE("Language Code", '');
                        if not ExtTextHeader.FINDLAST() then
                            extendedTextOk := false;
                    end;
                end;

                if extendedTextOk then begin
                    ExtTextLine.SETRANGE("Table Name", ExtTextHeader."Table Name");
                    ExtTextLine.SETRANGE("No.", ExtTextHeader."No.");
                    ExtTextLine.SETRANGE("Language Code", ExtTextHeader."Language Code");
                    ExtTextLine.SETRANGE("Text No.", ExtTextHeader."Text No.");
                    if ExtTextLine.FINDSET() then
                        repeat
                            TempExtTextLine := ExtTextLine;
                            TempExtTextLine.INSERT();
                        until ExtTextLine.NEXT() = 0;
                end;

                if TempExtTextLine.FINDSET() then
                    repeat
                        Body += TempExtTextLine.Text;
                    until TempExtTextLine.NEXT() = 0;

                return := SendMail(PaymentLine."Vendor E-Mail", pPaymentStep."Sender Email Address", GeneralApplicationSetup."Mail Notice Of Transfer", Subject, Body, ServerFileName, FileName);

                if return then
                    nbMails := nbMails + 1;

            until PaymentLine.NEXT() = 0;
            MESSAGE(TxtMessageLbl, nbMails);
        end;
    end;

    local procedure SendMail(ToAddresses: Text; CcAddresses: Text; BccAddresses: Text; Subject: Text; Body: Text; AttachFile: Text; AttachFilename: Text[250]): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        BccRecipients, CcRecipients, Recipients : List of [Text];
        TXT64: Text;
    begin
        CLEAR(EmailMessage);
        FileManagement.BLOBImportFromServerFile(TempBlob, AttachFile);
        TempBlob.CreateInStream(InStr);

        TXT64 := Base64Convert.ToBase64(InStr);

        Recipients.Add(ToAddresses);
        CcRecipients.add(CcAddresses);
        BccRecipients.add(BccAddresses);
        EmailMessage.Create(Recipients, Subject, Body, true, CcRecipients, BccRecipients);
        EmailMessage.AddAttachment(AttachFilename, 'application/pdf', TXT64);

        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            exit(true);
    end;
}