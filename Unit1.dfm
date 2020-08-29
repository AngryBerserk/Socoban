object Form1: TForm1
  Left = 224
  Top = 210
  Width = 783
  Height = 540
  Caption = 'Socoban'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 467
    Width = 775
    Height = 19
    Panels = <>
  end
  object ScrollBar1: TScrollBar
    Left = 0
    Top = 450
    Width = 775
    Height = 17
    Align = alBottom
    PageSize = 0
    TabOrder = 1
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 758
    Top = 0
    Width = 17
    Height = 450
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 2
    OnChange = ScrollBar2Change
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 168
    object Game1: TMenuItem
      Caption = 'Game'
      object New1: TMenuItem
        Caption = 'New'
      end
      object Quit1: TMenuItem
        Caption = 'Quit'
        OnClick = Quit1Click
      end
    end
    object Pref1: TMenuItem
      Caption = 'Pref'
      object LoadSkin1: TMenuItem
        Caption = 'Load Skin'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
    end
  end
  object Timer1: TTimer
    Enabled = False
  end
  object AniTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = AniTimerTimer
    Left = 32
  end
end
