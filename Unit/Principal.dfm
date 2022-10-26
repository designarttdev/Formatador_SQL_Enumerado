object frPrincipal: TfrPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Converter Script'
  ClientHeight = 732
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 794
    Height = 468
    Align = alClient
    TabOrder = 0
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 380
      Height = 446
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      CharCase = ecUpperCase
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object Memo2: TMemo
      AlignWithMargins = True
      Left = 403
      Top = 11
      Width = 380
      Height = 446
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      CharCase = ecUpperCase
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 468
    Width = 794
    Height = 71
    Align = alBottom
    TabOrder = 1
    object btnRemoverFormatacao: TButton
      Left = 403
      Top = 1
      Width = 390
      Height = 69
      Align = alRight
      Caption = 'Remover Formata'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnRemoverFormatacaoClick
    end
    object btnFormatar: TButton
      Left = 1
      Top = 1
      Width = 390
      Height = 69
      Align = alLeft
      Caption = 'Transformar e Copiar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnFormatarClick
    end
  end
  object pnlQuery: TPanel
    Left = 0
    Top = 539
    Width = 794
    Height = 193
    Align = alBottom
    TabOrder = 2
    object Memo3: TMemo
      AlignWithMargins = True
      Left = 11
      Top = 51
      Width = 640
      Height = 126
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object btnCopiarQuery: TButton
      Left = 664
      Top = 51
      Width = 119
      Height = 126
      Margins.Top = 40
      Margins.Right = 10
      Margins.Bottom = 40
      Caption = 'Copiar Par'#226'metros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      WordWrap = True
      OnClick = btnCopiarQueryClick
    end
    object cbEmpresa: TComboBox
      Left = 168
      Top = 14
      Width = 483
      Height = 21
      Style = csDropDownList
      Enabled = False
      TabOrder = 2
      OnChange = cbEmpresaChange
    end
    object chkBancoMais: TCheckBox
      Left = 17
      Top = 16
      Width = 128
      Height = 17
      Caption = 'Banco Mais Solu'#231#245'es?'
      TabOrder = 3
      OnClick = chkBancoMaisClick
    end
  end
  object AdcBaseDados: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'DriverID=IB')
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 504
    Top = 192
  end
  object AdcEmpresa: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'DriverID=IB')
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 504
    Top = 248
  end
  object vQuery: TFDQuery
    Left = 504
    Top = 312
  end
end
