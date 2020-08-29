object Form1: TForm1
  Left = 195
  Top = 163
  Width = 951
  Height = 642
  HorzScrollBar.Visible = False
  VertScrollBar.Color = clBlack
  VertScrollBar.ParentColor = False
  VertScrollBar.Visible = False
  Caption = 'untitled - Socoban Editor'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 264
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    943
    588)
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 553
    Width = 943
    Height = 0
    Cursor = crArrow
    Align = alBottom
    ResizeStyle = rsNone
    Visible = False
  end
  object Splitter2: TSplitter
    Left = 31
    Top = 0
    Width = 0
    Height = 553
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 569
    Width = 943
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'X: 0  Y:0'
        Width = 100
      end
      item
        Alignment = taCenter
        Text = 'Now drawing: Wall panels'
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 31
    Height = 553
    Align = alLeft
    TabOrder = 1
    object SP1: TSpeedButton
      Left = 0
      Top = 2
      Width = 30
      Height = 30
      Spacing = 0
      Transparent = False
      OnClick = SP1Click
    end
    object SP2: TSpeedButton
      Left = 0
      Top = 32
      Width = 30
      Height = 30
      Transparent = False
      OnClick = SP2Click
    end
    object SP3: TSpeedButton
      Left = 0
      Top = 124
      Width = 30
      Height = 30
      Transparent = False
      OnClick = SP3Click
    end
    object SP4: TSpeedButton
      Left = 0
      Top = 62
      Width = 30
      Height = 30
      Transparent = False
      OnClick = SP4Click
    end
    object SP5: TSpeedButton
      Left = 0
      Top = 154
      Width = 30
      Height = 30
      Transparent = False
      OnClick = SP5Click
    end
  end
  object PageControl1: TPageControl
    Left = 32
    Top = 0
    Width = 889
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    RaggedRight = True
    TabOrder = 2
    OnChange = PageControl1Change
  end
  object ScrollBar2: TScrollBar
    Left = 927
    Top = 0
    Width = 16
    Height = 553
    Align = alRight
    Kind = sbVertical
    Max = 82
    PageSize = 0
    TabOrder = 3
    OnChange = ScrollBar1Change
  end
  object ScrollBar1: TScrollBar
    Left = 0
    Top = 553
    Width = 943
    Height = 16
    Align = alBottom
    Constraints.MaxHeight = 16
    Constraints.MinHeight = 16
    Max = 71
    PageSize = 0
    TabOrder = 4
    OnChange = ScrollBar1Change
  end
  object MainMenu1: TMainMenu
    Left = 384
    Top = 72
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New campaign'
        OnClick = New1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as...'
        OnClick = Saveas1Click
      end
      object Savecompiled1: TMenuItem
        Caption = 'Save compiled...'
        OnClick = Savecompiled1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Load1: TMenuItem
        Caption = 'Load...'
        OnClick = Load1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'Quit'
        OnClick = Quit1Click
      end
    end
    object Project1: TMenuItem
      Caption = 'Project'
      object AddLevel1: TMenuItem
        Caption = 'Add level'
        OnClick = AddLevel1Click
      end
      object Deletelevel1: TMenuItem
        Caption = 'Delete level'
        OnClick = Deletelevel1Click
      end
      object Renamelevel1: TMenuItem
        Caption = 'Rename level'
        OnClick = Renamelevel1Click
      end
      object EditPassword1: TMenuItem
        Caption = 'Edit Password'
        OnClick = EditPassword1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object AddLayer1: TMenuItem
        Caption = 'Add Layer'
      end
      object DeleteLayer1: TMenuItem
        Caption = 'Delete Layer'
      end
      object RenameLayer1: TMenuItem
        Caption = 'Rename Layer'
      end
    end
    object Tiles: TMenuItem
      Caption = 'Tiles'
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 352
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.maze'
    FileName = '.maze'
    Filter = 
      'Socoban Level (*.maze)|*.maze|Socoban Scenario (*.ssn)|*.ssn|All' +
      ' files|*.*'
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 416
    Top = 72
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.maze'
    FileName = 'default.maze'
    Filter = 
      'Socoban Level (*.maze)|*.maze|Socoban Scenario (*.ssn)|*.ssn|All' +
      ' files|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 72
  end
end
