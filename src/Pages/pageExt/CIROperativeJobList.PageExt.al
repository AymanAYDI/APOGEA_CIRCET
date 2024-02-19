pageextension 50035 "CIR Operative Job List" extends ARBVRNOperativeJobList
{

    layout
    {
        addafter("Search Description")
        {
            field(ARBCIRFRJobStatus40909; Rec.ARBCIRFRJobStatus)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Status field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ statut projet"}]}';
            }
            field("Situation Status84633"; Rec."Situation Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Situation Status ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du statut de situation"}]}';
            }
        }
    }

    actions
    {
        addafter("Create Job &Sales Invoice")
        {
            action("Import Situation Inventory")
            {
                Caption = 'Import Situation Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import inventaire situation"}]}';
                ToolTip = 'Allows you to launch the import of Situation Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import inventaire de situation"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction()
                begin
                    Xmlport.RUN(Xmlport::"Import Situation Inventory", false, true);
                end;
            }
            action("Import Production Progress")
            {
                Caption = 'Import Production Progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import de l''avancement de production"}]}';
                ToolTip = 'Allows you to launch the import of production progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import de l''avancement de production"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction()
                begin
                    Xmlport.RUN(Xmlport::"Import Production Progress", false, true);
                end;
            }
        }
    }
}