reportextension 50004 "CIR Fix. Asset - Book Value 01" extends "Fixed Asset - Book Value 01"
{
    RDLCLayout = './RDL/FixedAssetBookValue01.rdl';
    dataset
    {
        add("Fixed Asset")
        {
            column(No_FixedAsset; "No.")
            {
                IncludeCaption = true;
            }
            column(Description_FixedAsset; Description)
            {
                IncludeCaption = true;
            }
        }
    }
}