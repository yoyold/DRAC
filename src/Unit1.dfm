object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 516
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 709
    Height = 516
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = 632
    ExplicitTop = 168
    ExplicitWidth = 185
    ExplicitHeight = 41
    object BitBtn1: TBitBtn
      Left = 32
      Top = 22
      Width = 105
      Height = 34
      Caption = 'Send Request'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object Memo1: TMemo
      Left = 32
      Top = 72
      Width = 641
      Height = 409
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
    end
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 480
    Top = 288
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 480
    Top = 192
  end
end
