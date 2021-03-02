unit ufrDARF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TfrDARF = class(TForm)
    edNome: TEdit;
    edTelefone: TMaskEdit;
    edPA: TMaskEdit;
    edCPFCNPJ: TMaskEdit;
    edCodigoReceita: TMaskEdit;
    edValor: TMaskEdit;
    edDataVencimento: TMaskEdit;
    edReferencia: TMaskEdit;
    edValorTotal: TMaskEdit;
    edJuros: TMaskEdit;
    edMulta: TMaskEdit;
    mmoObservacao: TMemo;
    Button1: TButton;
    ActionList1: TActionList;
    actImprimir: TAction;
    actCancelar: TAction;
    actDesfazer: TAction;
    actCalculadora: TAction;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    rdgOpcaoBarras: TRadioGroup;
    procedure actImprimirExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actDesfazerExecute(Sender: TObject);
    procedure actCalculadoraExecute(Sender: TObject);
  private
    procedure LimparTudo;
    procedure Imprimir;
  public
    procedure AfterConstruction; override;
  end;

var
  frDARF: TfrDARF;

implementation

{$R *.dfm}

uses unRelDARF2, DARF.Gerador, Contnrs;

{ TfrDARF }

procedure TfrDARF.actCalculadoraExecute(Sender: TObject);
begin
  WinExec('calc.exe', SW_NORMAL);
end;

procedure TfrDARF.actCancelarExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrDARF.actDesfazerExecute(Sender: TObject);
begin
  LimparTudo;
end;

procedure TfrDARF.actImprimirExecute(Sender: TObject);
begin
  Imprimir;
end;

procedure TfrDARF.AfterConstruction;
begin
  inherited;
  {$IFDEF DEBUG}
  edNome.Text           := 'Maria do Carmo da Silva';
  edTelefone.Text       := '8525361425';
  edPA.Text             := '28/02/2021';
  edCPFCNPJ.Text        := '66342797000113';
  edCodigoReceita.Text  := '0211';
  edDataVencimento.Text := '18/03/2021';
  edValor.Text          := '123,49';
  edMulta.Text          := '0,00';
  edJuros.Text          := '0,00';
  edValorTotal.Text     := '123,49';
  {$ENDIF}
end;



procedure TfrDARF.LimparTudo;
begin
  edNome.Text           := EmptyStr;
  edTelefone.Text       := EmptyStr;
  edPA.Text             := EmptyStr;
  edCPFCNPJ.Text        := EmptyStr;
  edCodigoReceita.Text  := EmptyStr;
  edDataVencimento.Text := EmptyStr;
  edValor.Text          := EmptyStr;
  edMulta.Text          := EmptyStr;
  edJuros.Text          := EmptyStr;
  edValorTotal.Text     := EmptyStr;
end;

procedure TfrDARF.Imprimir;
var
  Dados: TInfoDadosDARF;
  Objs: TObjectList;
  BarCode: RBarCode;
begin
  Dados := TInfoDadosDARF.Create;
  Dados.NomeEmpresa := edNome.Text;
  Dados.DataFinal := StrToDate(edPA.Text);
  Dados.CNPJ := edCPFCNPJ.Text;
  Dados.CodigoDoPagamento := edCodigoReceita.Text;
  Dados.DataVencimento := StrtoDate(edDataVencimento.Text);
  Dados.Valor := StrToFloat(edValor.Text);
  Dados.Observacoes := 'Tel. ' + edTelefone.Text;
  if rdgOpcaoBarras.ItemIndex = 0 then
  begin
    BarCode :=  TDARFCodigoBarras.Gerar( Dados.CodigoDoPagamento,
                                         Dados.CNPJ,
                                         Dados.DataVencimento,
                                         Dados.DataFinal,
                                         Dados.Valor);
    dados.CodigoBarras := BarCode.CodigoBarras;
    dados.CodigoBarrasText := BarCode.LinhaDigitavel;
  end;
  Objs := TObjectList.Create(True);
  try
    Objs.Add(Dados);
    with TfmRelDARF.Create(Objs, nil) do
    try
      RLReport.Preview;
    finally
      Free;
    end;
  finally
    Objs.Free;
  end;
end;

end.
