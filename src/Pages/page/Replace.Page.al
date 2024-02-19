page 50012 "Replace"
{
    Caption = 'Replace', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remplacer"}]}';
    PageType = StandardDialog;
    SaveValues = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            field("Table"; TableCaption())
            {
                Caption = 'Table', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Table"}]}';
                ToolTip = 'Specifies the value of the Table', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Table"}]}';
                ApplicationArea = All;
                Width = 250;
            }
            field(Filters; TableFilters())
            {
                Caption = 'Filters', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtres"}]}';
                ToolTip = 'Specifies the value of the Filters', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtres"}]}';
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Count"; IntGCount)
            {
                Caption = 'Number of lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de lignes"}]}';
                ToolTip = 'Specifies the value of the Number of lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de lignes"}]}';
                ApplicationArea = All;
                Editable = false;
                Style = Unfavorable;
                StyleExpr = true;
            }
            field(FieldCptn; FieldCaption(false))
            {
                Caption = 'Field Caption', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du champ"}]}';
                ToolTip = 'Specifies the value of the Field Caption', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du champ"}]}';
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;

                trigger OnAssistEdit()
                begin
                    FieldCaption(true);
                end;
            }
            field(TxtGValue; TxtGValue)
            {
                Caption = 'New Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ToolTip = 'Specifies the value of the New Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = BooGText;
            }
            field(CodeGValue; CodeGValue)
            {
                Caption = 'Code New Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau code"}]}';
                ToolTip = 'Specifies the value of the Code New value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau code"}]}';
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = BooGCode;
            }
            field(DateGValue; DateGValue)
            {
                Caption = 'New Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle date"}]}';
                ToolTip = 'Specifies the value of the New Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle date"}]}';
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = BooGDate;
            }
            field(DecGValue; DecGValue)
            {
                Caption = 'New value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ToolTip = 'Specifies the value of the New Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ApplicationArea = All;
                DecimalPlaces = 0 : 15;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = BooGDec;
            }
            field(EnumGValue; EnumGValue)
            {
                Caption = 'New value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ToolTip = 'Specifies the value of the New Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouvelle valeur"}]}';
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = BooGEnum;
            }
            field("Existing Values"; ExistingValues())
            {
                Caption = 'Existing values', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeurs existantes"}]}';
                ToolTip = 'Specifies the value of the Existing values', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeurs existantes"}]}';
                ApplicationArea = All;
                MultiLine = true;
                Style = StandardAccent;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Apply)
            {
                Caption = 'Apply', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Appliquer"}]}';
                ToolTip = 'Apply', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Appliquer"}]}';
                ApplicationArea = All;
                Image = Apply;

                trigger OnAction()
                begin
                    ReplaceValues();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        BooGAgain := false;
        OnOpen();
        Update();
    end;


    procedure Set(var RefV: RecordRef; IntPFieldNo: Integer)
    begin
        RefG := RefV.Duplicate();
        if RecGField.Get(RefG.Number, IntPFieldNo) then;
    end;

    local procedure OnOpen()
    begin
        IntGCount := RefG.Count();
        RecGField.SetRange(TableNo, RefG.Number);
        RecGField.SetRange(Class, RecGField.Class::Normal);
        RecGField.SetFilter(Type, '%1|%2|%3|%4|%4|%6|%7',
          RecGField.Type::BigInteger,
          RecGField.Type::Code,
          RecGField.Type::Date,
          RecGField.Type::Decimal,
          RecGField.Type::Integer,
          RecGField.Type::Text,
          RecGField.Type::Option);
        if not RecGField.Find() then
            RecGField.FindSet();
    end;


    procedure ReplaceValues()
    var
        TxcLConfirmLbl: Label 'Confirm %1 %2 %3 %4 ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Confirmer %1 %2 %3 %4 ?"}]}';
    begin
        if not Confirm(TxcLConfirmLbl, false, TableCaption(), TableFilters(), IntGCount, RecGField."Field Caption", FormatedValue()) then
            exit;

        if RefG.FindSet() then
            repeat
                FlrG := RefG.Field(RecGField."No.");
                if Format(FlrG) <> Format(CodeGValue) then begin
                    case true of
                        IsCode():
                            FlrG.Validate(CodeGValue);
                        IsDate():
                            FlrG.Validate(DateGValue);
                        IsDec():
                            FlrG.Validate(DecGValue);
                        IsText():
                            FlrG.Validate(TxtGValue);
                        IsEnum():
                            FlrG.Validate(EnumGValue);
                        else
                            RecGField.FieldError(Type);
                    end;
                    RefG.Modify(true);
                end;
            until RefG.Next() = 0;
    end;

    local procedure ExistingValues() rTxt: Text
    var
        N, R : Integer;
    begin
        if RefG.FindSet(false, false) then begin
            N := 1;
            repeat
                R += 1;
                if rTxt = '' then
                    rTxt := FieldValue()
                else
                    if StrPos('|' + rTxt + '|', '|' + FieldValue() + '|') = 0 then begin
                        N += 1;
                        rTxt := rTxt + '|' + FieldValue();
                    end;
                if (R > 1000) or (N > 10) or (StrLen(rTxt) > 250) then
                    exit;
            until RefG.Next() = 0;
        end;
    end;

    local procedure FieldValue() TxtR: Text
    begin
        FlrG := RefG.Field(RecGField."No.");
        TxtR := Format(FlrG);
        if TxtR = '' then
            TxtR := '''''';
    end;

    local procedure TableCaption(): Text
    var
        StringTextLbl: Label '%1 [%2]%3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 [%2]%3"}]}';
    begin
        exit(
         StrSubstNo(
          StringTextLbl,
          RefG.Caption(),
          RefG.Number(),
          RefG.Name()));
    end;

    local procedure FieldCaption(pBooLookup: Boolean): Text
    var
        PagLFieldsLookup: Page "Fields Lookup";
        IntLType: Integer;
    begin
        if not pBooLookup then
            exit(RecGField."Field Caption");

        IntLType := RecGField.Type;
        PagLFieldsLookup.SetTableView(RecGField);
        PagLFieldsLookup.SetRecord(RecGField);
        PagLFieldsLookup.LookupMode(true);
        if PagLFieldsLookup.RunModal() = Action::LookupOK then begin
            PagLFieldsLookup.GetRecord(RecGField);
            if RecGField.Type <> IntLType then
                Refresh();
        end;
    end;

    local procedure TableFilters() rTxt: Text
    var
        I: Integer;
    begin
        for I := 9 downto 0 do begin
            RefG.FilterGroup(I);
            if RefG.GetFilters <> '' then
                if StrPos(rTxt, '[ ' + RefG.GetFilters + ' ] ') = 0 then
                    rTxt := rTxt + '[ ' + RefG.GetFilters + ' ] ';
        end;
    end;

    local procedure Update()
    begin
        FlrG := RefG.Field(RecGField."No.");
        BooGCode := IsCode();
        BooGText := IsText();
        BooGDate := IsDate();
        BooGDec := IsDec();
        BooGEnum := IsEnum();
    end;

    local procedure Refresh()
    begin
        BooGAgain := true;
        CurrPage.Close();
    end;


    procedure Again(): Boolean
    begin
        exit(BooGAgain);
    end;


    procedure CurrFieldNo(): Integer
    begin
        exit(RecGField."No.");
    end;

    local procedure IsCode(): Boolean
    begin
        exit(
          Format(FlrG.Type) in
          [Format(RecGField.Type::Code)]);
    end;

    local procedure IsDec(): Boolean
    begin
        exit(
          Format(FlrG.Type) in
          [Format(RecGField.Type::Decimal),
           Format(RecGField.Type::Integer),
           Format(RecGField.Type::BigInteger)]);
    end;

    local procedure IsDate(): Boolean
    begin
        exit(
          Format(FlrG.Type) in
          [Format(RecGField.Type::Date)]);
    end;

    local procedure IsEnum(): Boolean
    begin
        exit(
          Format(FlrG.Type) in
          [Format(RecGField.Type::Option)]);
    end;

    local procedure IsText(): Boolean
    begin
        exit(not (IsCode() or IsDec() or IsDate() or IsEnum()));
    end;

    local procedure FormatedValue(): Text
    begin
        case true of
            IsCode():
                exit(Format(CodeGValue));
            IsDate():
                exit(Format(DateGValue));
            IsDec():
                exit(Format(DecGValue));
            IsEnum():
                exit(Format(EnumGValue));
            IsText():
                exit(Format(TxtGValue));
        end;
    end;

    var
        RecGField: Record Field;
        RefG: RecordRef;
        FlrG: FieldRef;
        TxtGValue: Text;
        CodeGValue: Code[250];
        DateGValue: Date;
        EnumGValue: Enum "Gen. Journal Account Type";
        DecGValue: Decimal;
        BooGAgain, BooGCode, BooGText, BooGDate, BooGDec, BooGEnum : Boolean;
        IntGCount: Integer;
}