object frmMain: TfrmMain
  Left = 500
  Top = 270
  Width = 600
  Height = 300
  Caption = 'Jistary'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    580
    261)
  PixelsPerInch = 96
  TextHeight = 13
  object txtMain: TEdit
    Left = 0
    Top = 8
    Width = 560
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = txtMainChange
    OnKeyDown = txtMainKeyDown
  end
  object lbResults: TListBox
    Left = 8
    Top = 48
    Width = 564
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
  end
end
