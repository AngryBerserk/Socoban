unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, Buttons, ExtCtrls, StdCtrls, XPMan, About;

const Chars :Array[1..62] of Char = ('1','2','3','4','5','6','7','8','9','0',
    'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m',
    'Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M');

type
  TMap = Array[1..100,1..100,1..2] of Byte;
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    File1: TMenuItem;
    New1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    Quit1: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    SP1: TSpeedButton;
    SP2: TSpeedButton;
    SP3: TSpeedButton;
    SP4: TSpeedButton;
    SP5: TSpeedButton;
    Splitter1: TSplitter;
    XPManifest1: TXPManifest;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Saveas1: TMenuItem;
    PageControl1: TPageControl;
    ScrollBar2: TScrollBar;
    ScrollBar1: TScrollBar;
    Splitter2: TSplitter;
    AddLevel1: TMenuItem;
    Project1: TMenuItem;
    Deletelevel1: TMenuItem;
    Renamelevel1: TMenuItem;
    EditPassword1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Savecompiled1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Tiles: TMenuItem;
    N4: TMenuItem;
    AddLayer1: TMenuItem;
    DeleteLayer1: TMenuItem;
    RenameLayer1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Quit1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SP1Click(Sender: TObject);
    procedure SP2Click(Sender: TObject);
    procedure SP4Click(Sender: TObject);
    procedure SP3Click(Sender: TObject);
    procedure SP5Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure AddLevel1Click(Sender: TObject);
    procedure Renamelevel1Click(Sender: TObject);
    procedure Deletelevel1Click(Sender: TObject);
    procedure EditPassword1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Savecompiled1Click(Sender: TObject);
  private
    Objects:Array of Record
                      Pic:TBitmap;
                      ID:String;
                      Typ_e:String;
                     End;
    Buffer:TBitmap;
    Drawing:Byte;
    Hash:String[15];
    PN:String;    //0-Wall 1-Floor 2-Crate
    Company:array of Record
                      Map:TMap;
                      HP:TPoint;
                      Level_Password:String[10];
                     End;
    Procedure Create_New_Level(Lname:String);
    Procedure Redraw;
    Procedure Reset;
    Procedure Save_Routine;
    Procedure Load_Routine;
    Procedure Get_Boundaries(Var L,R,U,D:Byte;Index:Word);
    Procedure Prepare_Hash(EnCrypt:Boolean);
    Procedure Initialize_Plugins;
    Function Object_By_ID(ID:String):TBitmap;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
Function ExtractByID(Var Pic:TBitmap;ID:String):Boolean;external '..\..\ResMan\RESMAN.dll';
Function Init(ResName:String):Boolean; external '..\..\ResMan\RESMAN.dll';
Procedure Release_Res; external '..\..\ResMan\RESMAN.dll';
Procedure Extract_Texture(Var Pic:TBitmap;Var ID:String); external '..\..\ResMan\RESMAN.dll';
//------------------------------------------------------------------------------------------------------
procedure TForm1.About1Click(Sender: TObject);begin AboutBox.ShowModal end;
procedure TForm1.Quit1Click(Sender: TObject);begin Form1.Close end;
procedure TForm1.PageControl1Change(Sender: TObject);begin Redraw end;
procedure TForm1.FormPaint(Sender: TObject);begin Redraw end;
procedure TForm1.ScrollBar1Change(Sender: TObject);begin ReDraw end;
procedure TForm1.Load1Click(Sender: TObject);begin If MessageDlg('Reset Project?',MtConfirmation,[MBYES,MBNO],0)=mrYes Then Load_Routine end;
procedure TForm1.SP1Click(Sender: TObject);begin Drawing:=1;StatusBar1.Panels[1].Text:='Now drawing: Floor panels'end;
procedure TForm1.SP2Click(Sender: TObject);begin Drawing:=0;StatusBar1.Panels[1].Text:='Now drawing: Wall panels'end;
procedure TForm1.SP4Click(Sender: TObject);begin Drawing:=2;StatusBar1.Panels[1].Text:='Now placing: Crates'end;
procedure TForm1.SP3Click(Sender: TObject);begin Drawing:=3;StatusBar1.Panels[1].Text:='Now triggering: Checkpoints'end;
procedure TForm1.SP5Click(Sender: TObject);begin Drawing:=4;StatusBar1.Panels[1].Text:='Now placing: Hero'end;
procedure TForm1.New1Click(Sender: TObject);begin If MessageDlg('Reset Project?',MtConfirmation,[MBYES,MBNO],0)=mrYes Then Begin Reset;Redraw end end;
procedure TForm1.Save1Click(Sender: TObject);begin SaveDialog1.Title:='Save Project as...';If PN='' Then Saveas1Click(Self) Else Begin PN:=SaveDialog1.Filename;Save_Routine end end;
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);begin CanClose:=False;
If MessageDlg('Realy quit?',MtConfirmation,[MBYES,MBNO],0)=mrYes Then CanClose:=True
end;
//-----------------------------------------------------------------------------------------------------
Procedure TForm1.Create_New_Level(LName:String);
 Var Z:Byte;
Begin
with PageControl1 do
  with TTabSheet.Create(Self) do
      begin
        PageControl := PageControl1;
        Caption := LName
      end;
SetLength(Company,PageControl1.PageCount);
FillChar(Company[PageControl1.PageCount-1].Map,SizeOf(Company[PageControl1.PageCount-1].Map),0);
Company[PageControl1.PageCount-1].HP.X:=101;Company[PageControl1.PageCount-1].HP.Y:=101;
Company[PageControl1.PageCount-1].Level_Password:='          ';
For Z:=1 to 10 Do Company[PageControl1.PageCount-1].Level_Password[Z]:=Chars[Random(62)+1]
End;

procedure TForm1.Reset;

Procedure Reset_Pages; var i:Word;Begin for i := 0 to PageControl1.PageCount - 1 do PageControl1.Pages[0].Free End;

Begin
if PageControl1.PageCount>0 Then Reset_Pages;
Create_New_Level('default');
Buffer.Width:=0;Buffer.Height:=0;
Buffer.Width:=Form1.ClientWidth;Buffer.Height:=Form1.ClientHeight
End;

Function TForm1.Object_By_ID(ID:String):TBitmap;
 var Z:Integer;
Begin
 Result:=nil;
 Z:=-1;
 Repeat
  Inc(Z)
 Until (Objects[Z].ID=ID)or(Z=High(Objects));
 If Objects[Z].ID<>ID then MessageDlg('Object with ID `'+ID+'` doesn`t exists',mtError,[mbOk],0) Else Result:=Objects[Z].Pic
End;

Procedure TForm1.Initialize_Plugins;
 Var F:TextFile;S:String;
Begin
AssignFile(F,'Editor.ini');
System.Reset(F);
Repeat
Readln(F,S);
If Not(Init(S)) then Begin ShowMessage('Resource file corrupted!');Halt End;
//Load_Types;
//Load_Objects;
Until Eof(F);
CloseFile(F);
Release_Res
End;

procedure TForm1.FormShow(Sender: TObject);
 Var Z:Word;//F:File of Byte; S:String; Q:Byte;
begin
Initialize_Plugins;
 {
AssignFile(F,'1.dll');
Rewrite(F);

S:='>FTEST,>TCEILING,WALL,CRATE,CHECKED_CRATE,CHECKED_CEILING,HERO,>RSocoban.res,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=1;
Write(F,Q);
S:='CEILING,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=5;
Write(F,Q);
S:='CHECKED_CEILING,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=3;
Write(F,Q);
S:='CRATE,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=4;
Write(F,Q);
S:='CRATE_OK,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=2;
Write(F,Q);
S:='WALL,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=6;
Write(F,Q);
S:='HERO,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=6;
Write(F,Q);
S:='HERO2,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=6;
Write(F,Q);
S:='HERO3,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
Q:=6;
Write(F,Q);
S:='HERO4,';
For Z:=1 to length(S) Do Begin Q:=Ord(S[Z])-48;
Write(F,Q); End;
CloseFile(F);
  }
{
SetLength(Objects,6);
For Z:=0 to 5 Do
Extract_Texture(Objects[Z].Pic,Objects[Z].ID);
For Z:=1 to 5 Do
  With TSpeedButton(FindComponent('Sp'+IntToStr(Z))) do Begin
    Glyph:=TBitmap.Create;
    Glyph.Width:=30;
    Glyph.Height:=30;
  End;
Buffer:=TBitmap.Create;
Object_By_ID('HERO').Transparent:=True;
Object_By_ID('HERO').TransparentColor:=clFuchsia;
Sp1.Glyph.Canvas.Draw(0,0,Object_by_ID('CEILING'));
Sp2.Glyph.Canvas.Draw(0,0,Object_by_ID('WALL'));
Sp3.Glyph.Canvas.Draw(0,0,Object_by_ID('CHECKED_CEILING'));
Sp4.Glyph.Canvas.Draw(0,0,Object_by_ID('CRATE'));
Sp5.Glyph.Canvas.Draw(0,0,Object_by_ID('HERO'));
Reset }
end;

procedure TForm1.Redraw;
 Var X,Y:Word;
begin
 For Y:=1 to ClientHeight div 30 Do For X:=1 to ClientWidth div 31 Do Begin
  Case Company[PageControl1.ActivePageIndex].Map[X+ScrollBar1.Position,Y+ScrollBar2.Position,1] of
    0:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Object_by_ID('WALL'));
    1:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Object_by_ID('CEILING'));
    2:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Object_by_ID('CRATE'));
  End;
  If Company[PageControl1.ActivePageIndex].Map[X+ScrollBar1.Position,Y+ScrollBar2.Position,2]=1 Then
  Case Company[PageControl1.ActivePageIndex].Map[X+ScrollBar1.Position,Y+ScrollBar2.Position,1] of
    1:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Object_by_ID('CHECKED_CEILING'));
    2:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Object_by_ID('CRATE_OK'));
  End End;
  If Company[PageControl1.ActivePageIndex].HP.X<101 Then Buffer.Canvas.Draw(Company[PageControl1.ActivePageIndex].HP.X*30-ScrollBar1.Position*30,Company[PageControl1.ActivePageIndex].HP.Y*30-ScrollBar2.Position*30,Object_by_ID('HERO'));
  Canvas.Draw(30,26,Buffer)
end;

procedure TForm1.FormResize(Sender: TObject);
begin
ScrollBar1.Max:=100-Form1.ClientWidth div 30;
ScrollBar2.Max:=100-Form1.ClientHeight div 30;
Buffer.Width:=ClientWidth;
Buffer.Height:=ClientHeight;
Redraw
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
StatusBar1.Panels[0].Text:='X: '+IntToStr(((X) Div 30)+ScrollBar1.Position)+' Y: '+IntToStr(((Y+6) Div 30)+ScrollBar2.Position);
If ssLeft in Shift Then FormMouseDown(Self,mbLeft,Shift,x,y)
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  Var XX,YY:Word;
begin
If (y>0)and(x>30)and(x+6<ClientWidth)and(y+35<ClientHeight) then Begin
 XX:=(X) Div 30+ScrollBar1.Position;YY:=((Y+6) Div 30)+ScrollBar2.Position;
Case Drawing of
 0..2:If (Company[PageControl1.ActivePageIndex].HP.X+1<>XX)or(Company[PageControl1.ActivePageIndex].HP.Y+1<>YY) Then Company[PageControl1.ActivePageIndex].Map[XX,YY,1]:=Drawing;
 3:Begin If Company[PageControl1.ActivePageIndex].Map[XX,YY,2]=1 Then Company[PageControl1.ActivePageIndex].Map[XX,YY,2]:=0 Else Company[PageControl1.ActivePageIndex].Map[XX,YY,2]:=1;If Company[PageControl1.ActivePageIndex].Map[XX,YY,1]=0 Then Company[PageControl1.ActivePageIndex].Map[XX,YY,1]:=1 End;
 4:If Company[PageControl1.ActivePageIndex].Map[XX,YY,1]=1 Then Begin Company[PageControl1.ActivePageIndex].HP.X:=XX-1;Company[PageControl1.ActivePageIndex].HP.Y:=YY-1 End
End End;
Redraw
end;

procedure TForm1.AddLevel1Click(Sender: TObject);
 var LName:String;begin
If InputQuery('Adding level to the Campaign','Enter the New level name',Lname) then Create_New_Level(LName) Else Create_New_Level('default');
If LName='' Then PageControl1.Pages[PageControl1.PageCount-1].Caption:='default'
end;

procedure TForm1.Renamelevel1Click(Sender: TObject); var LName:String;begin
If InputQuery('Renaming level','Enter the New level name',Lname) then PageControl1.ActivePage.Caption:=LName
end;

procedure TForm1.Deletelevel1Click(Sender: TObject); var Z:Word;begin
If PageControl1.PageCount=1 Then MessageDlg('Unable to delete the only level.',mtError,[mbOk],0)Else  Begin
If MessageDlg('Level `'+PageControl1.ActivePage.Caption+'` will be deleted permanently! Confirm action?',mtWarning,mbYesNoCancel,0)=mrYes Then
  Begin
    If PageControl1.ActivePageIndex<PageControl1.PageCount-1 Then
    For Z:=PageControl1.ActivePageIndex+1 to PageControl1.PageCount-1 Do
      Begin
        Company[Z-1]:=Company[Z];
        PageControl1.Pages[Z-1].Caption:=PageControl1.Pages[Z].Caption
      End;
    SetLength(Company,PageControl1.PageCount-1);
    PageControl1.ActivePageIndex:=0;
    PageControl1.Pages[PageControl1.PageCount-1].Free;
    Redraw
  End
End
end;

procedure TForm1.EditPassword1Click(Sender: TObject); Var q:String;Z:Word;begin
Q:=InputBox('Edit Level Password','Enter New Password',Company[PageControl1.ActivePageIndex].Level_Password);
If Q<>Company[PageControl1.ActivePageIndex].Level_Password Then Company[PageControl1.ActivePageIndex].Level_Password:=Q;
For Z:= Length(Q) to 15 Do Company[PageControl1.ActivePageIndex].Level_Password:=Company[PageControl1.ActivePageIndex].Level_Password+' '
end;
//-------------------------------------------------------------------------------------------------------------------
procedure TForm1.Get_Boundaries(Var L,R,U,D:Byte;Index:Word);Var X,Y:Word;Flag:Boolean;Begin
 X:=0;Flag:=False;
 Repeat Inc(X);For Y:=1 to 100 Do If Company[Index].Map[X,Y,1]<>0 then Flag:=True until (Flag=True)or(x=100);
 L:=X;X:=100;Flag:=False;
 Repeat Dec(X);For Y:=1 to 100 Do If Company[Index].Map[X,Y,1]<>0 then Flag:=True until (Flag=True)or(x=0);
 R:=X;Y:=0;Flag:=False;
 Repeat Inc(Y);For X:=1 to 100 Do If Company[Index].Map[X,Y,1]<>0 then Flag:=True until (Flag=True)or(Y=100);
 U:=Y; Y:=100; Flag:=False;
 Repeat Dec(Y);For X:=1 to 100 Do If Company[Index].Map[X,Y,1]<>0 then Flag:=True until (Flag=True)or(Y=0);
 D:=Y;
End;

Procedure TForm1.Load_Routine;
 Var F:File of Byte;X,Y,C,H,W,Num,Z:Byte;A:String;
Begin
 If (OpenDialog1.Execute)And(OpenDialog1.FileName<>'') Then
 Begin
 Reset;
 PageControl1.Pages[PageControl1.PageCount-1].Free;
 AssignFile(F,OpenDialog1.FileName);
 System.Reset(F);
 For H:=1 to 15 Do Begin Read(F,W);A:=A+Chr(Ord(W)+48) End;
 Delete(A,Length(ExtractFileName(OpenDialog1.FileName))+1,15);
 If A=ExtractFileName(OpenDialog1.FileName) Then Begin
 Read(F,Num);
 For Z:=0 to Num Do Begin
  A:='';
  For H:=1 to 20 Do Begin Read(F,W); A:=A+Chr(Ord(W)+48) End;
  Create_New_Level(A);
  Read(F,H,W);
  For C:=1 to 2 Do For Y:=1 to H Do For X:=1 to W Do Read(F,Company[Z].Map[X,Y,C]);
  Read(F,H,W);
  Company[Z].HP.X:=H;Company[Z].HP.Y:=W;
  Company[Z].Level_Password:='';
  For H:=1 to 10 Do Begin Read(F,W); Company[Z].Level_Password:=Company[Z].Level_Password+Chr(Ord(W)+48) End;
 End;
  PN:=OpenDialog1.FileName;
  Caption:=ExtractFileName(PN)+' - Socoban Editor'
 End Else BEgin Create_New_Level('default');MessageDlg('File is corrupted or it is a compiled company file.',mtError,[mbOk],0)end;
 CloseFile(F);
 End;
Redraw
End;

Procedure TForm1.Save_Routine;
 Var L,R,U,D,X,Y,C:Byte;F:File of Byte;Q1,Q2:Byte;Z:Word;
Begin
AssignFile(F,PN);
Rewrite(F);
For Z:=1 to 15 Do Begin Q1:=Ord(Hash[Z]);Write(F,Q1) End;
Q1:=PageControl1.PageCount-1;
Write(F,Q1);
For Z:=0 to PageControl1.PageCount-1 Do Begin
  For Q2:=1 to 20 Do Begin Q1:=Ord(PageControl1.Pages[Z].Caption[Q2])-48;Write(F,Q1) End;
  Get_Boundaries(L,R,U,D,Z);
  Dec(U);
  If L>1 Then Dec(L);
  Q1:=D-U+1;
  Q2:=R-L+1;
  Write(F,Q1,Q2);
  For C:=1 to 2 Do For Y:=U to D Do For X:=L to R Do
  Write(F,Company[Z].Map[X,Y,C]);
  Write(F,Company[Z].HP.X,Company[Z].HP.Y);
  For Q2:=1 to 10 Do Begin Q1:=Ord(Company[Z].Level_Password[Q2])-48;Write(F,Q1) End;
 End;
 CloseFile(F)
End;

procedure TForm1.Saveas1Click(Sender: TObject);begin
 SaveDialog1.Title:='Save Project as...';
 If (SaveDialog1.Execute)And(SaveDialog1.FileName<>'') Then
 Begin
  PN:=SaveDialog1.FileName;
  Caption:=ExtractFileName(PN)+' - Socoban Editor';
  Prepare_Hash(true);
  Save_Routine;
 End
end;

procedure TForm1.Savecompiled1Click(Sender: TObject);
begin
 If PN='' Then Saveas1Click(Self);
 If PN='' Then MessageDlg('Please, save the project first',mtError,[mbOk],0)
 Else Begin
    SaveDialog1.Title:='Save Compiled Company as...';
    If (SaveDialog1.Execute)And(SaveDialog1.FileName<>'') Then Begin
    PN:=SaveDialog1.FileName;
    Prepare_Hash(false);
    Save_Routine
    End
 End
end;

Procedure TForm1.Prepare_Hash(EnCrypt:Boolean);
 Var Z:Byte;
Begin
Hash:='               ';
For Z:=1 to 15 Do
  If Not(EnCrypt)Then Hash[Z]:=Chr(Ord(Chars[Random(62)+1])-48)
    Else Begin If Length(ExtractFileName(PN))>=Z Then Hash[Z]:=Chr(Ord(ExtractFileName(PN)[Z])-48)
      Else Begin EnCrypt:=False;Hash[Z]:=Chr(Ord(Chars[Random(62)+1])-48)End End
End;

end.
