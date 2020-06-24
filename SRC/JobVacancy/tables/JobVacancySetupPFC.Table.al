table 50104 "JobVacancySetup_PFC"
{
    Caption = 'Job Vacancy Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Vacancy Nos."; Code[20])
        {
            Caption = 'Vacancy Nos.';
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
