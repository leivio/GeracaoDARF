object frDARF: TfrDARF
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Preenchimento de DARF'
  ClientHeight = 282
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 21
    Width = 49
    Height = 13
    Caption = '01 - Nome'
  end
  object Label2: TLabel
    Left = 319
    Top = 21
    Width = 64
    Height = 13
    Caption = '01 - Telefone'
  end
  object Label3: TLabel
    Left = 20
    Top = 86
    Width = 85
    Height = 13
    Caption = '11 - Observa'#231#245'es'
  end
  object Label4: TLabel
    Left = 451
    Top = 39
    Width = 35
    Height = 13
    Caption = '02 - PA'
  end
  object Label5: TLabel
    Left = 451
    Top = 66
    Width = 76
    Height = 13
    Caption = '03 - CPF / CNPJ'
  end
  object Label6: TLabel
    Left = 451
    Top = 93
    Width = 80
    Height = 13
    Caption = '04 - C'#243'd Receita'
  end
  object Label7: TLabel
    Left = 451
    Top = 119
    Width = 74
    Height = 13
    Caption = '05 - Refer'#234'ncia'
  end
  object Label8: TLabel
    Left = 451
    Top = 146
    Width = 118
    Height = 13
    Caption = '06 - Data de Vencimento'
  end
  object Label9: TLabel
    Left = 451
    Top = 173
    Width = 103
    Height = 13
    Caption = '07 - Valor do Principal'
  end
  object Label10: TLabel
    Left = 451
    Top = 199
    Width = 90
    Height = 13
    Caption = '08 - Valor da Multa'
  end
  object Label11: TLabel
    Left = 451
    Top = 226
    Width = 90
    Height = 13
    Caption = '09 - Valor do Juros'
  end
  object Label12: TLabel
    Left = 451
    Top = 253
    Width = 73
    Height = 13
    Caption = '10 - Valor Total'
  end
  object edNome: TEdit
    Left = 20
    Top = 36
    Width = 293
    Height = 21
    TabOrder = 0
  end
  object edTelefone: TMaskEdit
    Left = 319
    Top = 36
    Width = 90
    Height = 21
    EditMask = '!\(99\)0000-0000;0;_'
    MaxLength = 13
    TabOrder = 1
    Text = ''
  end
  object edPA: TMaskEdit
    Left = 577
    Top = 36
    Width = 123
    Height = 21
    TabOrder = 2
    Text = ''
  end
  object edCPFCNPJ: TMaskEdit
    Left = 577
    Top = 63
    Width = 123
    Height = 21
    TabOrder = 3
    Text = ''
  end
  object edCodigoReceita: TMaskEdit
    Left = 577
    Top = 90
    Width = 123
    Height = 21
    TabOrder = 4
    Text = ''
  end
  object edValor: TMaskEdit
    Left = 577
    Top = 170
    Width = 122
    Height = 21
    TabOrder = 7
    Text = ''
  end
  object edDataVencimento: TMaskEdit
    Left = 577
    Top = 143
    Width = 122
    Height = 21
    EditMask = '!99/99/00;1;_'
    MaxLength = 8
    TabOrder = 6
    Text = '  /  /  '
  end
  object edReferencia: TMaskEdit
    Left = 577
    Top = 116
    Width = 123
    Height = 21
    TabStop = False
    Color = clBtnFace
    Enabled = False
    TabOrder = 5
    Text = ''
  end
  object edValorTotal: TMaskEdit
    Left = 577
    Top = 250
    Width = 123
    Height = 21
    TabOrder = 10
    Text = ''
  end
  object edJuros: TMaskEdit
    Left = 577
    Top = 223
    Width = 123
    Height = 21
    TabOrder = 9
    Text = ''
  end
  object edMulta: TMaskEdit
    Left = 577
    Top = 196
    Width = 123
    Height = 21
    TabOrder = 8
    Text = ''
  end
  object mmoObservacao: TMemo
    Left = 20
    Top = 102
    Width = 293
    Height = 57
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object Button1: TButton
    Left = 24
    Top = 250
    Width = 85
    Height = 21
    Action = actImprimir
    TabOrder = 13
  end
  object Button2: TButton
    Left = 128
    Top = 250
    Width = 85
    Height = 21
    Action = actCancelar
    TabOrder = 14
  end
  object Button3: TButton
    Left = 232
    Top = 250
    Width = 85
    Height = 21
    Action = actDesfazer
    TabOrder = 15
  end
  object Button4: TButton
    Left = 336
    Top = 250
    Width = 85
    Height = 21
    Action = actCalculadora
    TabOrder = 16
  end
  object rdgOpcaoBarras: TRadioGroup
    Left = 24
    Top = 205
    Width = 397
    Height = 30
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Com c'#243'digo de barras'
      'Sem c'#243'digo de barras')
    TabOrder = 12
  end
  object ActionList1: TActionList
    Left = 342
    Top = 90
    object actImprimir: TAction
      Caption = 'Imprimir'
      OnExecute = actImprimirExecute
    end
    object actCancelar: TAction
      Caption = 'Cancelar'
      OnExecute = actCancelarExecute
    end
    object actDesfazer: TAction
      Caption = 'Desfazer'
      OnExecute = actDesfazerExecute
    end
    object actCalculadora: TAction
      Caption = 'Calculadora'
      OnExecute = actCalculadoraExecute
    end
  end
end
