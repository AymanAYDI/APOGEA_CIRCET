page 50003 "General Application Setup"
{
    AdditionalSearchTerms = 'CIRCET setup,Paramètres CIRCET';
    ApplicationArea = All;
    Caption = 'General Application Setup', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramètres général application" } ] }';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "General Application Setup";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Purchase)
            {
                Caption = 'Purchase', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Achat"}]}';
                field("Default ShorCut Dim. 3 Code"; Rec."Default ShorCut Dim. 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Shortcut Dim. 3 Code for item check with default shortcut', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3 affecté automatiquement sur la commande d''achat lorsque l''article est paramétré pour." } ] }';
                }
                field("Control Over Company"; Rec."Control Over Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Over Company ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Autoriser le flux achat sans N° de projet"}]}';
                }
                field("Init. Item Direct Unit Cost"; Rec."Init. Item Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Initialized Item Direct Unit Cost', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Affecte un coût unitaire direct à 0 sur document achat"}]}';
                }
            }
            group(Import)
            {
                Caption = 'Import', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import"}]}';
                field("Payroll Job No."; Rec."Payroll Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Job No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur du N° projet paie" } ] }';
                }
            }
            group(Item)
            {
                Caption = 'Item', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Article"}]}';
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category Code.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code catégorie article"}]}';
                }
            }
            group(Location)
            {
                Caption = 'Location', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Magasin"}]}';
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code magasin"}]}';
                }
            }
            group(Dimension)
            {
                Caption = 'Dimension', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Axe analytique"}]}';
                field("Dimension Code"; Rec."Business Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Business Dimension Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code axe affaire"}]}';
                }
            }
            group(Sales)
            {
                Caption = 'Sales', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ventes"}]}';
                field("Attachm. Posted Sales Invoice"; Rec."Attach. Posted Sales Inv. Open")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment Posted Sales Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PJ Doc Vente Enregistrés" } ] } ';
                }
                field("Attachm. Posted Sales Invoice Add"; Rec."Attach. Posted Sales Inv. Save")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment Posted Sales Invoice Address Save', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse sauvegarde PJ Doc Vente Enregistrés" } ] }';
                }
                field("Use Job Descr. as Item Descr."; Rec."Use Job Descr. as Item Descr.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Use job description as item description.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Utiliser désignation projet comme description article."}]}';
                }
                field("Pre-relaunch Period"; Rec."Pre-relaunch Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pre-relaunch Period', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Delai Pre-Relance"}]}';
                }
                field("Blocked Custo. Sales Order"; Rec."Blocked Custo. Sales Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'When checked parameter blocks the modification of the sell-to customer no. on sales orders', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Si activé, bloque la modification du N° de donneur d''ordre sur les commandes de vente"}]}';
                }
                field("Gen. Bus. Posting Group RC"; Rec."Gen. Bus. Posting Group RC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group For Reverse Charge Field field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. marché pour autoliquidation"}]}';
                }
            }
            group(Contact)
            {
                Caption = 'Contact', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contact"}]}';
                field("Mail Notice Of Transfer"; Rec."Mail Notice Of Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mail Notice Of Transfer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mail avis de virement"}]}';
                }
            }
            group(ETEBAC)
            {
                Caption = 'ETEBAC', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ETEBAC"}]}';
                field("ETEBAC Internat. Directory"; Rec."ETEBAC Internat. Directory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETEBAC Directory field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifier le répertoire ETEBAC"}]}';
                }
                field("Operation code"; Rec."Operation code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Operation code field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifier le code opération"}]}';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Situation Inventory")
            {
                ApplicationArea = All;
                Caption = 'Import Situation Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import inventaire situation"}]}';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Allows you to launch the import of Situation Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import inventaire de situation"}]}';

                trigger OnAction()
                begin
                    Xmlport.RUN(Xmlport::"Import Situation Inventory", false, true);
                end;
            }
            action("Import Production Progress")
            {
                ApplicationArea = All;
                Caption = 'Import Production Progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import de l''avancement de production"}]}';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Allows you to launch the import of production progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import de l''avancement de production"}]}';

                trigger OnAction()
                begin
                    Xmlport.RUN(Xmlport::"Import Production Progress", false, true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}