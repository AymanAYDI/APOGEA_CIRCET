/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Ajout de l'axe analytique 3 en affichage
*/
pageextension 50026 "CIR Released Production Orders" extends "Released Production Orders"
{
    layout
    {
        addafter("Description")
        {
            field("Dimension Value"; Rec."Dimension Value")
            {
                ToolTip = 'Specifies the value of the Dimension Value ';
                ApplicationArea = All;
            }
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ToolTip = 'Specifies the value of the Dimension Value Name ';
                ApplicationArea = All;
            }
        }
        addAfter(Status)
        {
            field("No. Printed"; Rec."Print count")
            {
                ToolTip = 'Specifies the value of the Print count field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ Nombre impression."}]}';
                ApplicationArea = All;
            }
        }
    }
}