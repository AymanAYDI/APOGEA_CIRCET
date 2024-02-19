pageextension 50066 "CIR Purchase Invoices" extends "Purchase Invoices"
{
    actions
    {
        addlast(navigation)
        {
            action(ImportPurchaseInvoiceLine)
            {
                Caption = 'Import Purchase invoice Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import des lignes de facture achat"}]}';
                ToolTip = 'Allows you to launch the import of purchase invoices lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import des lignes de facture d''achat"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = xmlport "Import Purchase Line";
                Image = Import;
            }
        }
    }
}