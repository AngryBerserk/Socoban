object AboutBox: TAboutBox
  Left = 386
  Top = 360
  BorderStyle = bsDialog
  Caption = 'About `Socoban`'
  ClientHeight = 146
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Comic Sans MS'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 23
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 281
    Height = 97
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 16
      Top = 16
      Width = 62
      Height = 23
      Caption = 'Socoban'
      IsControl = True
    end
    object Version: TLabel
      Left = 104
      Top = 40
      Width = 90
      Height = 23
      Caption = 'Version 1.1'
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 72
      Width = 236
      Height = 16
      Caption = #174' 2006. Angry Berserk. All rights reserved'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      IsControl = True
    end
  end
  object OKButton: TButton
    Left = 111
    Top = 116
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
