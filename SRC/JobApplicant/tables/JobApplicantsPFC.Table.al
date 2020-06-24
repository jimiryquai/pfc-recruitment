table 50100 JobApplicants_PFC
{
    Caption = 'Job Aplicants';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DrillDownPageID = "JobApplicantsList_PFC";
    LookupPageID = "JobApplicantsList_PFC";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ApplicantResSetup.Get();
                    NoSeriesMgt.TestManual(ApplicantResSetup."Applicant Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }

        field(50122; "Gender"; enum Gender_PFC)
        {
            Caption = 'Gender';
        }

        field(6; "Address"; Text[100])
        {
            Caption = 'Address';
        }

        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }

        field(8; "City"; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }

        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }

        field(10; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }

        field(11; County; Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }

        field(12; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }

        field(13; "Mobile No."; Text[30])
        {
            Caption = 'Mobile No.';
            ExtendedDatatype = PhoneNo;
        }

        field(14; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }

        field(15; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = CustomerContent;
        }

        field(16; "Send Form"; Boolean)
        {
            Caption = 'Send Form';
            DataClassification = CustomerContent;
        }
        field(17; Image; Media)
        {
            Caption = 'Image';
            ExtendedDatatype = Person;
        }

        field(18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Last Name", "First Name", "Middle Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name")
        {
        }
        fieldgroup(Brick; "Last Name", "First Name", Image)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ApplicantResSetup.TestField("Applicant Nos.");
            NoSeriesMgt.InitSeries(ApplicantResSetup."Applicant Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        ApplicantResSetup: Record "JobApplicantSetup_PFC";
        PostCode: Record "Post Code";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(): Boolean
    begin
        ApplicantResSetup.Get();
        ApplicantResSetup.TestField("Applicant Nos.");
        if NoSeriesMgt.SelectSeries(ApplicantResSetup."Applicant Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;
}
