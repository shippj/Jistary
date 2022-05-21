unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, strutils, ShellAPI, Masks, ExtCtrls;

type
  TfrmMain = class(TForm)
    txtMain: TEdit;
    lbResults: TListBox;
    procedure txtMainChange(Sender: TObject);
    procedure txtMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    cmd1,cmd2,cmd3,cmd4: array of string;
    MyFileMask: TMask;
    fcsContaining: String;
    procedure DoIt;
    procedure LoadCommands;
    procedure fns(Folder: String);
    procedure fcs(Folder: String);
    function SearchFile(File2Search: String; FileSize: Integer; String2Find: String): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  KBHook: HHook; {this intercepts keyboard input}


implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LoadCommands;

  // set window size
  self.Height := round(screen.Height * 0.75);
end;

procedure TfrmMain.txtMainChange(Sender: TObject);
var text,key,data: string;
 x,space: integer;
begin
  lbResults.Clear;
  text := txtMain.Text;

  // has the user typed a command?
  space := pos(' ',text);
  if space > 0 then begin
    key := leftstr(text,space-1);
    data := rightstr(text,length(text)-space);
    for x := 0 to length(cmd1)-1 do
      if lowercase(key) = lowercase(cmd1[x]) then
        lbResults.items.Add(cmd2[x]+': '+data);
    end;

  // let's add all the search results for file names
  if length(text)>2 then
    for x := 0 to length(cmd1)-1 do
      if cmd3[x] = 'fns' then begin
        MyFileMask := TMask.Create('*'+text+'*');
//        lbResults.Clear;
        fns(cmd4[x]);
//        lbResults.items.Add('done');
        MyFileMask.Destroy;
        end;

  if lbresults.Count>0 then lbresults.Selected[0] := true;
end;

procedure TfrmMain.txtMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then
    DoIt
  else if Key=27 then
    application.Terminate
  else if Key=38 then
    lbResults.ItemIndex := lbResults.ItemIndex-1
  else if Key=40 then
    lbResults.ItemIndex := lbResults.ItemIndex+1;
  //caption := inttostr(key);
end;

procedure TfrmMain.DoIt;                     // runs when user presses enter
var text,key,data,cmd,parameters: string;
 x,colon: integer;
begin
  if lbResults.ItemIndex = -1 then exit;
  text := lbResults.Items[lbResults.ItemIndex];
  colon := pos(':',text);
  if colon = 0 then exit;  //not a command
  key := leftstr(text,colon-1);
  data := rightstr(text,length(text)-colon-1);

//  showmessage('-'+data+'-');

  for x := 0 to length(cmd1)-1 do
    if key = cmd2[x] then begin
      cmd := cmd3[x];
      parameters := cmd4[x];
      end;

  if cmd = 'fns' then begin
    MyFileMask := TMask.Create('*'+data+'*');
    lbResults.Clear;
    fns(parameters);
    lbResults.items.Add('done');
    lbResults.ItemIndex := 0;
    MyFileMask.Destroy;
    end
  else if (cmd = 'fcs') and (length(data)>1) then begin
    fcsContaining := lowercase(data);
    MyFileMask := TMask.Create('*.*');
    if rightstr(parameters,1) <> '\' then
      parameters := parameters + '\';
    lbResults.Clear;
    fcs(parameters);
    lbResults.items.Add('done');
    lbResults.ItemIndex := 0;
    MyFileMask.Destroy;
    end
  else if cmd <> '' then begin
    cmd := stringreplace(cmd,'{query}',data,[]);
    parameters := stringreplace(parameters,'{query}',data,[]);
    ShellExecute(handle,'Open',PChar(cmd),PChar(parameters),nil,SW_MAXIMIZE);
    application.Terminate;
    end;

  txtMain.SelectAll;
end;

procedure TfrmMain.LoadCommands;    // loads commands from the txt file
var a,b,c,x,CmdCount: integer;
  s: String;
begin
  lbResults.Items.LoadFromFile('commands.txt');
  CmdCount := lbResults.Count;
  SetLength(cmd1,CmdCount+1);
  SetLength(cmd2,CmdCount+1);
  SetLength(cmd3,CmdCount+1);
  SetLength(cmd4,CmdCount+1);
  for x := 0 to CmdCount-1 do begin
    s := lbResults.Items[x];
    a := pos(chr(9),s);                             // find pos of first tab
    b := posEx(chr(9),s,a+1);                       // find pos of second tab
    c := posEx(chr(9),s,b+1);                       // find pos of third tab

    if length(s)=0 then
      // blank line
    else if length(s)=1 then
      // blank line
    else if leftstr(s,1)='#' then
      // comment line
    else if (a > 0) and (b>0) then begin
      cmd1[x] := leftstr(s,a-1);
      cmd2[x] := midstr(s,a+1,b-a-1);
      if c=0 then
        cmd3[x] := rightstr(s,length(s)-b)
      else begin
        cmd3[x] := midstr(s,b+1,c-b-1);
        cmd4[x] := rightstr(s,length(s)-c)
//showmessage('-'+cmd4[x]+'-');
        end;
      if (lowercase(cmd3[x]) = 'fns') or (lowercase(cmd3[x]) = 'fcs') then begin
        cmd3[x] := lowercase(cmd3[x]);
        if rightstr(cmd4[x],1) <> '\' then
          cmd4[x] := cmd4[x] + '\';             // make sure it ends with \
        end;
      end
    else
      showmessage('Invalid line in command.txt.  Each line should contain 2 tabs'+chr(13)+chr(13)+s);
    end;

  // add 1 more line - this is the command that allows the user to open search results
//  cmd1[CmdCount] := '#';
//  cmd1[CmdCount] := 'wtf';
  cmd2[CmdCount] := 'open';
  cmd3[CmdCount] := '{query}';
//  cmd4[CmdCount] := 'wtf';

  lbResults.Clear;
  for x := 0 to length(cmd1)-2 do
    if cmd1[x]<>'' then
      lbResults.items.Add(cmd1[x]+'  '+cmd2[x]);
//      lbResults.items.Add(cmd1[x]+'  '+cmd2[x]+'  '+cmd4[x]);

end;

procedure TfrmMain.fns(Folder: String);
  var sr: TSearchRec;
begin
//    StatusBar1.SimpleText := 'Searching: '+Folder;

  if FindFirst(Folder+'*',faAnyFile,sr) = 0 then begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then begin {$WARNINGS OFF} //faHidden is specific to platform
        if ((sr.Attr and faDirectory) <> 0) then
            fns(Folder+sr.Name+'\');
        if MyFileMask.Matches(sr.Name) then
          lbResults.Items.add('open: '+Folder+sr.Name);
        end;
    until (FindNext(sr) <> 0);
    end;
  FindClose(sr);
end;

procedure TfrmMain.fcs(Folder: String);
  var sr: TSearchRec;
begin
//    StatusBar1.SimpleText := 'Searching: '+Folder;

  if FindFirst(Folder+'*',faAnyFile,sr) = 0 then begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then begin {$WARNINGS OFF} //faHidden is specific to platform
          if ((sr.Attr and faDirectory) <> 0) then
              fcs(Folder+sr.Name+'\');
          if MyFileMask.Matches(sr.Name) then begin
            if SearchFile(Folder+sr.Name,sr.Size, fcsContaining) then
              lbResults.Items.add('open: '+Folder+sr.Name);
            end;
        end;
    until (FindNext(sr) <> 0);
    end;
  FindClose(sr);
end;

function TfrmMain.SearchFile(File2Search: String; FileSize: Integer; String2Find: String): Boolean;
var Buffer: PChar;
FileHandle: Integer;
begin
//    StatusBar1.SimpleText := 'Searching inside '+File2Search;
  FileHandle := FileOpen(File2Search,fmShareDenyNone or fmOpenRead);
  Buffer := PChar(AllocMem(FileSize + 1));
  FileRead(FileHandle,Buffer^,FileSize);
  FileClose(FileHandle);
//  if chkCaseContaining.Checked then
//    Result := Pos(txtContaining.Text,Buffer) > 0
//  else
    Result := Pos(fcsContaining,LowerCase(Buffer)) > 0;
  FreeMem(buffer);
end;

end.
