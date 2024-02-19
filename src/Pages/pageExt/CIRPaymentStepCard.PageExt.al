pageextension 50082 "CIR Payment Step Card" extends "Payment Step Card"
{
    layout
    {
        addafter("Action Type")
        {
            group("Mail Info")
            {
                ShowCaption = false;
                Visible = (rec."Action Type" = rec."Action Type"::"Send By Mail");

                field("PDF File Name"; rec."PDF File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PDF File Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom fichier PDF"}]}';
                }
                field("Sender Email Address"; rec."Sender Email Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sender Email Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse expéditeur e-mail"}]}';
                }
                field("Mail Subject Text Code"; rec."Mail Subject Text Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email Subject Text Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code texte sujet e-mail"}]}';
                }
            }
        }
    }
}