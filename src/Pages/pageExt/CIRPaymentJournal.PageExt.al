pageextension 50087 "CIR Payment Journal" extends "Payment Journal"
{
    layout
    {
        modify("Check Printed")
        {
            Visible = true;
        }
        moveafter("Payment Method Code"; "Check Printed")
    }
    actions
    {
        addafter(SuggestEmployeePayments)
        {
            action("CIR Suggest Employee Payments")
            {
                ApplicationArea = BasicHR;
                Caption = 'Suggest Employee Payments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Proposer paiements aux salariés"}]}';
                Ellipsis = true;
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Create payment suggestions as lines in the payment journal.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Créez des propositions de paiement en tant que lignes dans la feuille paiement."}]}';

                trigger OnAction()
                var
                    CIRSuggestEmployeePayments: Report "CIR Suggest Employee Payments";
                begin
                    Clear(CIRSuggestEmployeePayments);
                    CIRSuggestEmployeePayments.SetGenJnlLine(Rec);
                    CIRSuggestEmployeePayments.RunModal();
                end;
            }
        }
        modify(SuggestEmployeePayments)
        {
            visible = false;
        }
        addlast(processing)
        {
            action(Replace)
            {
                Caption = 'Replace', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remplacer"}]}';
                ToolTip = 'Replace the date of selected lines.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remplacer la date des lignes sélectionnées."}]}';
                ApplicationArea = All;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    CallReplacePage();
                end;
            }
        }
    }

    local procedure CallReplacePage()
    var
        GenJournalLine: Record "Gen. Journal Line";
        ReplaceMgt: Codeunit "Replace Mgt";
        RecRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(GenJournalLine);
        RecRef.GETTABLE(GenJournalLine);
        ReplaceMgt.FindAndReplace(RecRef, Rec.FIELDNO("Posting Date"));
    end;
}