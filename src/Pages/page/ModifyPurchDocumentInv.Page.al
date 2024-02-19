page 50023 "Modify Purch. Document Inv."
{
    Caption = 'Modify Purch. Document Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifier le document enregistrée"}]}';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture fournisseur" }]}';
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the vendor invoice no. that is entered on the sales header that this line was posted from.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N° facture fournisseur"}]}';
                }
            }
        }
    }

    internal procedure SetData(pVendorInvoiceNo: Code[35])
    begin
        "Vendor Invoice No." := pVendorInvoiceNo;
    end;

    internal procedure GetData(): Code[35]
    begin
        EXIT("Vendor Invoice No.");
    end;

    var
        "Vendor Invoice No.": Code[35];
}