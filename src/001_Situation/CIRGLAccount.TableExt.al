tableextension 50505 "CIR G/L Account" extends "G/L Account"
{
    fields
    {
        field(50500; "CIR G/L Entry Type Filter"; Option)
        {
            Caption = 'G/L Entry Type Filter', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Filtre type écriture" }, { "lang": "FRB", "txt": "Filtre type écriture" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowFilter;
            OptionMembers = Definitive,Situation;
        }
#pragma warning disable AA0232
        field(50501; "CIR Balance At Date"; Decimal)
#pragma warning restore AA0232
        {
            Caption = 'Balance at Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au" }, { "lang": "FRB", "txt": "Solde au" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50502; "CIR Net Change"; Decimal)
        {
            Caption = 'Net Change', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde période" }, { "lang": "FRB", "txt": "Solde période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50503; "CIR Balance"; Decimal)
        {
            Caption = 'Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde" }, { "lang": "FRB", "txt": "Solde" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50504; "CIR Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant débit" }, { "lang": "FRB", "txt": "Montant débit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50505; "CIR Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant crédit" }, { "lang": "FRB", "txt": "Montant crédit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Credit Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50506; "CIR Additional Curr Net Change"; Decimal)
        {
            Caption = 'Additional-Currency Net Change', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde période DR" }, { "lang": "FRB", "txt": "Solde période DR" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50507; "CIR Add Curr Balance at Date"; Decimal)
        {
            Caption = 'Add.-Currency Balance at Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au DR" }, { "lang": "FRB", "txt": "Solde au DR" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD(UPPERLIMIT("Date Filter")), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50508; "CIR Additional Curr Balance"; Decimal)
        {
            Caption = 'Additional-Currency Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde DR" }, { "lang": "FRB", "txt": "Solde DR" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50509; "CIR Add Curr Debit Amount"; Decimal)
        {
            Caption = 'Add.-Currency Debit Amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant débit DR" }, { "lang": "FRB", "txt": "Montant débit DR" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Debit Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50510; "CIR Add Curr Credit Amount"; Decimal)
        {
            Caption = 'Add.-Currency Credit Amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant crédit DR" }, { "lang": "FRB", "txt": "Montant crédit DR" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Credit Amount" WHERE("G/L Account No." = FIELD("No."), "G/L Account No." = FIELD(FILTER(Totaling)), "Business Unit Code" = FIELD("Business Unit Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Posting Date" = FIELD("Date Filter"), "CIR Entry Type" = FIELD("CIR G/L Entry Type Filter")));
            Editable = false;
        }
        field(50511; "CIR Balance Definitive at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter"),
                                                        "CIR Entry Type" = const(Definitive)));
            Caption = 'Balance Definitive at Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde Définitif à la date"}]}';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50512; "CIR Balance Situation at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter"),
                                                        "CIR Entry Type" = const(Situation)));
            Caption = 'Balance Situation at Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde Situation à la date"}]}';
            Editable = false;
            FieldClass = FlowField;
        }
        Field(50513; "CIR Definitive Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter"),
                                                        "CIR Entry Type" = const(Definitive)));
            Caption = 'Definitive Net Change', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde période Définitif"}]}';
            Editable = false;
            FieldClass = FlowField;
        }
        Field(50514; "CIR Situation Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter"),
                                                        "CIR Entry Type" = const(Situation)));
            Caption = 'Situation Net Change', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde période Situation"}]}';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}