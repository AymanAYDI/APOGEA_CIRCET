tableextension 50029 "CIR Dimension Value" extends "Dimension Value"
{
    fields
    {
        field(50000; "Payroll Job Attribution"; Code[20])
        {
            Caption = 'Payroll Job Attribution', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Projet Imputation Paye"}]}';
            TableRelation = Job."No." WHERE(ARBCIRFRJobStatus = const(Active));
            DataClassification = CustomerContent;
            Description = 'Sage Paie / Import écriture';
        }
        field(50001; "SAGE Code"; Code[20])
        {
            Caption = 'SAGE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code SAGE"}]}';
            DataClassification = CustomerContent;
            Description = 'Sage Paie';
        }
        field(50002; Region; Code[20])
        {
            Caption = 'Region', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Region"}]}';
            DataClassification = CustomerContent;
            Description = 'Region';
            TableRelation = "Activity Agency Region".Name WHERE(Type = CONST(Region));
        }
    }
}