tableextension 50040 "CIR Company Information" extends "Company Information"
{
    fields
    {
        field(50000; "CIR Agency Code"; Text[5])
        {
            Caption = 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
            DataClassification = CustomerContent;
            InitValue = '00000';

            trigger OnValidate()
            begin
                if StrLen("CIR Agency Code") < 5 then
                    "CIR Agency Code" := PadStr('', 5 - StrLen("CIR Agency Code"), '0') + "CIR Agency Code";

            end;
        }
        field(50001; "CIR RIB Key"; Integer)
        {
            Caption = 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
            DataClassification = CustomerContent;
        }
        field(50002; "Manufacturing Mgt."; Boolean)
        {
            Caption = 'Manufacturing Mgt.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Gestion production"}]}';
            DataClassification = CustomerContent;
        }
        field(50003; "Legal Text EML"; Text[1024])
        {
            Caption = 'Legal Text EML', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Texte loi LME"}]}';
            DataClassification = CustomerContent;
        }
        field(50004; "Email Sales Accounting"; Text[50])
        {
            Caption = 'Email Sales Accounting', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"E-mail compta vente"}]}';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(50005; "Reverse Charge Text"; Text[1024])
        {
            Caption = 'Reverse Charge', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Texte Autoliquidation"}]}';
            DataClassification = CustomerContent;
        }
    }

    procedure FooterInformationCompany() rTxt: Text
    var
        lChrLF: Char;
        "%1%2%3_Lbl": Label '%1 %2 %3', Locked = true;
        "%1%2_Lbl": Label '%1 %2', Locked = true;
        Fax_Lbl: Label 'Fax :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fax :"}]}';
        HeadOffice_Lbl: Label 'Head Office', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Siège social"}]}';
        "Hyphen%1%2_Lbl": Label '- %1 %2', Locked = true;
        Phone_Lbl: Label 'Phone :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél :"}]}';
        "SpaceHyphen%1%2_Lbl": Label ' - %1 %2', Locked = true;
        "SpaceHyphen%1_Lbl": Label ' - %1', Locked = true;
        StockCapital_Lbl: Label 'in the capital company of ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"au capital société de "}]}';
        VAT_Lbl: Label 'VAT :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"TVA : "}]}';
        LF: Text;
    begin
        lChrLF := 10;
        LF := FORMAT(lChrLF);

        rTxt += STRSUBSTNO("%1%2_Lbl", HeadOffice_Lbl, Address);
        rTxt += STRSUBSTNO("Hyphen%1%2_Lbl", "Post Code", City);
        rTxt += LF;
        rTxt += STRSUBSTNO("%1%2_Lbl", Phone_Lbl, "Phone No.");
        rTxt += STRSUBSTNO("SpaceHyphen%1%2_Lbl", Fax_Lbl, "Fax No.");
        rTxt += STRSUBSTNO("SpaceHyphen%1_Lbl", "Email Sales Accounting");
        rTxt += STRSUBSTNO("SpaceHyphen%1_Lbl", "Home Page");
        rTxt += LF;
        rTxt += STRSUBSTNO("%1%2%3_Lbl", "Legal Form", StockCapital_Lbl, "Stock Capital");
        rTxt += STRSUBSTNO("SpaceHyphen%1_Lbl", "Trade Register");
        rTxt += STRSUBSTNO("SpaceHyphen%1%2_Lbl", FIELDCAPTION("Registration No."), "Registration No.");
        rTxt += STRSUBSTNO("SpaceHyphen%1%2_Lbl", FIELDCAPTION("APE Code"), "APE Code");
        rTxt += STRSUBSTNO("SpaceHyphen%1%2_Lbl", VAT_Lbl, "VAT Registration No.");
    end;
}