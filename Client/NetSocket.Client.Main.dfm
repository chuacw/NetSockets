object frmSocketClient: TfrmSocketClient
  Left = 2065
  Top = 861
  Margins.Left = 8
  Margins.Top = 8
  Margins.Right = 8
  Margins.Bottom = 8
  Caption = 'Socket Client'
  ClientHeight = 1114
  ClientWidth = 1588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -30
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 240
  TextHeight = 41
  object Button1: TButton
    Left = 1280
    Top = 940
    Width = 188
    Height = 63
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Caption = 'Send'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 13
    Top = 760
    Width = 1448
    Height = 49
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 1
    Text = 'Hello world!'
  end
  object Memo1: TMemo
    Left = 20
    Top = 20
    Width = 1541
    Height = 661
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 2
  end
end
