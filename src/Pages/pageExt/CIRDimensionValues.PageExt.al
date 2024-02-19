pageextension 50043 "CIRDimension Values" extends "Dimension Values"
{
    layout
    {
        addlast(control1)
        {
            field("Payroll Job Attribution"; Rec."Payroll Job Attribution")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payroll Job Attribution', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Projet Imputation Paye"}]}';
            }
            field("SAGE Code"; Rec."SAGE Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SAGE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code SAGE"}]}';
            }
            field(Region; Rec.Region)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Region', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Région"}]}';
            }
        }
    }
}