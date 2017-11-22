codeunit 82111 "WaldoNAVPad Text Parse Meth"
{
  trigger OnRun();
  begin
  end;

  procedure ParseText(var Text : Text;MaxLength : Integer;var ResultWaldoNAVPadTextBuffer : Record "WaldoNAVPad Text Buffer");
  var
    Handled : Boolean;
  begin
    OnBeforeParseText(Text,Handled);
    DoParseText(Text,MaxLength,ResultWaldoNAVPadTextBuffer,Handled);
    OnAfterParseText(Text);
  end;

  local procedure DoParseText(var Text : Text;MaxLength : Integer;var ResultWaldoNAVPadTextBuffer : Record "WaldoNAVPad Text Buffer";var Handled : Boolean);
  var
    SystemString : Text;
    LineArray : List of [Text];
    SystemIOStringReader : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StringReader";
    Line : Text;
    LineNo : Integer;
  begin
    if Handled then exit;

    SystemString := Text;

    ResultWaldoNAVPadTextBuffer.DELETEALL(false);

    SystemIOStringReader := SystemIOStringReader.StringReader(Text);
    Line := SystemIOStringReader.ReadLine;
    while not ISNULL(Line) do begin
      ProcessLine(LineNo,Line,MaxLength,ResultWaldoNAVPadTextBuffer);

      Line := SystemIOStringReader.ReadLine;
    end;
  end;

  local procedure ProcessLine(var LineNo : Integer;var Line : Text;MaxLength : Integer;var ResultWaldoNAVPadTextBuffer : Record "WaldoNAVPad Text Buffer");
  var
    SubString : Text;
    SpaceIndex : Integer;
    ResultString : Text;
  begin
    while STRLEN(Line) > MaxLength do begin
      SubString := COPYSTR(Line,1,MaxLength);
      SpaceIndex := SubString.LastIndexOf(' ');
      if SpaceIndex = -1 then //No Space Found
        SpaceIndex := MaxLength;
      if SpaceIndex = 0 then //First Character is a space
        SpaceIndex := MaxLength;
      ResultString := SubString;
      if SpaceIndex < strlen(SubString) then begin
        ResultString := SubString.Substring(0,SpaceIndex);
        AddToBuffer(LineNo,ResultString,ResultWaldoNAVPadTextBuffer.Separator::" ", ResultWaldoNAVPadTextBuffer);
      end else begin
        AddToBuffer(LineNo,ResultString,ResultWaldoNAVPadTextBuffer.Separator::Space, ResultWaldoNAVPadTextBuffer);
      end;

      Line := Line.Remove(0,strlen(ResultString));
    end;

    AddToBuffer(LineNo,Line,ResultWaldoNAVPadTextBuffer.Separator::"Carriage Return",ResultWaldoNAVPadTextBuffer);
  end;

  local procedure AddToBuffer(var LineNo : Integer;var Line : Text;pSeparator : Integer;var ResultWaldoNAVPadTextBuffer : Record "WaldoNAVPad Text Buffer");
  begin
    LineNo += 1;

    with ResultWaldoNAVPadTextBuffer do begin
      INIT;
      "Line No." := LineNo;
      Textline := Line;
      Separator := pSeparator;
      INSERT;
    end;
  end;

  [IntegrationEvent(false, false)]
  local procedure OnBeforeParseText(var Text : Text;var Handled : Boolean);
  begin
  end;

  [IntegrationEvent(false, false)]
  local procedure OnAfterParseText(var Text : Text);
  begin
  end;
}

