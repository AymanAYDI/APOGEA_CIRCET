pageextension 50053 "CIR Operative Job Card" extends "ARBVRNOperativeJobCard"
{
    layout
    {
        addafter(General)
        {
            group(Situation)
            {
                Caption = 'Situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Situation"}]}';
                Editable = JobSituationEditable;
                Visible = IsSituationVisible;
                group(WIPGrp)
                {
                    ShowCaption = false;
                    Visible = IsWorksideJob;
                    field("Work In Progress Support"; Rec."Work In Progress Support")
                    {
                        ToolTip = 'Specifies the value of the Work In Progress Support ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Support d''encours"}]}';
                        ApplicationArea = All;
                    }
                    field("Situation Status"; Rec."Situation Status")
                    {
                        ToolTip = 'Specifies the value of the Situation Status ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut situation"}]}';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ShowFields(Rec);
                        end;
                    }
                }
                group(InventoryGrp)
                {
                    ShowCaption = false;
                    Visible = IsProductionJob;
                    field(Inventory; Rec.Inventory)
                    {
                        ToolTip = 'Specifies the value of the Inventory ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Inventaire"}]}';
                        ApplicationArea = All;
                    }
                }
                group(EstimateProductionProgressGrp)
                {
                    ShowCaption = false;
                    Visible = IsEstimateProdProgress;
                    field("Estimate Production Progress"; Rec."Estimate Production Progress")
                    {
                        ToolTip = 'Specifies the value of the Estimate Production Progress ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Estimation avancement prod."}]}';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        addbefore(Action1100227013)
        {
            action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commandes vente"}]}';
                Image = Document;
                Promoted = false;
                RunObject = Page "Sales Order List";
                RunPageLink = ARBVRNJobNo = FIELD("No.");
                RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                ToolTip = 'View a list of ongoing sales orders for the job', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vue des commandes liées au projet"}]}';
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Return Orders', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Retours vente"}]}';
                Image = ReturnOrder;
                Promoted = false;
                RunObject = Page "Sales Return Order List";
                RunPageLink = ARBVRNJobNo = FIELD("No.");
                RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                ToolTip = 'Open the list of ongoing return orders.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vue des retours liés au projet"}]}';
            }
        }
    }

    trigger OnOpenPage()
    begin
        GeneralApplicationSetup.GET();
    end;

    trigger OnAfterGetRecord()
    begin
        ShowFields(Rec);
    end;

    procedure ShowFields(pJob: Record Job)
    var
        JobSituationMgt: Codeunit "Job Situation Mgt.";
    begin
        IsSituationVisible := GeneralApplicationSetup."Evaluation Period Situation";

        //Initialisation des affichages
        IsProductionJob := false;
        IsWorksideJob := false;
        IsEstimateProdProgress := false;
        JobSituationEditable := false;

        //Rend les champs éditables
        JobSituationEditable := JobSituationMgt.GetEditableJobSituation(pJob);

        //Rend les champs visibles
        case pJob.ARBCIRFRJobType of
            pJob.ARBCIRFRJobType::"Production Job":
                begin
                    IsSituationVisible := (GeneralApplicationSetup."Evaluation Period Situation") and (pJob.ARBCIRFRJobStatus in [pJob.ARBCIRFRJobStatus::Active, pJob.ARBCIRFRJobStatus::"In Progress", pJob.ARBCIRFRJobStatus::"PV Recovery"]);
                    IsProductionJob := true;
                end;
            pJob.ARBCIRFRJobType::"Workside Job":
                begin
                    IsWorksideJob := true;
                    if Rec."Situation Status" = Rec."Situation Status"::"In Progress" then
                        IsEstimateProdProgress := true;
                end;
        end;
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        IsProductionJob, IsWorksideJob, IsEstimateProdProgress, JobSituationEditable, IsSituationVisible : Boolean;
}