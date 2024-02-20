pageextension 50044 "CIR Payment Slip" extends "Payment Slip"
{
    layout
    {
        addlast(General)
        {
            field("Issuer/Recipient"; Rec."Issuer/Recipient")
            {
                ToolTip = 'Specifies the value of the Issuer/Recipient field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifier la valeur du champ Émetteur/Destinataire."}]}';
                ApplicationArea = All;
            }
            field("Intermediary Account No."; Rec."Intermediary Account No.")
            {
                ToolTip = 'Specifies the value of the Intermediary Account No. field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifier la valeur du champ N° Compte Banque Intermediaire"}]}';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(SuggestVendorPayments)
        {
            action(CIRSuggestVendorPayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest &Vendor Payments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Proposer paiements fournisseur"}]}';
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Process open vendor ledger entries (entries that result from posting invoices, finance charge memos, credit memos, and payments) to create a payment suggestion as lines in a payment slip. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Traitez les écritures comptables fournisseur ouvertes (écritures résultant de la validation de factures, de factures d''intérêts, d''avoirs et de paiements) pour créer une suggestion de paiement sous la forme de lignes dans un bordereau paiement."}]}';

                trigger OnAction()
                var
                    PaymentClass: Record "Payment Class";
                    CIRSuggestVendorPaymentsFR: Report "CIR Suggest Vendor Payments FR";
                    NoSuggestedPayment_Msg: Label 'You cannot suggest payments on a posted header.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à faire des propositions de paiement sur un bordereau validé."}]}';
                    PaymentClassDoesntAuthorize_Msg: Label 'This payment class does not authorize vendor suggestions.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce type de règlement n''autorise pas les propositions fournisseur."}]}';
                begin
                    if Rec."Status No." <> 0 then
                        Message(NoSuggestedPayment_Msg)
                    else
                        if PaymentClass.Get(Rec."Payment Class") then
                            if PaymentClass.Suggestions = PaymentClass.Suggestions::Vendor then begin
                                CIRSuggestVendorPaymentsFR.SetGenPayLine(Rec);
                                CIRSuggestVendorPaymentsFR.RunModal();
                                Clear(CIRSuggestVendorPaymentsFR);
                            end else
                                Message(PaymentClassDoesntAuthorize_Msg);
                end;
            }
        }
        modify(SuggestVendorPayments)
        {
            Visible = false;
        }
        modify(Post)
        {
            Visible = false;
        }
        modify(Print)
        {
            Visible = false;
        }

        addafter(Post)
        {
            action("CIR Post")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider"}]}';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Post the payment.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider le paiement."}]}';

                trigger OnAction()
                var
                    PaymentStep: Record "Payment Step";
                    PaymentLine: Record "Payment Line";
                    PaymentMgt: Codeunit "Payment Management";
                begin
                    PaymentLine.SETRANGE("No.", Rec."No.");
                    PaymentLine.MODIFYALL(Selected, true);

                    COMMIT();

                    PaymentStep.SetFilter("Action Type", '%1|%2|%3|%4', PaymentStep."Action Type"::None, PaymentStep."Action Type"::Ledger, PaymentStep."Action Type"::"Cancel File", PaymentStep."Action Type"::"Send By Mail");
                    PaymentMgt.ProcessPaymentSteps(Rec, PaymentStep);

                    PaymentLine.SETRANGE("No.", Rec."No.");
                    PaymentLine.MODIFYALL(Selected, false);
                end;
            }

            action(CIRPrint)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer"}]}';
                Image = Print;
                ToolTip = 'Print the payment slip.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer le bordereau de paiement"}]}';

                trigger OnAction()
                var
                    PaymentStep: Record "Payment Step";
                    PaymentLine: Record "Payment Line";
                    PaymentMgt: Codeunit "Payment Management";
                begin
                    PaymentLine.SETRANGE("No.", Rec."No.");
                    PaymentLine.MODIFYALL(Selected, false);

                    CurrPage.Lines.Page.SetSelectionFilter(PaymentLine);
                    PaymentLine.MarkedOnly(TRUE);
                    IF PaymentLine.FINDSET() then
                        repeat
                            PaymentLine.Selected := true;
                            PaymentLine.Modify();
                        until PaymentLine.NEXT() = 0
                    else begin
                        PaymentLine.MarkedOnly(false);
                        PaymentLine.MODIFYALL(Selected, true);
                    end;

                    Rec."Print" := TRUE;
                    Rec.MODIFY();

                    COMMIT();

                    CurrPage.Lines.PAGE.MarkLines(true);
                    PaymentStep.SetRange("Action Type", PaymentStep."Action Type"::Report);
                    PaymentMgt.ProcessPaymentSteps(Rec, PaymentStep);
                    CurrPage.Lines.PAGE.MarkLines(false);

                    PaymentLine.SETRANGE("No.", Rec."No.");
                    PaymentLine.MODIFYALL(Selected, false);

                    Rec."Print" := FALSE;
                    Rec.MODIFY();
                end;
            }
        }
    }
}