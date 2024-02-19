xmlport 50008 "CIR SEPA CT pain.001.001.03"
{
    Caption = 'SEPA CT pain.001.001.03', Locked = true;
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        tableelement("Gen. Journal Line"; "Gen. Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(controlsum)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        //Ajout NAV17
                        textelement(initgptypstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    IF CompanyInformation.Address = '' THEN
                                        currXMLport.SKIP();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    IF CompanyInformation."Post Code" = '' THEN
                                        currXMLport.SKIP();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    IF CompanyInformation.City = '' THEN
                                        currXMLport.SKIP();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    IF CompanyInformation."Country/Region Code" = '' THEN
                                        currXMLport.SKIP();
                                end;
                            }
                        }
                        //FIN AJOUT NAV17
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(initgptyothrinitgpty)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(Id; CompanyInformation."VAT Registration No.")
                                    {
                                    }
                                }
                            }
                        }
                    }
                }
                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    fieldelement(PmtInfId; PaymentExportDataGroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd; PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    fieldelement(NbOfTxs; PaymentExportDataGroup."Line No.")
                    {
                    }
                    fieldelement(CtrlSum; PaymentExportDataGroup.Amount)
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        fieldelement(InstrPrty; PaymentExportDataGroup."SEPA Instruction Priority Text")
                        {
                        }
                        //suppression balise SEPA textelement(SvcLvl) / textelement(cd)
                    }
                    fieldelement(ReqdExctnDt; PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.Address = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Post Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.City = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Country/Region Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(BICOrBEI; PaymentExportDataGroup."Sender Bank BIC")
                                {
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            fieldelement(IBAN; PaymentExportDataGroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC; PaymentExportDataGroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }

                        trigger OnBeforePassVariable()
                        begin
                            if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                currXMLport.Skip();
                        end;
                    }
                    fieldelement(ChrgBr; PaymentExportDataGroup."SEPA Charge Bearer Text")
                    {
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = FIELD("Sender Bank BIC"), "SEPA Instruction Priority Text" = FIELD("SEPA Instruction Priority Text"), "Transfer Date" = FIELD("Transfer Date"), "SEPA Batch Booking" = FIELD("SEPA Batch Booking"), "SEPA Charge Bearer Text" = FIELD("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy; PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BIC; PaymentExportData."Recipient Bank BIC")
                                {
                                    FieldValidate = yes;
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportData."Recipient Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(StrtNm; PaymentExportData."Recipient Address")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Address" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(PstCd; PaymentExportData."Recipient Post Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Post Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(TwnNm; PaymentExportData."Recipient City")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient City" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Country/Region Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    if (PaymentExportData."Recipient Address" = '') and
                                       (PaymentExportData."Recipient Post Code" = '') and
                                       (PaymentExportData."Recipient City" = '') and
                                       (PaymentExportData."Recipient Country/Region Code" = '')
                                    then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(IBAN; PaymentExportData."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = yes;
                                    MaxOccurs = Once;
                                    MinOccurs = Once;

                                    //AJOUT NAV17
                                    trigger OnBeforePassField()
                                    begin
                                        // Anomalie #6443 : Reprise de la génération du fichier de virement SEPA international pour la gestion des banques sans IBAN. Le format
                                        //                  actuel généré par Navision, qui se présente avec la structure suivante, est rejeté par Allmybanks :
                                        //                    ...
                                        //                    <CdtrAcct>
                                        //                      <Id>
                                        //                        <IBAN>90...009</IBAN>
                                        //                      </Id>
                                        //                    </CdtrAcct>
                                        //                    ...
                                        //                  Le format attendu est le suivant :
                                        //                    <CdtrAcct>
                                        //                      <Id>
                                        //                        <Othr>
                                        //                          <Id>90...009</Id>
                                        //                        </Othr>
                                        //                      </Id>
                                        //                    </CdtrAcct>

                                        IF NOT IsIBAN(PaymentExportData."Recipient Bank Acc. No.") THEN
                                            currXMLport.SKIP();
                                    end;
                                }
                                textelement(Othr)
                                {
                                    fieldelement(Id; PaymentExportData."Recipient Bank Acc. No.")
                                    {
                                    }

                                    trigger OnBeforePassVariable()
                                    begin
                                        // Anomalie #6443 : Reprise de la génération du fichier de virement SEPA international pour la gestion des banques sans IBAN. Le format
                                        //                  actuel généré par Navision, qui se présente avec la structure suivante, est rejeté par Allmybanks :
                                        //                    ...
                                        //                    <CdtrAcct>
                                        //                      <Id>
                                        //                        <IBAN>90...009</IBAN>
                                        //                      </Id>
                                        //                    </CdtrAcct>
                                        //                    ...
                                        //                  Le format attendu est le suivant :
                                        //                    <CdtrAcct>
                                        //                      <Id>
                                        //                        <Othr>
                                        //                          <Id>90...009</Id>
                                        //                        </Othr>
                                        //                      </Id>
                                        //                    </CdtrAcct>

                                        IF IsIBAN(PaymentExportData."Recipient Bank Acc. No.") THEN
                                            currXMLport.SKIP();
                                    end;
                                    //FIN AJOUT NAV17
                                }
                            }
                        }
                        textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext1) //modification NAV17
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }
                            textelement(remittancetext2) //Ajout NAV17
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';

                                trigger OnBeforePassVariable() //Ajout NAV17
                                begin
                                    IF RemittanceText2 = '' THEN
                                        currXMLport.SKIP();
                                end;
                            }

                            trigger OnBeforePassVariable() //Ajout NAV17
                            begin
                                RemittanceText1 := '';
                                RemittanceText2 := '';
                                TempPaymentExportRemittanceText.SETRANGE("Pmt. Export Data Entry No.", PaymentExportData."Entry No.");
                                IF NOT TempPaymentExportRemittanceText.FINDSET() THEN
                                    currXMLport.SKIP();
                                RemittanceText1 := TempPaymentExportRemittanceText.Text;
                                IF TempPaymentExportRemittanceText.NEXT() = 0 THEN
                                    EXIT;
                                RemittanceText2 := TempPaymentExportRemittanceText.Text;
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters() then
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        InitData();
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.';

    local procedure InitData()
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        PaymentGroupNo: Integer;
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        NoOfTransfers := Format(PaymentExportData.Count);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDateTime, 19, 9);
        PaymentExportData.CalcSums(Amount);
        ControlSum := Format(PaymentExportData.Amount, 0, 9);

        PaymentExportData.SetCurrentKey(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        if not PaymentExportData.FindSet() then
            Error(NoDataToExportErr);

        InitPmtGroup();
        repeat
            if IsNewGroup() then begin
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup();
            end;
            PaymentExportDataGroup."Line No." += 1;
            PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        until PaymentExportData.Next() = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean
    begin
        exit(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") or
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") or
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") or
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") or
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup()
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer)
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          COPYSTR(
#pragma warning disable AA0217 // TODO: - Caption %1 | %2
            STRSUBSTNO('%1/%2', PaymentExportData."Message ID", PaymentGroupNo),
#pragma warning restore AA0217 // TODO: - Caption %1 | %2
            1, MAXSTRLEN(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.INSERT();
    end;

    local procedure IsIBAN(numIban: Code[50]): Boolean //Ajout NAV17
    var
        codePays: Code[2];
    begin
        // Anomalie #6443 : Reprise de la génération du fichier de virement SEPA international pour la gestion des banques sans IBAN. Le format
        //                  actuel généré par Navision, qui se présente avec la structure suivante, est rejeté par Allmybanks :
        //                    ...
        //                    <CdtrAcct>
        //                      <Id>
        //                        <IBAN>90...009</IBAN>
        //                      </Id>
        //                    </CdtrAcct>
        //                    ...
        //                  Le format attendu est le suivant :
        //                    <CdtrAcct>
        //                      <Id>
        //                        <Othr>
        //                          <Id>90...009</Id>
        //                        </Othr>
        //                      </Id>
        //                    </CdtrAcct>

        // Description :
        //       Test de la validité d'un N° d'IBAN
        // Paramètres d'entrée :
        //    - numIban : N° d'IBAN à valider
        // Paramètre de sortie : compte rendu de test :
        //    - FALSE : N° d'IBAN invalide
        //    - TRUE : N° d'IBAN valide

        // Test validité de la longueur de l'IBAN [14,34]
        IF (STRLEN(numIban) > 34) OR (STRLEN(numIban) <= 14) THEN
            EXIT(FALSE);

        // Extraction du code pays de l'IBAN
        codePays := COPYSTR(numIban, 1, 2);

        // Test spécification du pays
        IF codePays = '##' THEN
            EXIT(FALSE)
        ELSE
            IF CONVERTSTR(codePays, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '##########################') <> '##' THEN
                EXIT(FALSE);

        EXIT(TRUE);

    end;
}