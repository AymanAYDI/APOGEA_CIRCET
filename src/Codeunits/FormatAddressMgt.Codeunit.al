codeunit 50007 "Format Address Mgt."
{
    procedure PaymentAddress(VAR AddrArray: ARRAY[8] OF Text[50]; VAR PayAddr: Record "Payment Address")
    begin
        FormatAddress.FormatAddr(AddrArray,
            PayAddr.Name,
            PayAddr."Name 2",
            PayAddr.Contact,
            PayAddr.Address,
            PayAddr."Address 2",
            PayAddr.City,
            PayAddr."Post Code",
            PayAddr.County,
            PayAddr."Country/Region Code");
    end;

    procedure CustomerExtended(VAR AddrArray: ARRAY[10] OF Text[50]; Cust: Record Customer)
    begin
        FormatAddrExtended(AddrArray,
                   CopyStr(Cust.Name, 1, 90),
                   Cust."Name 2",
                   CopyStr(Cust.Contact, 1, 90),
                   CopyStr(Cust.Address, 1, 50),
                   Cust."Address 2",
                   Cust.City,
                   Cust."Post Code",
                   Cust.County,
                   Cust."Country/Region Code");
    end;

    procedure FormatAddrExtended(VAR AddrArray: ARRAY[10] OF Text[100]; Name: Text[90]; Name2: Text[90]; Contact: Text[90]; Addr: Text[50]; Addr2: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; CountryCode: Code[10]);
    VAR
        Country: Record "Country/Region";
        GLSetup: Record "General Ledger Setup";
        InsertText: Integer;
        Index: Integer;
        NameLineNo: Integer;
        Name2LineNo: Integer;
        AddrLineNo: Integer;
        Addr2LineNo: Integer;
        ContLineNo: Integer;
        PostCodeCityLineNo: Integer;
        CountyLineNo: Integer;
        CountryLineNo: Integer;
        Dummy: Text[50];
    begin
        CLEAR(AddrArray);

        IF CountryCode = '' THEN BEGIN
            GLSetup.GET();
            CLEAR(Country);
            Country."Address Format" := GLSetup."Local Address Format";
            Country."Contact Address Format" := GLSetup."Local Cont. Addr. Format";
        END ELSE
            Country.GET(CountryCode);

        CASE Country."Contact Address Format" OF
            Country."Contact Address Format"::First:
                BEGIN
                    NameLineNo := 2;
                    Name2LineNo := 3;
                    ContLineNo := 1;
                    AddrLineNo := 4;
                    Addr2LineNo := 5;
                    PostCodeCityLineNo := 8;
                    CountyLineNo := 9;
                    CountryLineNo := 10;
                END;
            Country."Contact Address Format"::"After Company Name":
                BEGIN
                    NameLineNo := 1;
                    Name2LineNo := 2;
                    ContLineNo := 3;
                    AddrLineNo := 4;
                    Addr2LineNo := 5;
                    PostCodeCityLineNo := 8;
                    CountyLineNo := 9;
                    CountryLineNo := 10;
                END;
            Country."Contact Address Format"::Last:
                BEGIN
                    NameLineNo := 1;
                    Name2LineNo := 2;
                    ContLineNo := 10;
                    AddrLineNo := 3;
                    Addr2LineNo := 4;
                    PostCodeCityLineNo := 7;
                    CountyLineNo := 8;
                    CountryLineNo := 9;
                END;
        END;

        IF Country."Address Format" = Country."Address Format"::"County/Post Code+City" THEN BEGIN
            CountyLineNo := PostCodeCityLineNo;
            PostCodeCityLineNo := CountyLineNo + 1;
        END;

        AddrArray[NameLineNo] := Name;
        AddrArray[Name2LineNo] := Name2;
        AddrArray[AddrLineNo] := Addr;
        AddrArray[Addr2LineNo] := Addr2;
        CASE Country."Address Format" OF
            Country."Address Format"::"Post Code+City",
              Country."Address Format"::"City+County+Post Code",
              Country."Address Format"::"City+Post Code",
              Country."Address Format"::"Post Code+City/County",
              Country."Address Format"::"County/Post Code+City":
                BEGIN
                    AddrArray[ContLineNo] := Contact;
                    GeneratePostCodeCity(AddrArray[PostCodeCityLineNo], AddrArray[CountyLineNo], City, PostCode, County, Country);
                    AddrArray[CountryLineNo] := Country.Name;
                    COMPRESSARRAY(AddrArray);
                END;
            Country."Address Format"::"Blank Line+Post Code+City":
                BEGIN
                    IF ContLineNo < PostCodeCityLineNo THEN
                        AddrArray[ContLineNo] := Contact;
                    COMPRESSARRAY(AddrArray);

                    Index := 1;
                    InsertText := 1;
                    REPEAT
                        IF AddrArray[Index] = '' THEN BEGIN
                            CASE InsertText OF
                                2:
                                    GeneratePostCodeCity(AddrArray[Index], Dummy, City, PostCode, County, Country);
                                3:
                                    AddrArray[Index] := Country.Name;
                                4:
                                    IF ContLineNo > PostCodeCityLineNo THEN
                                        AddrArray[Index] := Contact;
                            END;
                            InsertText := InsertText + 1;
                        END;
                        Index := Index + 1;
                    UNTIL Index = 11;
                END;
        END;
    end;

    local procedure GeneratePostCodeCity(var PostCodeCityText: Text[100]; var CountyText: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; Country: Record "Country/Region")
    var
        DummyString: Text;
        OverMaxStrLen: Integer;
    begin
        DummyString := '';
        OverMaxStrLen := MaxStrLen(PostCodeCityText);
        if OverMaxStrLen < MaxStrLen(DummyString) then
            OverMaxStrLen += 1;

        case Country."Address Format" of
            Country."Address Format"::"Post Code+City":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := CopyStr(DelStr(PostCode + ' ' + City, OverMaxStrLen), 1, MaxStrLen(PostCodeCityText))
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
            Country."Address Format"::"City+County+Post Code":

                if (County <> '') and (PostCode <> '') then
                    PostCodeCityText :=
                      CopyStr(DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - StrLen(County) - 3) +
                      ', ' + County + ' ' + PostCode, 1, MaxStrLen(PostCodeCityText))
                else
                    if PostCode = '' then begin
                        PostCodeCityText := City;
                        CountyText := County;
                    end else
                        if (County = '') and (PostCode <> '') then
                            PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode;

            Country."Address Format"::"City+Post Code":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
            Country."Address Format"::"Blank Line+Post Code+City":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := CopyStr(DelStr(PostCode + ' ' + City, OverMaxStrLen), 1, MaxStrLen(PostCodeCityText))
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
            Country."Address Format"::"Post Code+City/County", Country."Address Format"::"County/Post Code+City":
                begin
                    if PostCode <> '' then
                        PostCodeCityText := CopyStr(DelStr(PostCode + ' ' + City, OverMaxStrLen), 1, MaxStrLen(PostCodeCityText))
                    else
                        PostCodeCityText := City;
                    CountyText := County;
                end;
        end;
    end;

    procedure FillAdresseAccortingToPaymentLineAccountType(VAR AddrArray: ARRAY[8] OF Text[50]; VAR PaymtLine: Record "Payment Line")
    var
        PaymentAddr: Record "Payment Address";
        Customer: Record Customer;
        Vendor: record Vendor;
        BankAccount: record "Bank Account";
    begin
        CLEAR(AddrArray);
        IF PaymtLine."Payment Address Code" <> '' THEN
            IF PaymentAddr.GET(PaymtLine."Account Type", PaymtLine."Account No.", PaymtLine."Payment Address Code") THEN
                FormatAddress.FormatAddr(AddrArray,
                                        PaymentAddr.Name,
                                        PaymentAddr."Name 2",
                                        '',
                                        PaymentAddr.Address,
                                        PaymentAddr."Address 2",
                                        PaymentAddr.City,
                                        PaymentAddr."Post Code",
                                        PaymentAddr.County,
                                        PaymentAddr."Country/Region Code")
            ELSE
                CASE PaymtLine."Account Type" OF
                    PaymtLine."Account Type"::Customer:
                        if Customer.GET(PaymtLine."Account No.") then
                            FormatAddress.Customer(AddrArray, Customer);
                    PaymtLine."Account Type"::Vendor:
                        if Vendor.GET(PaymtLine."Account No.") then
                            FormatAddress.Vendor(AddrArray, Vendor);
                    PaymtLine."Account Type"::"Bank Account":
                        if BankAccount.GET(PaymtLine."Account No.") then
                            FormatAddress.BankAcc(AddrArray, BankAccount);
                END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeSalesShptShipTo', '', false, false)]
    local procedure OnBeforeSalesShptShipTo(var AddrArray: array[8] of Text[100]; var SalesShipmentHeader: Record "Sales Shipment Header"; var Handled: Boolean);
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.get(SalesHeader."Document Type"::Order, SalesShipmentHeader."Order No.") then
            if SalesHeader."Ship-to Contact" <> '' then begin
                FormatAddress.FormatAddr(
                    AddrArray, SalesShipmentHeader."Ship-to Name", SalesShipmentHeader."Ship-to Name 2", '', SalesShipmentHeader."Ship-to Address", SalesShipmentHeader."Ship-to Address 2",
                    SalesShipmentHeader."Ship-to City", SalesShipmentHeader."Ship-to Post Code", SalesShipmentHeader."Ship-to County", SalesShipmentHeader."Ship-to Country/Region Code");
                Handled := true;
            end;
    end;

    var
        FormatAddress: Codeunit "Format Address";
}