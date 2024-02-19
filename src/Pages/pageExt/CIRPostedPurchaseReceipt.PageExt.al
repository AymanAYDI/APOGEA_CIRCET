pageextension 50095 "CIRPosted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Vendor Order No.")
        {
            field("Description Order"; "Description Order")
            {
                ApplicationArea = ALL;
                Editable = false;
                ToolTip = 'Specifies the value of the Description Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation commande achat"}]}';
            }
        }
    }
}