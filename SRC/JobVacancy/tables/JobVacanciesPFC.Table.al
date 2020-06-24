table 50103 JobVacancies_PFC
{
    DataClassification = CustomerContent;

    fields
    {

        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    VacancyResSetup.Get();
                    NoSeriesMgt.TestManual(VacancyResSetup."Vacancy Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Application Open Date"; Date)
        {
            Caption = 'Application Open Date';
            DataClassification = CustomerContent;
        }
        field(3; "Application Close Date"; Date)
        {
            Caption = 'Application Close Date';
            DataClassification = CustomerContent;
        }
        field(4; "Job Title"; Text[80])
        {
            Caption = 'Job Title';
            DataClassification = CustomerContent;
        }
        field(5; "Job Description"; Text[250])
        {
            Caption = 'Job Description';
            DataClassification = CustomerContent;
        }
        field(6; "Travel Required"; Boolean)
        {
            Caption = 'Travel Required';
            DataClassification = CustomerContent;
        }
        field(7; "Salary From"; Decimal)
        {
            Caption = 'Salary From';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(8; "Salary To"; Decimal)
        {
            Caption = 'Salary To';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(9; "Salary Per"; Option)
        {
            Caption = 'Salary Per';
            DataClassification = CustomerContent;
            OptionMembers = "Hour ","Week ","Month","Annum";
            OptionCaption = 'Hour, Week, Month, Annum';
        }
        field(10; "OTE Amount"; Decimal)
        {
            Caption = 'OTE Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(11; "Salary Description"; Text[100])
        {
            Caption = 'Salary Description';
            DataClassification = CustomerContent;
        }
        field(12; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            DataClassification = CustomerContent;
            OptionMembers = "","Permanent ","Temp to Perm","Temporary","Contract","Volunteer","Internship/Apprenticeship","Zero Hours";
            OptionCaption = ' ,Permanent, Temp to Perm, Temporary, Contract, Volunteer, Internship/Apprenticeship, Zero Hours';
        }
        field(13; "Contract Duration"; Integer)
        {
            Caption = 'Contract Duration';
            DataClassification = ToBeClassified;
        }
        field(14; "Period Units"; Option)
        {
            Caption = 'Period Units';
            DataClassification = CustomerContent;
            OptionMembers = "Weeks","Months","Years";
            OptionCaption = 'Weeks, Months, Years';
        }
        field(15; "Min. Hours"; Integer)
        {
            Caption = 'Min. Hours';
            DataClassification = ToBeClassified;
        }
        field(16; "Max. Hours"; Integer)
        {
            Caption = 'Max. Hours';
            DataClassification = ToBeClassified;
        }
        field(17; "Hours Per"; Option)
        {
            Caption = 'Hours Per';
            DataClassification = CustomerContent;
            OptionMembers = "Week","Day";
            OptionCaption = 'Week, Day';
        }
        field(18; "Contracted Hours"; Option)
        {
            Caption = 'Contracted Hours';
            DataClassification = CustomerContent;
            OptionMembers = "","Full-Time","Part-Time","Flexi-Time";
            OptionCaption = ' , Full-Time, Part-Time, Flexi-Time';
        }
        field(19; "Hours Description"; Text[100])
        {
            Caption = 'Hours Description';
            DataClassification = CustomerContent;
        }
        field(20; "Monday"; Boolean)
        {
            Caption = 'Monday';
            DataClassification = CustomerContent;
        }
        field(21; "Tuesday"; Boolean)
        {
            Caption = 'Tuesday';
            DataClassification = CustomerContent;
        }
        field(22; "Wednesday"; Boolean)
        {
            Caption = 'Monday';
            DataClassification = CustomerContent;
        }
        field(23; "Thursday"; Boolean)
        {
            Caption = 'Thursday';
            DataClassification = CustomerContent;
        }
        field(24; "Friday"; Boolean)
        {
            Caption = 'Friday';
            DataClassification = CustomerContent;
        }
        field(25; "Saturday"; Boolean)
        {
            Caption = 'Saturday';
            DataClassification = CustomerContent;
        }
        field(26; "Sunday"; Boolean)
        {
            Caption = 'Sunday';
            DataClassification = CustomerContent;
        }
        field(27; "Start ASAP"; Boolean)
        {
            Caption = 'Start ASAP';
            DataClassification = CustomerContent;
        }
        field(28; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(29; "Finish Date"; Date)
        {
            Caption = 'Finish Date';
            DataClassification = CustomerContent;
        }
        field(30; "Location"; Option)
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            OptionMembers = "","Crawley","Cheadle(Cheshire)","Horley","Chipstead","Prinsted","Multiple Sites","West Norwood";
            OptionCaption = ' , Crawley, Cheadle(Cheshire), Horley, Chipstead, Prinsted, Multiple Sites, West Norwood';
        }
        field(31; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(32; Status; Enum VacancyStatus_PFC)
        {
            Caption = 'Status';
            Editable = false;
        }
        
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            VacancyResSetup.TestField("Vacancy Nos.");
            NoSeriesMgt.InitSeries(VacancyResSetup."Vacancy Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        VacancyResSetup: Record "JobVacancySetup_PFC";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(): Boolean
    begin
        VacancyResSetup.Get();
        VacancyResSetup.TestField("Vacancy Nos.");
        if NoSeriesMgt.SelectSeries(VacancyResSetup."Vacancy Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;

}
