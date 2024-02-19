/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Gestion des attributs affaire
*/
page 50002 "Business Attributes"
{
    Caption = 'Business Attributes', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Attributs affaire" } ] }';
    PageType = Card;
    SourceTable = "Business Attributes";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code" } ] }';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] }';
                    ApplicationArea = All;
                }
                field("ShorCut Dimension 3 Code"; Rec."ShorCut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                    ApplicationArea = All;
                }
                field("ShorCut Dimension Name"; Rec."ShorCut Dimension Name")
                {
                    ToolTip = 'Specifies the value of the ShorCut Dimension Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom axe analytique" } ] }';
                    ApplicationArea = All;
                }
                field("Manager Code"; Rec."Manager Code")
                {
                    ToolTip = 'Specifies the value of the Manager Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code responsable" } ] }';
                    ApplicationArea = All;
                }
                field(Site; Rec.Site)
                {
                    ToolTip = 'Specifies the value of the Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" } ] }';
                    ApplicationArea = All;
                }
                field("Address Site"; Rec."Address Site")
                {
                    ToolTip = 'Specifies the value of the Address Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse site" } ] }';
                    ApplicationArea = All;
                }
                field("Address Site 2"; Rec."Address Site 2")
                {
                    ToolTip = 'Specifies the value of the Address Site 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse site 2" } ] }';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code postal" } ] }';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ville" } ] }';
                    ApplicationArea = All;
                }
                field("Answer Date"; Rec."Answer Date")
                {
                    ToolTip = 'Specifies the value of the Answer Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date réponse" } ] }';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date dern. modification" } ] }';
                    ApplicationArea = All;
                }
            }
            group(Comments)
            {
                field(Latitude; Rec.Latitude)
                {
                    ToolTip = 'Specifies the value of the Latitude', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Latitude" } ] }';
                    ApplicationArea = All;
                }
                field(Longitude; Rec.Longitude)
                {
                    ToolTip = 'Specifies the value of the Longitude', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Longitude" } ] }';
                    ApplicationArea = All;
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Hauteur" } ] }';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type" } ] }';
                    ApplicationArea = All;
                }
                field(Load; Rec.Load)
                {
                    ToolTip = 'Specifies the value of the Load', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Charge" } ] }';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires" } ] }';
                    ApplicationArea = All;
                }
                field("Comment 2"; Rec."Comment 2")
                {
                    ToolTip = 'Specifies the value of the Comment 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Autres commentaires" } ] }';
                    ApplicationArea = All;
                }
                field("Comment 3"; Rec."Comment 3")
                {
                    ToolTip = 'Specifies the value of the Comment 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires supplémentaires" } ] }';
                    ApplicationArea = All;
                }
                field("Comment 4"; Rec."Comment 4")
                {
                    ToolTip = 'Specifies the value of the Comment 4', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires supplémentaires" } ] }';
                    ApplicationArea = All;
                }
                field(Directory; Rec.Directory)
                {
                    ToolTip = 'Specifies the value of the Directory', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Suivi dossier" } ] }';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Observations" } ] }';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires supplémentaires" } ] }';
                    ApplicationArea = All;
                }
                field("Site 2"; Rec."Site 2")
                {
                    ToolTip = 'Specifies the value of the Site 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 2" } ] }';
                    ApplicationArea = All;
                }
                field("Site 3"; Rec."Site 3")
                {
                    ToolTip = 'Specifies the value of the Site 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 3" } ] }';
                    ApplicationArea = All;
                }
                field("Site 4"; Rec."Site 4")
                {
                    ToolTip = 'Specifies the value of the Site 4', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 4" } ] }';
                    ApplicationArea = All;
                }
                field(Operator; Rec.Operator)
                {
                    ToolTip = 'Specifies the value of the Operator', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur" } ] }';
                    ApplicationArea = All;
                }
                field("Operator 2"; Rec."Operator 2")
                {
                    ToolTip = 'Specifies the value of the Operator 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur 2" } ] }';
                    ApplicationArea = All;
                }
                field("Operator 3"; Rec."Operator 3")
                {
                    ToolTip = 'Specifies the value of the Operator 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur 3" } ] }';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
}