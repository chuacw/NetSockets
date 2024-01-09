object frmSocketClient: TfrmSocketClient
  Left = 2065
  Top = 861
  Margins.Left = 7
  Margins.Top = 7
  Margins.Right = 7
  Margins.Bottom = 7
  Caption = 'Socket Client'
  ClientHeight = 1003
  ClientWidth = 1429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 216
  TextHeight = 37
  object Button1: TButton
    Left = 1152
    Top = 846
    Width = 169
    Height = 57
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    Caption = 'Send'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 12
    Top = 684
    Width = 1303
    Height = 45
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    TabOrder = 1
    Text = #12362#12399#12424#12358
  end
  object Memo1: TMemo
    Left = 18
    Top = 18
    Width = 1387
    Height = 595
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    TabOrder = 2
  end
end
