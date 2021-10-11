object Form1: TForm1
  Left = 217
  Top = 127
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'GenTone'
  ClientHeight = 410
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 16
    Caption = 'Volume'
  end
  object Label2: TLabel
    Left = 8
    Top = 80
    Width = 64
    Height = 16
    Caption = 'Frequency'
  end
  object PaintBoxSgnl: TPaintBox
    Left = 8
    Top = 152
    Width = 801
    Height = 217
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 32
    Width = 809
    Height = 41
    Max = 100
    Min = 1
    Position = 25
    TabOrder = 0
    TickMarks = tmBoth
    OnChange = ChangeToneClick
  end
  object TrackBar2: TTrackBar
    Left = 8
    Top = 104
    Width = 809
    Height = 41
    Max = 100
    Min = 1
    Position = 10
    TabOrder = 1
    TickMarks = tmBoth
    OnChange = ChangeToneClick
  end
  object Button1: TButton
    Left = 8
    Top = 376
    Width = 537
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 552
    Top = 376
    Width = 257
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    OnClick = button2click
  end
end
