unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    New1: TMenuItem;
    Quit1: TMenuItem;
    Pref1: TMenuItem;
    LoadSkin1: TMenuItem;
    Help1: TMenuItem;
    Timer1: TTimer;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    AniTimer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AniTimerTimer(Sender: TObject);
  private
    Error_Log:TextFile;
    AniBuffer:TBitmap;
    MiniBuf:TBitmap;
    Buffer:TBitmap;
    Floor:TBitmap;
    Floor_Checked:TBitmap;
    Wall:TBitmap;
    CratePic:TBitmap;
    CrateOKPic:TBitmap;
    Skin_Path:String;
    Level_Path:String;
    Map_Size:TPoint;
    Animate:Boolean;
    Map:Array of Array of Array of Byte;
    Hero:Record
          Pos:TPoint;
          DX,DY:Short;
          Pic:Array[1..4] of TBitmap;
          Dir:Word
         End;
    Function Free(X,Y:Byte):Boolean;
    Function Move_Crate(X,Y,Dir:Byte):Boolean;
    Procedure Init_Log;
    Procedure Write_Log(Messag:String);
    Procedure Load_Level(ID:String);
    Procedure Load_Theme;
    Procedure Redraw;
  end;

var
  Form1: TForm1;

implementation
Function Init(ResName:String):Boolean; external 'RESMAN.dll';
Procedure Release_Res; external 'RESMAN.dll';
Procedure Extract_Texture(Var Pic:TBitmap;Var ID:String); external 'RESMAN.dll';
{$R *.dfm}

Procedure TForm1.Load_Level(ID:String);

 Procedure Load(Name:String);
  Var F:File of Byte;H,W,C,X,Y:Byte;
 Begin
  AssignFile(F,Name);
  {$I-}
  Reset(F);
  {$I+}
  If IOResult<>0 Then Begin Write_log('Level `'+name+'` not found.');ShowMessage('Level not found.') End Else Begin
  Read(F,H,W);
  Map_Size.X:=W+1;Map_Size.Y:=H+1;
  Buffer.Width:=(W+1)*30;Buffer.Height:=(H+1)*30;
  SetLength(Map,W+2,H+2,2);
  For C:=1 to 2 Do For Y:=1 to H Do For X:=1 to W Do Read(F,Map[X,Y,C]);
  Read(F,H,W);
  Hero.Pos.X:=H;Hero.Pos.Y:=W;
  Hero.Dir:=1;
  CloseFile(F);
  Width:=Buffer.Width+26;Height:=Buffer.Height+90;
  Constraints.MaxHeight:=Height;Constraints.MaxWidth:=Width;
  End
 End;

Begin
 If ID='' Then Load(Level_Path);
End;

Procedure TForm1.Load_Theme;
 Var Q:String;Z:Byte;
Begin
If Not(Init(Skin_Path)) then Begin ShowMessage('Resource file corrupted!');Write_log('Resource file corrupted, terminating.');Halt End;
Extract_Texture(Floor,Q);
Extract_Texture(Floor_Checked,Q);
Extract_Texture(CratePic,Q);
Extract_Texture(CrateOKPic,Q);
Extract_Texture(Wall,Q);
For Z:=1 to 4 Do Begin
Extract_Texture(Hero.Pic[Z],Q);
Hero.Pic[Z].Transparent:=True;
Hero.Pic[Z].TransparentColor:=clFuchsia End
End;

Procedure TForm1.Write_Log(Messag:String);Begin
Writeln(Error_log,DateToStr(Date)+' ['+TimeToStr(Time)+'] '+Messag )
End;

Procedure TForm1.Init_Log;Begin
AssignFile(Error_log,'Error.log');
{$I-}Append(Error_log);{$I+}
If IOResult<>0 Then Begin Rewrite(Error_log);Write_log('Error log created.') End
End;

procedure TForm1.FormShow(Sender: TObject);

Procedure Initialize;
 Var F:TextFile;
Begin
Init_Log;
AssignFile(F,'Socoban.ini');
 {$I-}Reset(F);{$I+}
If IOResult=0 Then Begin Readln(F,Skin_Path);Readln(F,Level_Path) End
Else
  Begin
    Write_log('`Socoban.ini` not found.Recreating.');
    AssignFile(F,'Socoban.ini');
    Rewrite(F);
    Writeln(F,'Data\Socoban.res');
    Writeln(F,'Data\1.maze');
    CloseFile(F);
    Skin_Path:='Data\Socoban.res';
    Level_Path:='Data\1.maze'
  End;
End;

begin
Initialize;
Buffer:=TBitmap.Create;
AniBuffer:=TBitmap.Create;
AniBuffer.Width:=150;
AniBuffer.Height:=150;
MiniBuf:=TBitmap.Create;
MiniBuf.Width:=150;
MiniBuf.Height:=150;
Load_Theme;
Load_Level('');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);begin Release_Res;CloseFile(Error_log) end;

Procedure TForm1.Redraw;
 Var X,Y:Byte;
Begin
 For Y:=1 to Map_Size.Y Do For X:=1 to Map_Size.X Do Begin
  Case Map[X,Y,1] of
   0:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Wall);
   1:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Floor);
   2:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,CratePic)
  End;
  If Map[X,Y,2]=1 Then
  Case Map[X,Y,1] of
    1:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,Floor_Checked);
    2:Buffer.Canvas.Draw((X-1)*30,(Y-1)*30,CrateOKPic);
  End End;
  If Hero.Pos.X<101 Then Buffer.Canvas.Draw(Hero.Pos.X*30,Hero.Pos.Y*30,Hero.Pic[Hero.Dir]);
  Form1.Canvas.Draw(0-ScrollBar1.Position,0-ScrollBar2.Position,Buffer)
End;

procedure TForm1.FormPaint(Sender: TObject);begin Redraw end;

procedure TForm1.Quit1Click(Sender: TObject);begin Form1.Close end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);begin
CanClose:=False;
If MessageDlg('Realy quit?',MtConfirmation,[MBYES,MBNO],0)=mrYes Then CanClose:=True
end;

procedure TForm1.FormResize(Sender: TObject);
 Var Q:Integer;
begin
Q:=Buffer.Height+36-ClientHeight;
If Q<0 Then Q:=0;
ScrollBar2.Max:=Q;
ScrollBar1.Max:=Buffer.Width+26-Width;
Redraw
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
Redraw
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
Redraw
end;

Function TForm1.Move_Crate(X,Y,Dir:Byte):Boolean;
Begin
 Result:=False;
 Case Dir of
  1:If Map[X+1,Y,1]=1 Then Begin Map[X+1,Y,1]:=2;Map[X,Y,1]:=1;Result:=True End;
  2:If Map[X,Y+1,1]=1 Then Begin Map[X,Y+1,1]:=2;Map[X,Y,1]:=1;Result:=True End;
  3:If Map[X-1,Y,1]=1 Then Begin Map[X-1,Y,1]:=2;Map[X,Y,1]:=1;Result:=True End;
  4:If Map[X,Y-1,1]=1 Then Begin Map[X,Y-1,1]:=2;Map[X,Y,1]:=1;Result:=True End
 End;
End;

Function TForm1.Free(X,Y:Byte):Boolean;
Begin
X:=X+1;Y:=Y+1;
Result:=False;
If Map[X,Y,1]=1 Then Result:=True;
If Map[X,Y,1]=2 Then
 If Move_Crate(X,Y,Hero.Dir) Then Begin Result:=true;Animate:=True End
End;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Not(AniTimer.Enabled) Then Begin
 Animate:=False;
 Hero.DX:=0;Hero.DY:=0;
 Case Key Of
  VK_UP   :Begin Hero.Dir:=4;If Free(Hero.Pos.X,Hero.Pos.Y-1) Then Begin Hero.DY:=-1;AniTimer.Enabled:=True End;End;
  VK_DOWN :Begin Hero.Dir:=2;If Free(Hero.Pos.X,Hero.Pos.Y+1) Then Begin Hero.DY:=1;AniTimer.Enabled:=True End;End;
  VK_LEFT :Begin Hero.Dir:=3;If Free(Hero.Pos.X-1,Hero.Pos.Y) Then Begin Hero.DX:=-1;AniTimer.Enabled:=True End;End;
  VK_RIGHT:Begin Hero.Dir:=1;If Free(Hero.Pos.X+1,Hero.Pos.Y) Then Begin Hero.DX:=1;AniTimer.Enabled:=True End;End;
 End
 End
end;

procedure TForm1.AniTimerTimer(Sender: TObject);

Procedure Prepare_Buffer;
Begin
 AniBuffer.Canvas.Draw(0-Hero.Pos.X*30+60,0-Hero.Pos.Y*30+60,Buffer);
 If Map[Hero.Pos.X+1,Hero.Pos.Y+1,2]=0 Then AniBuffer.Canvas.Draw(60,60,Floor) Else AniBuffer.Canvas.Draw(60,60,Floor_Checked);
 If Animate Then If Map[Hero.Pos.X+1+Hero.DX,Hero.Pos.Y+1+Hero.DY,2]=0 Then AniBuffer.Canvas.Draw(60+Hero.DX*30,60+Hero.DY*30,Floor) Else AniBuffer.Canvas.Draw(60+Hero.DX*30,60+Hero.DY*30,Floor_Checked)
End;

begin
 If AniTimer.Tag=0 Then Prepare_Buffer;
 MiniBuf.Canvas.Draw(0,0,AniBuffer);
 MiniBuf.Canvas.Draw(60+AniTimer.tag*Hero.DX,60+AniTimer.tag*Hero.DY,Hero.Pic[Hero.Dir]);
 If Animate Then MiniBuf.Canvas.Draw(60+Hero.DX*30+AniTimer.tag*Hero.DX,60+Hero.DY*30+AniTimer.tag*Hero.DY,CratePic);
 Canvas.Draw(Hero.Pos.X*30-60,Hero.Pos.Y*30-60,MiniBuf);
 AniTimer.Tag:=AniTimer.Tag+1;
 If AniTimer.Tag=30 Then Begin Hero.Pos.X:=Hero.Pos.X+Hero.DX;Hero.Pos.Y:=Hero.Pos.Y+Hero.DY;Anitimer.tag:=0;Anitimer.Enabled:=False;Redraw End;
end;

end.
