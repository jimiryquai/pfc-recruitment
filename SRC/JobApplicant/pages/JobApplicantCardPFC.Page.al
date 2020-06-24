page 50101 JobApplicantCard_PFC
{
    Caption = 'Job Applicant';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    SourceTable = "JobApplicants_PFC";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        AssistEdit();
                    end;
                }

                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s first name.';
                    Caption = 'First Name';
                }

                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s middle name.';
                    Caption = 'Middle Name';
                }

                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s last name.';
                    Caption = 'Last Name';
                }

                field("Gender"; Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s gender.';
                    Caption = 'Gender';
                }
            }

            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                field("Address"; Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s address.';
                    Caption = 'Address';

                }

                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                    Caption = 'Address 2';

                }

                field("City"; City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the address.';
                    Caption = 'City';
                }

                field("County"; County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the county of the address.';
                    Caption = 'County';
                }

                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postcode.';
                    Caption = 'Postcode';
                }

                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the address.';
                    Caption = 'Country/Region Code';
                }

                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s phone number.';
                    Caption = 'Phone No.';
                }

                field("Mobile No."; "Mobile No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s mobile phone number.';
                    Caption = 'Mobile No.';
                }

                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s email address.';
                    Caption = 'Email';
                }

                field("Send Form"; "Send Form")
                {
                    Caption = 'Send Form';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant`''s email address.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        HandleAddressLookupVisibility();
    end;

    trigger OnOpenPage()
    begin
        SetNoFieldVisible();
        IsCountyVisible := FormatAddress.UseCounty("Country/Region Code");
    end;

    var
        FormatAddress: Codeunit "Format Address";
        NoFieldVisible: Boolean;
        IsCountyVisible: Boolean;
        IsAddressLookupTextEnabled: Boolean;

    local procedure SetNoFieldVisible()
    var
        ApplicantNoVisibility: Codeunit ApplicantNoVisibility_PFC;
    begin
        NoFieldVisible := ApplicantNoVisibility.ApplicantNoIsVisible();
    end;

    local procedure ShowPostcodeLookup(ShowInputFields: Boolean)
    var
        TempEnteredAutocompleteAddress: Record "Autocomplete Address" temporary;
        TempAutocompleteAddress: Record "Autocomplete Address" temporary;
        PostcodeBusinessLogic: Codeunit "Postcode Business Logic";
    begin
        if ("Country/Region Code" <> 'GB') and ("Country/Region Code" <> '') then
            exit;

        if not PostcodeBusinessLogic.IsConfigured() or (("Post Code" = '') and not ShowInputFields) then
            exit;

        TempEnteredAutocompleteAddress.Address := Address;
        TempEnteredAutocompleteAddress.Postcode := "Post Code";

        if not PostcodeBusinessLogic.ShowLookupWindow(TempEnteredAutocompleteAddress, ShowInputFields, TempAutocompleteAddress) then
            exit;

        CopyAutocompleteFields(TempAutocompleteAddress);
        HandleAddressLookupVisibility();
    end;

    local procedure CopyAutocompleteFields(var TempAutocompleteAddress: Record "Autocomplete Address" temporary)
    begin
        Address := TempAutocompleteAddress.Address;
        "Address 2" := TempAutocompleteAddress."Address 2";
        "Post Code" := TempAutocompleteAddress.Postcode;
        City := TempAutocompleteAddress.City;
        County := TempAutocompleteAddress.County;
        "Country/Region Code" := TempAutocompleteAddress."Country / Region";
    end;

    local procedure HandleAddressLookupVisibility()
    var
        PostcodeBusinessLogic: Codeunit "Postcode Business Logic";
    begin
        if not CurrPage.Editable or not PostcodeBusinessLogic.IsConfigured() then
            IsAddressLookupTextEnabled := false
        else
            IsAddressLookupTextEnabled := ("Country/Region Code" = 'GB') or ("Country/Region Code" = '');
    end;
}
