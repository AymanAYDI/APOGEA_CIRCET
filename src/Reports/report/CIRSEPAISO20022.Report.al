report 50028 "CIR SEPA ISO20022"
{
    Caption = 'SEPA ISO20022', Locked = TRUE;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payment Header"; "Payment Header")
        {

            trigger OnAfterGetRecord()
            begin
                TestField(IBAN);
                TestField("SWIFT Code");
                TestField("Bank Country/Region Code");
                if not CheckBankCountrySEPAAllowed("Bank Country/Region Code") then
                    Error(SEPANotEnabledForPaymentErrLbl, "Bank Country/Region Code");
                PaymentLine.Reset();
                PaymentLine.SetRange("No.", "No.");
                CheckPaymentLines();
                ExportSEPAFile();
            end;

            trigger OnPostDataItem()
            begin
                PaymentHeader := "Payment Header";
                PaymentHeader."File Export Completed" := true;
                PaymentHeader.Modify();
            end;
        }
    }

    trigger OnPostReport()
    var
        FileMgt: Codeunit "File Management";
        ToFile: Text;
    begin
        ToFile := Text009Lbl;

        if ServerFileName <> '' then
            FileMgt.CopyServerFile(FileName, ServerFileName, true)
        else
            if not FileMgt.DownloadHandler(FileName, Text000Lbl, '', Text001Lbl, ToFile) then
                Error(Text010Lbl);
    end;

    trigger OnPreReport()
    var
        FileMgt: Codeunit "File Management";
    begin
        // Perform Checks
        CompanyInfo.Get();
        CompanyInfo.TestField("Country/Region Code");
        CompanyInfo.TestField("VAT Registration No.");

        FileName := FileMgt.ServerTempFileName('');

        if DelChr(FileName, '<>') = '' then
            Error(Text002Lbl);
    end;

    var
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        CompanyInfo: Record "Company Information";
        SEPACountry: Record "Country/Region";
        XMLDomDoc: DotNet XmlDocument;
        FileName: Text;
        Text000Lbl: Label 'Save As', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Enregistrer sous"}]}';
        Text001Lbl: Label 'XML Files (*.xml)|*.xml|All Files|*.*', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fichiers XML (*.xml)|*.xml|Tous les fichiers|*.*"}]}';
        Text002Lbl: Label 'File name must be specified', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le nom du fichier doit être spécifié"}]}';
        SEPANotEnabledForVendorErrLbl: Label 'The SEPA Allowed field is not enabled for the Country/Region: %1 of the Vendor Bank Account: %2',
                                            Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le champ SEPA autorisé n''est pas activé pour le Pays/Région: %1 du compte bancaire du fournisseur: %2."}]}';
        ServerFileName: Text;
        PaymentLineCount: Integer;
        SEPANotEnabledForPaymentErrLbl: Label 'The SEPA Allowed field is not enabled for the Country/Region: %1 of the Payment Header: Bank Country/Region Code',
                                        Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le champ SEPA autorisé n''est pas activé pour le pays/la région: %1 de l''en-tête de paiement: le code du pays/de la région de la banque"}]}';
        Text004Lbl: Label 'Currency is not Euro in the %1, %2: %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La devise n''est pas l''euro dans le %1, %2: %3"}]}';
        Text005Lbl: Label 'Payment Lines can only be of type Customer or Vendor for SEPA', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les Lignes de Paiement ne peuvent être de type Client ou Fournisseur que pour le SEPA"}]}';
        Text009Lbl: Label 'default.xml', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"default.xml"}]}';
        Text010Lbl: Label 'File download failed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Échec du téléchargement du fichier"}]}';
        Text011Lbl: Label 'Amount cannot be negative in the %1, %2: %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le montant ne peut pas être négatif dans %1, %2: %3"}]}';

    local procedure ExportSEPAFile()
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootElement: DotNet XmlElement;
        XMLNodeCurr: DotNet XmlNode;
        XMLNewChild: DotNet XmlNode;
    begin
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8"?><Document></Document>', XMLDomDoc);
        XMLRootElement := XMLDomDoc.DocumentElement;
        XMLRootElement.SetAttribute('xmlns', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.02');
        XMLRootElement.SetAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchemainstance');
        XMLNodeCurr := XMLDomDoc.SelectSingleNode('Document');
        AddElement(XMLNodeCurr, 'pain.001.001.02', '', '', XMLNewChild);

        ExportGroupHeader(XMLNewChild);
        ExportPaymentInformation(XMLNewChild);

        XMLDomDoc.Save(FileName);
        Clear(XMLDomDoc);
    end;

    local procedure ExportGroupHeader(XMLNodeCurr: DotNet XmlNode)
    var
        XMLNewChild: DotNet XmlNode;
        MessageId: Text[50];
    begin
        AddElement(XMLNodeCurr, 'GrpHdr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        MessageId := "Payment Header"."No.";
        if StrLen(MessageId) > 35 then
            MessageId := Format(CopyStr(MessageId, StrLen(MessageId) - 34));

        AddElement(XMLNodeCurr, 'MsgId', MessageId, '', XMLNewChild);
        AddElement(XMLNodeCurr, 'CreDtTm', Format(CurrentDateTime, 19, 9), '', XMLNewChild);

        PaymentLine.Reset();
        PaymentLine.SetRange("No.", "Payment Header"."No.");
        AddElement(XMLNodeCurr, 'NbOfTxs', Format(PaymentLineCount, 0, 9), '', XMLNewChild);
        "Payment Header".CalcFields(Amount);
        AddElement(XMLNodeCurr, 'CtrlSum', Format("Payment Header".Amount, 0, '<Precision,2:2><Standard Format,9>'), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'Grpg', 'MIXD', '', XMLNewChild);
        AddElement(XMLNodeCurr, 'InitgPty', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Nm', CompanyInfo.Name, '', XMLNewChild);
        AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'OrgId', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'TaxIdNb', Format(DelChr(CompanyInfo."VAT Registration No."), 0, 9), '', XMLNewChild);

        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
    end;

    local procedure ExportPaymentInformation(XMLNodeCurr: DotNet XmlNode)
    var
        XMLNewChild: DotNet XmlNode;
        AddressLine1: Text[151];
        AddressLine2: Text[60];
        EndtoEndIdTxt: Text[35];
        UstrdRemitInfo: Text[140];
    begin
        AddElement(XMLNodeCurr, 'PmtInf', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'PmtInfId', "Payment Header"."No.", '', XMLNewChild);
        AddElement(XMLNodeCurr, 'PmtMtd', 'TRF', '', XMLNewChild);
        AddElement(XMLNodeCurr, 'PmtTpInf', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'SvcLvl', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Cd', 'SEPA', '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'ReqdExctnDt', Format("Payment Header"."Posting Date", 0, 9), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'Dbtr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Nm', CompanyInfo.Name, '', XMLNewChild);

        AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddressLine1 := DelChr(CompanyInfo.Address, '<>') + ' ' + DelChr(CompanyInfo."Address 2", '<>');
        if DelChr(AddressLine1) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 70), '', XMLNewChild);

        AddressLine2 := DelChr(CompanyInfo."Post Code", '<>') + ' ' + DelChr(CompanyInfo.City, '<>');
        if DelChr(AddressLine2) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 70), '', XMLNewChild);

        AddElement(XMLNodeCurr, 'Ctry', CopyStr(CompanyInfo."Country/Region Code", 1, 2), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'DbtrAcct', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'IBAN', CopyStr(DelChr("Payment Header".IBAN), 1, 34), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'Ccy', 'EUR', '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'DbtrAgt', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'FinInstnId', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'BIC', CopyStr(DelChr("Payment Header"."SWIFT Code"), 1, 11), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'ChrgBr', 'SLEV', '', XMLNewChild);

        if PaymentLine.FINDSET() then
            repeat
                AddElement(XMLNodeCurr, 'CdtTrfTxInf', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddElement(XMLNodeCurr, 'PmtId', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                EndtoEndIdTxt := PaymentLine."Document No.";
                if DelChr(PaymentLine.Reference, '<>') <> '' then begin
                    if EndtoEndIdTxt <> '' then
                        EndtoEndIdTxt += '.';
                    EndtoEndIdTxt += DelChr(PaymentLine.Reference, '<>');
                end;
                if DelChr(EndtoEndIdTxt, '<>') = '' then
                    EndtoEndIdTxt := 'NOTPROVIDED';

                AddElement(XMLNodeCurr, 'EndToEndId', CopyStr(EndtoEndIdTxt, 1, 35), '', XMLNewChild);
                XMLNodeCurr := XMLNodeCurr.ParentNode;

                AddElement(XMLNodeCurr, 'Amt', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;
                if PaymentLine.Amount < 0 then
                    Error(Text011Lbl, PaymentLine.TableCaption, PaymentLine.FieldCaption("Line No."), PaymentLine."Line No.");
                AddElement(XMLNodeCurr, 'InstdAmt', Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,9>'), '', XMLNewChild);
                AddAttribute(XMLDomDoc, XMLNewChild, 'Ccy', 'EUR');
                XMLNodeCurr := XMLNodeCurr.ParentNode;

                AddElement(XMLNodeCurr, 'CdtrAgt', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddElement(XMLNodeCurr, 'FinInstnId', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddElement(XMLNodeCurr, 'BIC', CopyStr(DelChr(PaymentLine."SWIFT Code"), 1, 11), '', XMLNewChild);
                XMLNodeCurr := XMLNodeCurr.ParentNode;
                XMLNodeCurr := XMLNodeCurr.ParentNode;

                AddElement(XMLNodeCurr, 'Cdtr', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddAccountInformation(XMLNodeCurr);

                AddElement(XMLNodeCurr, 'CdtrAcct', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
                XMLNodeCurr := XMLNewChild;

                AddElement(XMLNodeCurr, 'IBAN', CopyStr(DelChr(PaymentLine.IBAN), 1, 34), '', XMLNewChild);
                XMLNodeCurr := XMLNodeCurr.ParentNode;
                XMLNodeCurr := XMLNodeCurr.ParentNode;

                UstrdRemitInfo := CreateUstrdRemitInfo();
                if DelChr(UstrdRemitInfo) <> '' then begin
                    AddElement(XMLNodeCurr, 'RmtInf', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;
                    AddElement(XMLNodeCurr, 'Ustrd', UstrdRemitInfo, '', XMLNewChild);
                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                end;

                XMLNodeCurr := XMLNodeCurr.ParentNode;
            until PaymentLine.Next() = 0;

        XMLNodeCurr := XMLNodeCurr.ParentNode;
    end;

    local procedure AddElement(var XMLNode: DotNet XmlNode; NodeName: Text; NodeText: Text; NameSpace: Text[250]; var CreatedXMLNode: DotNet XmlNode): Boolean
    var
        StringConversionMgt: Codeunit StringConversionManagement;
        NewChildNode: DotNet XmlNode;
    begin
        NewChildNode := XMLNode.OwnerDocument.CreateNode('element', NodeName, NameSpace);
        if IsNull(NewChildNode) then
            exit(false);

        if NodeText <> '' then
            NewChildNode.InnerText := StringConversionMgt.WindowsToASCII(NodeText);
        XMLNode.AppendChild(NewChildNode);
        CreatedXMLNode := NewChildNode;
        Clear(NewChildNode);
        exit(true);
    end;

    local procedure AddAttribute(var XMLDomDocParam: DotNet XmlDocument; var XMLDomNode: DotNet XmlNode; AttribName: Text[250]; AttribValue: Text[250]): Boolean
    var
        XMLDomAttribute: DotNet XmlAttribute;
    begin
        XMLDomAttribute := XMLDomDocParam.CreateAttribute(AttribName);
        if IsNull(XMLDomAttribute) then
            exit(false);

        if AttribValue <> '' then
            XMLDomAttribute.Value := AttribValue;
        XMLDomNode.Attributes.SetNamedItem(XMLDomAttribute);
        Clear(XMLDomAttribute);
        exit(true);
    end;

    local procedure AddAccountInformation(var XMLNodeCurr: DotNet XmlNode)
    var
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        case PaymentLine."Account Type" of
            PaymentLine."Account Type"::Customer:
                begin
                    Cust.Get(PaymentLine."Account No.");
                    AddAccountTags(XMLNodeCurr, Cust.Name, Cust.Address, Cust."Address 2", Cust."Post Code", Cust.City, Cust."Country/Region Code");
                end;
            PaymentLine."Account Type"::Vendor:
                begin
                    Vend.Get(PaymentLine."Account No.");
                    AddAccountTags(XMLNodeCurr, Vend.Name, Vend.Address, Vend."Address 2", Vend."Post Code", Vend.City, Vend."Country/Region Code");
                end;
        end;
    end;

    local procedure AddAccountTags(var XMLNodeCurr: DotNet XmlNode; AccountName: Text; Address: Text; Address2: Text[70]; PostCode: Text[70]; City: Text[70]; CountryCode: Text[10])
    var
        XMLNewChild: DotNet XmlNode;
        AddressLine1: Text[150];
        AddressLine2: Text[150];
    begin
        AddElement(XMLNodeCurr, 'Nm', AccountName, '', XMLNewChild);
        AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddressLine1 := DelChr(Address, '<>') + ' ' + DelChr(Address2, '<>');
        if DelChr(AddressLine1) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 70), '', XMLNewChild);
        AddressLine2 := DelChr(PostCode, '<>') + ' ' + DelChr(City, '<>');
        if DelChr(AddressLine2) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 70), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'Ctry', CopyStr(CountryCode, 1, 2), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
    end;

    local procedure CheckBankCountrySEPAAllowed(CountryCode: Code[10]): Boolean
    begin
        if SEPACountry.Code <> CountryCode then
            SEPACountry.Get(CountryCode);
        exit(SEPACountry."SEPA Allowed");
    end;

    local procedure CheckPaymentLines()
    var
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
    begin
        // Loop through all Payment lines and perform validations
        PaymentLineCount := 0;
        if PaymentLine.FINDSET() then
            repeat
                PaymentLine.TestField(IBAN);
                PaymentLine.TestField("SWIFT Code");
                case PaymentLine."Account Type" of
                    PaymentLine."Account Type"::Vendor:
                        begin
                            VendorBankAcc.Get(PaymentLine."Account No.", PaymentLine."Bank Account Code");
                            VendorBankAcc.TestField("Country/Region Code");
                            if not CheckBankCountrySEPAAllowed(VendorBankAcc."Country/Region Code") then
                                Error(SEPANotEnabledForVendorErrLbl, SEPACountry.Code,
                                  VendorBankAcc."Vendor No." + ',' + VendorBankAcc.Code);
                        end;
                    PaymentLine."Account Type"::Customer:
                        begin
                            CustomerBankAcc.Get(PaymentLine."Account No.", PaymentLine."Bank Account Code");
                            CustomerBankAcc.TestField("Country/Region Code");
                            if not CheckBankCountrySEPAAllowed(CustomerBankAcc."Country/Region Code") then
                                Error(SEPANotEnabledForVendorErrLbl, SEPACountry.Code,
                                  CustomerBankAcc."Customer No." + ',' + CustomerBankAcc.Code);
                        end;
                end;
                CheckEUCurrencyInLines(PaymentLine."Currency Code");
                if not (PaymentLine."Account Type" in [PaymentLine."Account Type"::Customer, PaymentLine."Account Type"::Vendor]) then
                    Error(Text005Lbl);
                PaymentLineCount := PaymentLineCount + 1;
            until PaymentLine.Next() = 0;
    end;

    local procedure CheckEUCurrencyInLines(CurrencyCode: Code[10])
    var
        GLSetup: Record "General Ledger Setup";
    begin
        // Check whether the currency being used is Euro
        GLSetup.Get();
        case GLSetup."Local Currency" of
            GLSetup."Local Currency"::Euro:
                if CurrencyCode <> '' then
                    Error(Text004Lbl, PaymentLine.TableCaption, PaymentLine.FieldCaption("Line No."), PaymentLine."Line No.");
            GLSetup."Local Currency"::Other:
                begin
                    GLSetup.TestField("Currency Euro");
                    if CurrencyCode <> GLSetup."Currency Euro" then
                        Error(Text004Lbl, PaymentLine.TableCaption, PaymentLine.FieldCaption("Line No."), PaymentLine."Line No.");
                end;
        end;
    end;


    procedure CreateUstrdRemitInfo(): Text[140]
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        UstrdRemitInfo: Text[140];
        Separator: Text[1];
        LoopBreak: Boolean;
    begin
        UstrdRemitInfo := '';
        LoopBreak := false;
        if ((DelChr(PaymentLine."Applies-to Doc. No.") = '') and
            (DelChr(PaymentLine."Applies-to ID") = ''))
        then
            exit(UstrdRemitInfo);
        case PaymentLine."Account Type" of
            PaymentLine."Account Type"::Vendor:
                if DelChr(PaymentLine."Applies-to Doc. No.") <> '' then
                    UstrdRemitInfo := DelChr(PaymentLine."Applies-to Doc. No.")
                else begin
                    VendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                    VendLedgEntry.SetRange("Vendor No.", PaymentLine."Account No.");
                    VendLedgEntry.SetRange("Applies-to ID", PaymentLine."Applies-to ID");
                    if VendLedgEntry.FindSet() then
                        repeat
                            if UstrdRemitInfo = '' then
                                Separator := ''
                            else
                                Separator := ',';
                            if DelChr(VendLedgEntry."External Document No.") <> '' then
                                if StrLen(UstrdRemitInfo + Separator + DelChr(VendLedgEntry."External Document No.")) <= 140 then
                                    UstrdRemitInfo := Format(UstrdRemitInfo + Separator + DelChr(VendLedgEntry."External Document No."))
                                else
                                    LoopBreak := true;
                        until (VendLedgEntry.Next() = 0) or LoopBreak;
                end;
            PaymentLine."Account Type"::Customer:
                if DelChr(PaymentLine."Applies-to Doc. No.") <> '' then
                    UstrdRemitInfo := PaymentLine."Applies-to Doc. No."
                else begin
                    CustLedgEntry.SetCurrentKey("Customer No.", "Applies-to ID");
                    CustLedgEntry.SetRange("Customer No.", PaymentLine."Account No.");
                    CustLedgEntry.SetRange("Applies-to ID", PaymentLine."Applies-to ID");
                    if CustLedgEntry.FindSet() then
                        repeat
                            if UstrdRemitInfo = '' then
                                Separator := ''
                            else
                                Separator := ',';
                            if DelChr(CustLedgEntry."Document No.") <> '' then
                                if StrLen(UstrdRemitInfo + Separator + DelChr(CustLedgEntry."Document No.")) <= 140 then
                                    UstrdRemitInfo := Format(UstrdRemitInfo + Separator + DelChr(CustLedgEntry."Document No."))
                                else
                                    LoopBreak := true;
                        until (CustLedgEntry.Next() = 0) or LoopBreak;
                end;
        end;
        exit(UstrdRemitInfo);
    end;


    procedure SetFilePath(FilePath: Text)
    begin
        ServerFileName := FilePath;
    end;
}