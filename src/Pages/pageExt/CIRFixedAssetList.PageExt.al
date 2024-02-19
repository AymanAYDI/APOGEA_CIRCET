pageextension 50088 "CIR Fixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        addlast(factboxes)
        {
            part(FixedAssetDetailFactbox; "Fixed Asset Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "FA No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addafter("C&opy Fixed Asset")
        {
            action("Import Asset")
            {
                ApplicationArea = All;
                Caption = 'Import Asset', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import immobilisation"}]}';
                Image = Import;
                RunObject = XmlPort "Import Asset";
                ToolTip = 'Executes the Import Asset', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Executer l''import en masse des immobilisations"}]}';
            }
        }
    }
}