tableextension 50016 "CIR Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "Control Station Ref."; Integer)
        {
            Caption = 'Control Station Ref.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Réf. poste de commande" }, { "lang": "FRB", "txt": "Réf. poste de commande" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50001; "NAV Assembly Order No."; Code[20])
        {
            Caption = 'NAV Assembly Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Ordre Assemblage NAV"}]}';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                AssemblyMgt: codeUnit "Assembly Mgt.";
            begin
                AssemblyMgt.ChangeNoAssemblyOrder(Rec);
            end;
        }
        modify("Job No.")
        {
            trigger OnAfterValidate();
            begin
                JobMgt.ControlStatusOnSalesLineDocument(Rec);
                SalesMgt.CheckBillToCustomerNoOnJobNo(Rec);
            end;
        }
        modify(ARBVRNVeronaJobNo)
        {
            trigger OnAfterValidate();
            begin
                JobMgt.ControlStatusOnSalesLineDocument(Rec);
                SalesMgt.CheckBillToCustomerNoOnJobNo(Rec);
            end;
        }
    }

    var
        JobMgt: Codeunit "Job Mgt.";
        SalesMgt: Codeunit "Sales Mgt.";

}