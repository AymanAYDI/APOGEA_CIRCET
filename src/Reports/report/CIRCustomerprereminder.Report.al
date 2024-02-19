report 50024 "CIR Customer Pre-Reminder"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRCustomerPreReminder.rdl';
    Caption = 'Customer pre-reminder', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Pré-relance client"}]}';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Customer"; "Customer")
        {
            RequestFilterFields = "No.";
            column(Customer_No_; "No.")
            {
            }
            dataitem("Currency"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER('> 0'));
                column(custAddress_9_; custAddress[9])
                {
                }
                column(custAddress_8_; custAddress[8])
                {
                }
                column(custAddress_7_; custAddress[7])
                {
                }
                column(custAddress_6_; custAddress[6])
                {
                }
                column(custAddress_5_; custAddress[5])
                {
                }
                column(custAddress_4_; custAddress[4])
                {
                }
                column(custAddress_3_; custAddress[3])
                {
                }
                column(custAddress_2_; custAddress[2])
                {
                }
                column(custAddress_1_; custAddress[1])
                {
                }
                column(Customer__VAT_Registration_No__; Customer."VAT Registration No.")
                {
                }
                column(Customer__No__; Customer."No.")
                {
                }
                column(Customer__Phone_No__; Customer."Phone No.")
                {
                }
                column(Customer_FIELDCAPTION__VAT_Registration_No___; Customer.FIELDCAPTION("VAT Registration No."))
                {
                }
                column(Customer_FIELDCAPTION__Phone_No___; Customer.FIELDCAPTION("Phone No."))
                {
                }
                column(recCompanyInfo_Picture; recCompanyInfo.Picture)
                {
                }
                column(WORKDATE; WORKDATE())
                {
                }
                column(txtLabelRegion; txtLabelRegion)
                {
                }
                column(region; region)
                {
                }
                column(txtLineFoot3; txtLineFoot3)
                {
                }
                column(txtLineFoot2; txtLineFoot2)
                {
                }
                column(txtLineFoot1; txtLineFoot1)
                {
                }
                column("Références_clientCaption"; CustomerReferences_Lbl)
                {
                }
                column(N__clientCaption; CustomerNo_Lbl)
                {
                }
                column(ReminderCaption; ReminderCaption_Lbl)
                {
                }
                column(Currency_Number; Number)
                {
                }
                dataitem(LetterTxt; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        ORDER(Ascending)
                                        WHERE(Number = CONST(1));
                    column(contactStr_4_; contactStr[4])
                    {
                    }
                    column(contactStr_3_; contactStr[3])
                    {
                    }
                    column(contactStr_2_; contactStr[2])
                    {
                    }
                    column(contactStr_1_; contactStr[1])
                    {
                    }
                    column("Ce_courrier_vous_informe_des_factures_venant_bientôt_à_échéance_Caption"; ThisLetterInfo_Lbl)
                    {
                    }
                    column(ATTENTION_____ceci_n_est_pas_une_relance_Caption; CAREFULNoRelaunch_Lbl)
                    {
                    }
                    column(Madame__Monsieur_Caption; Dear_Lbl)
                    {
                    }
                    column("Nous_vous_remercions_de_bien_vouloir_honorer_notre_nos_factures_à_la_date_d_échéance_convenue_Caption"; HonouringInvoce_Lbl)
                    {
                    }
                    column("En_cas_de_désaccord_avec_ce_relevé__merci_de_nous_en_informer_afin_que_nous_puissions_vous_adresserCaption"; InCaseOfDisagreement_Lbl)
                    {
                    }
                    column("les_pièces_manquantes_Caption"; Mising_Parts_Lbl)
                    {
                    }
                    column("Veuillez_agréer__Madame__Monsieur__l_expression_de_nos_respectueuses_salutations_Caption"; Regards_Lbl)
                    {
                    }
                    column(LetterTxt_Number; Number)
                    {
                    }
                    dataitem(DataItem8503; "Cust. Ledger Entry")
                    {
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code")
                                            ORDER(Ascending);
                        column(txtAmountUnit; txtAmountUnit)
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry__External_Document_No__; "External Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry__Due_Date_; "Due Date")
                        {
                        }
                        column(Cust__Ledger_Entry_Amount; Amount)
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Date_Caption; FIELDCAPTION("Document Date"))
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__Caption; FIELDCAPTION("Document No."))
                        {
                        }
                        column(Cust__Ledger_Entry__External_Document_No__Caption; FIELDCAPTION("External Document No."))
                        {
                        }
                        column(Cust__Ledger_Entry__Due_Date_Caption; FIELDCAPTION("Due Date"))
                        {
                        }
                        column(Montant_TTCCaption; AmountIncludingVAT_Lbl)
                        {
                        }
                        column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CALCFIELDS(Amount);
                        end;

                        trigger OnPreDataItem()
                        begin
                            COPYFILTERS(recCustLedgerEntry);
                            SETRANGE("Currency Code", Temp_recTmpCurrency.Code);
                            FindFirst();
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    AmountUnitP1_Lbl: Label '(%1)', Locked = true;
                begin
                    IF Number = 1 THEN
                        Temp_recTmpCurrency.FindFirst()
                    ELSE
                        Temp_recTmpCurrency.NEXT();

                    IF Temp_recTmpCurrency.Code = '' THEN
                        txtAmountUnit := STRSUBSTNO(AmountUnitP1_Lbl, recGLSetup."LCY Code")
                    ELSE
                        txtAmountUnit := STRSUBSTNO(AmountUnitP1_Lbl, Temp_recTmpCurrency.Code);
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, Temp_recTmpCurrency.COUNT);
                end;
            }

            trigger OnAfterGetRecord()
            var
                cduFormatAddress: Codeunit "Format Address Mgt.";
            begin
                cduFormatAddress.CustomerExtended(custAddress, Customer);

                Temp_recTmpCurrency.RESET();
                Temp_recTmpCurrency.DELETEALL(FALSE);
                recCustLedgerEntry.SETRANGE("Customer No.", "No.");
                IF recCustLedgerEntry.FindFirst() THEN
                    REPEAT
                        Temp_recTmpCurrency.Code := recCustLedgerEntry."Currency Code";
                        IF Temp_recTmpCurrency.INSERT(FALSE) THEN;
                    UNTIL recCustLedgerEntry.NEXT() = 0
                ELSE
                    CurrReport.SKIP();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(region; region)
                    {
                        Caption = 'Region', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Région"}]}';
                        ToolTip = 'Region', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Région"}]}';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                                      "Dimension Value Type" = FILTER('Total|End-Total'));
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        recDimValue: Record "Dimension Value";
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        GeneralApplicationSetup: Record "General Application Setup";
        lineIndex: Integer;
        FilterP1OrP2_Lbl: Label '%1|%2', Locked = true;
        FilterP1AndP2_Lbl: Label '>%1 & <=%2', Locked = true;
    begin
        GeneralApplicationSetup.Init();
        if GeneralApplicationSetup.get() then;
        GeneralApplicationSetup.TestField("Pre-relaunch Period");

        recCustLedgerEntry.RESET();
        recCustLedgerEntry.SETCURRENTKEY("Customer No.",
                                         Open,
                                         "Global Dimension 1 Code",
                                         "Global Dimension 2 Code",
                                         Positive,
                                         "Due Date",
                                         "Currency Code");

        IF region <> '' THEN BEGIN
            recDimValue.RESET();
            recDimValue.SETRANGE("Global Dimension No.", 1);
            recDimValue.SETRANGE(Code, region);
            recDimValue.SETFILTER("Dimension Value Type",
                                  STRSUBSTNO(FilterP1OrP2_Lbl, recDimValue."Dimension Value Type"::Total,
                                                     recDimValue."Dimension Value Type"::"End-Total"));

            IF recDimValue.FindFirst() THEN
                recCustLedgerEntry.SETFILTER("Global Dimension 1 Code", recDimValue.Totaling);
        END;

        recCustLedgerEntry.SETRANGE(Open, TRUE);
        recCustLedgerEntry.SETRANGE(Positive, TRUE);
        recCustLedgerEntry.SETFILTER("Due Date", STRSUBSTNO(FilterP1AndP2_Lbl, WORKDATE(),
                                                CALCDATE(GeneralApplicationSetup."Pre-relaunch Period", WORKDATE())));

        IF region <> '' THEN
            txtLabelRegion := Region_Lbl;

        recCompanyInfo.GET();

        recCompanyInfo.CALCFIELDS(Picture);

        recGLSetup.GET();

        UserSetup.GET(UserId);
        IF Employee.GET(UserSetup.ARBVRNRelatedResourceNo) THEN;

        lineIndex := 1;
        CLEAR(contactStr);
        contactStr[lineIndex] := Employee."First Name" + ' ' + Employee."Last Name";
        IF Employee."E-mail" <> '' THEN BEGIN
            lineIndex += 1;
            contactStr[lineIndex] := Employee."E-mail";
        END;
        IF Employee."Phone No." <> '' THEN BEGIN
            lineIndex += 1;
            contactStr[lineIndex] := StrSubstNo(Phone_Lbl, Employee."Phone No.");
        END;
        IF Employee."Fax No." <> '' THEN BEGIN
            lineIndex += 1;
            contactStr[lineIndex] := StrSubstNo(Fax_Lbl, Employee."Fax No.");
        END;

        txtLineFoot1 := HeadOffice_Lbl;
        IF recCompanyInfo.Address <> '' THEN
            txtLineFoot1 := CopyStr(txtLineFoot1 + recCompanyInfo.Address + ' - ', 1, MaxStrLen(txtLineFoot1));
        IF recCompanyInfo."Address 2" <> '' THEN
            txtLineFoot1 := CopyStr(txtLineFoot1 + recCompanyInfo."Address 2" + ' - ', 1, MaxStrLen(txtLineFoot1));
        txtLineFoot1 := CopyStr(txtLineFoot1 + recCompanyInfo."Post Code" + ' ' + recCompanyInfo.City, 1, MaxStrLen(txtLineFoot1));

        txtLineFoot2 := StrSubstNo(Phone_Lbl, recCompanyInfo."Phone No.") + ' - ' + StrSubstNo(Fax_Lbl, recCompanyInfo."Fax No.") + ' - ';
        txtLineFoot2 := CopyStr(txtLineFoot2 + recCompanyInfo."Email Sales Accounting" + ' - ' + recCompanyInfo."Home Page", 1, MaxStrLen(txtLineFoot2));

        txtLineFoot3 := recCompanyInfo."Legal Form" + Capital_Lbl + recCompanyInfo."Stock Capital" + ' - ';
        txtLineFoot3 := CopyStr(txtLineFoot3 + recCompanyInfo."Trade Register" + ' - ', 1, MaxStrLen(txtLineFoot3));
        txtLineFoot3 := CopyStr(txtLineFoot3 + 'Siret ' + recCompanyInfo."Registration No." + ' - ', 1, MaxStrLen(txtLineFoot3));
        txtLineFoot3 := CopyStr(txtLineFoot3 + 'Code APE ' + recCompanyInfo."APE Code" + ' - ', 1, MaxStrLen(txtLineFoot3));
        txtLineFoot3 := CopyStr(txtLineFoot3 + 'TVA : ' + recCompanyInfo."VAT Registration No.", 1, MaxStrLen(txtLineFoot3));
    end;

    var
        Temp_recTmpCurrency: Record Currency temporary;
        recCustLedgerEntry: Record "Cust. Ledger Entry";
        recCompanyInfo: Record "Company Information";
        recGLSetup: Record "General Ledger Setup";
        txtLineFoot1: Text[250];
        txtLineFoot2: Text[250];
        txtLineFoot3: Text[250];
        custAddress: array[10] of Text[50];
        txtAmountUnit: Code[12];
#pragma warning disable AA0204
        region: Code[20];
#pragma warning restore AA0204
        txtLabelRegion: Text[30];
        contactStr: array[4] of Text[100];
        CustomerReferences_Lbl: Label 'Customer references', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Références client"}]}';
        CustomerNo_Lbl: Label 'Customer No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° client"}]}';
        ReminderCaption_Lbl: Label 'Reminder', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Pré-relance"}]}';
        ThisLetterInfo_Lbl: Label 'This letter informs you of invoices coming soon to maturity.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce courrier vous informe des factures venant bientôt à échéance."}]}';
        CAREFULNoRelaunch_Lbl: Label 'CAREFUL! : this is not a relaunch.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ATTENTION ! : ceci n''est pas une relance."}]}';
        Dear_Lbl: Label 'Dear Madam, Sir,', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Madame, Monsieur,"}]}';
        HonouringInvoce_Lbl: Label 'Thank you for honouring our invoice(s) on the agreed due date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nous vous remercions de bien vouloir honorer notre/nos factures à la date d''échéance convenue."}]}';
        InCaseOfDisagreement_Lbl: Label 'In case of disagreement with this statement, please inform us so that we can address you', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"En cas de désaccord avec ce relevé, merci de nous en informer afin que nous puissions vous adresser"}]}';
        Mising_Parts_Lbl: Label 'missing parts.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"les pièces manquantes."}]}';
        Regards_Lbl: Label 'Regards', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez agréer, Madame, Monsieur, l''expression de nos respectueuses salutations."}]}';
        AmountIncludingVAT_Lbl: Label 'Amount including VAT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant TTC"}]}';
        Phone_Lbl: Label 'Phone : %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél. : %1"}]}';
        Fax_Lbl: Label 'Fax : %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fax : %1"}]}';
        Region_Lbl: Label 'Region : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Region : "}]}';
        HeadOffice_Lbl: Label 'Head office : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Siège Social : "}]}';
        Capital_Lbl: Label ' with capital of ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" au capital de "}]}';
}