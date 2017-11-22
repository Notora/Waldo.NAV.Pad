page 56110 "WNP Blobs"
{
  PageType = List;
  SourceTable = "WaldoNavPad Blobstore";

  layout
  {
    area(content)
    {
      repeater(Group)
      {
        field("Entry No.";"Entry No.")
        {
        }
        field(RecordID;FORMAT("Record ID"))
        {
        }
        field(Blob;Blob)
        {
        }
      }
    }
  }

  actions
  {
  }
}

