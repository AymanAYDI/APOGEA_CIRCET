pageextension 50055 "CIR Assembly Order" extends "Assembly Order"
{
    layout
    {
        addafter(Description)
        {
            field("Assembly to Order No."; Rec."Assembly to Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° commande"}]}';
                Editable = false;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
                Editable = false;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ToolTip = 'Specifies the value of the Your Reference field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ Votre référence"}]}';
                ApplicationArea = All;
            }
            field("Site Code"; Rec."Site Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Site Code field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ code site"}]}';
            }
        }
        addfirst(Posting)
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code destinataire"}]}';
            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire"}]}';
            }
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Name 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire 2"}]}';
            }
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Address 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire 2"}]}';
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to City', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ville destinataire"}]}';
            }
            field("Number of packages"; Rec."Number of packages")
            {
                ApplicationArea = All;
                ToolTip = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
            }
            field("Business"; Rec."Business")
            {
                ApplicationArea = All;
                ToolTip = 'Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
                Editable = false;
            }
            field("Business name"; Rec."Business name")
            {
                ApplicationArea = All;
                ToolTip = 'Business name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
                Editable = false;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Post Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code postal destinataire"}]}';
            }
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
                ToolTip = 'Shipping Agent Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code transporteur"}]}';
                TableRelation = "Shipping Agent";
            }
            field("Comment 1"; Rec."Comment 1")
            {
                ApplicationArea = All;
                ToolTip = 'Comment 1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 1"}]}';
            }
            field("Comment 2"; Rec."Comment 2")
            {
                ApplicationArea = All;
                ToolTip = 'Comment 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 2"}]}';
            }
        }

        addBefore("Bin Code")
        {
            group(Bin)
            {
                Caption = 'Bin', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Emplacement"}]}';
                field("Change Bin Code"; Rec."Change Bin Code")
                {
                    ToolTip = 'Specifies the value of the Change Bin Code field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Changer le code d''emplacement"}]}';
                    ApplicationArea = All;
                }
                field("New Bin Code"; Rec."New Bin Code")
                {
                    ToolTip = 'Specifies the value of the New Bin Code field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau code d''emplacement"}]}';
                    ApplicationArea = All;
                    Editable = Rec."Change Bin Code";
                }
            }
        }

        addlast(Posting)
        {
            Group(Weight)
            {
                Caption = 'Weight management', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Gestion du poids"}]}';
                field(ChangeTotalWeight; Rec.ChangeTotalWeight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Check the box to change the total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cocher la case pour changer le poids total"}]}';
                }
                field("Total weight"; Rec."Total weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
                    Editable = Rec.ChangeTotalWeight;
                }
            }
        }
        modify("Starting Date")
        {
            Caption = 'Starting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de départ"}]}';
        }
    }
    actions
    {
        addafter("Refresh Lines")
        {
            action(RefrTotalWeight)
            {
                ApplicationArea = All;
                Caption = 'Refresh assembly order totals', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rafraîchir les totaux de l''ordre d''assemblage"}]}';
                Image = Refresh;
                Promoted = true;
                ToolTip = 'Refresh assembly order totals from assembly lines.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rafraîchir les totaux de l''ordre d''assemblage à partir des lignes."}]}';
                trigger OnAction()
                begin
                    AssemblyMgt.RefreshUnitAndAmountCostLines(Rec);
                    AssemblyMgt.RefreshTotalFieldsAssembly(Rec);
                    CurrPage.Update();
                end;
            }
        }
        addlast(Print)
        {
            action("PreparationOrder")
            {
                ApplicationArea = Assembly;
                Caption = 'Preparation order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ordre de préparation"}]}';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'Print the preparation order.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer l''ordre de préparation"}]}';

                trigger OnAction()
                var
                    AssemblyHdr: Record "Assembly Header";
                    CIRPreparationOrder: Report "CIR Preparation Order";
                begin
                    AssemblyHdr.Reset();
                    AssemblyHdr.SetFilter("No.", Rec."No.");
                    CIRPreparationOrder.SetTableView(AssemblyHdr);
                    CIRPreparationOrder.RunModal();
                end;
            }
            action("assemblyOrderLabel")
            {
                ApplicationArea = Assembly;
                Caption = 'Print assembly order label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer l''étiquette d''ordre d''assemblage"}]}';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'Print assembly order label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer l''étiquette d''ordre d''assemblage"}]}';

                trigger OnAction()
                var
                    AssemblyHdr: Record "Assembly Header";
                    AssemblyOrderLabels: Report "CIR Assembly Order Labels";
                begin
                    AssemblyHdr.SetFilter("No.", Rec."No.");
                    AssemblyOrderLabels.SetTableView(AssemblyHdr);
                    AssemblyOrderLabels.RunModal();
                end;
            }
        }
        addlast("F&unctions")
        {
            action("ExplodeBOM")
            {
                ApplicationArea = Assembly;
                Caption = 'Explode BOM', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Eclater nomenclature"}]}';
                Ellipsis = true;
                Image = Process;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'Explode BOM', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Eclater nomenclature"}]}';

                trigger OnAction()
                var
                    AssemblyMgt: Codeunit "Assembly Mgt.";
                begin
                    AssemblyMgt.ExplodeBOM(Rec);
                    CurrPage.Update();
                end;
            }
            action("ChangeBinCode")
            {
                ApplicationArea = All;
                Caption = 'Change bin code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Changer le code emplacement"}]}';
                ToolTip = 'Update of all assembly order lines, associated sales lines and also pick lines if already created', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mise à jours de l’ensembles des lignes de ordre d''assemblage, des lignes de ventes associés et les également les ligne de prélèvement si déjà créés."}]}';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Process;
                trigger OnAction()
                var
                    AssemblyMgt: Codeunit "Assembly Mgt.";
                begin
                    if (CanChangeBinCode) and (Rec."Change Bin Code") and (Rec."New Bin Code" <> '') then
                        AssemblyMgt.ChangeBinCode(Rec);
                end;
            }
        }

        addafter("Refresh availability warnings")
        {
            action("CIR Refresh availability warnings")
            {
                ApplicationArea = Assembly;
                Caption = 'Refresh Availability', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Actualiser la disponibilité"}]}';
                Image = RefreshLines;
                ToolTip = 'Check items availability and refresh warnings', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vérifier la disponibilité des articles et actualiser les avertissements"}]}';

                trigger OnAction()
                var
                    AssemblyMgt: Codeunit "Assembly Mgt.";
                begin
                    AssemblyMgt.UpdateWarningOnLines(Rec);
                end;
            }
        }
        modify("Refresh availability warnings")
        {
            visible = false;
        }

        modify(Dimensions)
        {
            trigger OnAfterAction()
            var
                GeneralApplicationSetup: Record "General Application Setup";
                DimensionSetEntry: Record "Dimension Set Entry";
            begin
                if xRec."Dimension Set ID" <> Rec."Dimension Set ID" then begin
                    if GeneralApplicationSetup.Get() then;
                    if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralApplicationSetup."Business Dimension Code") then begin
                        Rec.Business := DimensionSetEntry."Dimension Value Code";
                        DimensionSetEntry.CalcFields("Dimension Value Name");
                        Rec."Business name" := DimensionSetEntry."Dimension Value Name";
                    end;
                end;
            end;
        }
    }
    trigger OnOpenPage()
    var
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        if WarehouseEmployee.Get(userID, Rec."Location Code") then
            CanChangeBinCode := true;
    end;

    trigger OnAfterGetRecord()
    begin
        AssemblyMgt.RefreshTotalFieldsAssembly(Rec);
    end;

    var
        AssemblyMgt: codeUnit "Assembly Mgt.";
        CanChangeBinCode: Boolean;
}