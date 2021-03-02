unit unRelDARF2;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, MaskUtils,
  StdCtrls, ExtCtrls, Forms, Db, Uni, DBAccess, MemDS, Variants, Contnrs, RLReport, RLBarcode, dxGDIPlusClasses;

type

  TInfoDadosDARF = class
  private
    FValor: Extended;
    FCodigoDoPagamento: string;
    FCodigoBarras: string;
    FNomeEmpresa: string;
    FCNPJ: string;
    FDataVencimento: TDateTime;
    FDataFinal: TDateTime;
    FObservacoes: string;
    FPracaReceimento: string;
    FCodigoBarrasText: string;
  published
    property CNPJ: string read FCNPJ write FCNPJ;
    property NomeEmpresa: string read FNomeEmpresa write FNomeEmpresa;
    property DataFinal: TDateTime read FDataFinal write FDataFinal;
    property CodigoDoPagamento: string read FCodigoDoPagamento write FCodigoDoPagamento;
    property DataVencimento: TDateTime read FDataVencimento write FDataVencimento;
    property Valor: Extended read FValor write FValor;
    property CodigoBarras: string read FCodigoBarras write FCodigoBarras;
    property Observacoes: string read FObservacoes write FObservacoes;
    property PracaReceimento: string read FPracaReceimento write FPracaReceimento;
    property CodigoBarrasText: string read FCodigoBarrasText write FCodigoBarrasText;
  end;

  TfmRelDARF = class(TForm)
    RLReport: TRLReport;
    RLBand1: TRLBand;
    QRLabel22: TRLLabel;
    RLBand2: TRLBand;
    QRImage3: TRLImage;
    qrCodigoBarrasTexto: TRLLabel;
    QRLabel11: TRLLabel;
    qlbNomeEmpresa: TRLLabel;
    qrl_data_apura: TRLLabel;
    qlbCNPJ: TRLLabel;
    QRLabel9: TRLLabel;
    QRLabel14: TRLLabel;
    QRLabel6: TRLLabel;
    QRLabel7: TRLLabel;
    QRLabel8: TRLLabel;
    QRLabel5: TRLLabel;
    dsLocal: TDataSource;
    RLLabel12: TRLLabel;
    RLDraw1: TRLDraw;
    RLBand3: TRLBand;
    RLImage1: TRLImage;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel13: TRLLabel;
    QRLabel1: TRLLabel;
    qrObservacoes: TRLLabel;
    qrCodigoBarras2: TRLBarcode;
    qrCodigoBarras: TRLBarcode;
    procedure qrCodigoBarrasTextoBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure qlbNomeEmpresaBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure QRLabel9BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure qlbCNPJBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure qrl_data_apuraBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure QRLabel5BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure QRLabel14BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure RLLabel12BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure qrCodigoBarras2BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
    procedure qrObservacoesBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
  private
     FPaginaAtual: Integer;
     FinfoDARF: TInfoDadosDARF;
     FinfoDARFS: TObjectList;
     FComCodigoBarras: Boolean;
  protected
     procedure SetInfoDARF(AinfoDARF: TInfoDadosDARF);
     procedure AfterScroll(ADataSet: TDataSet);
  public
     constructor Create(AinfoDARFS: TObjectList; ADataSet: TDataSet; AComCodigoBarras: Boolean = True); reintroduce;
  end;

implementation

{$R *.DFM}


function UltimoDia_Mes(Mdt: TDateTime) : TDateTime;
var
  ano, mes, dia: word;
  mDtTemp: TDateTime;
begin
  DecodeDate(mDt, ano, mes, dia);
  mDtTemp := (mDt - dia) + 33;
  Decodedate(mDtTemp, ano, mes, dia);
  Result := mDtTemp - dia;
end;

procedure TfmRelDARF.QRLabel5BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FormatFloat('##,##0.00', FinfoDARF.Valor);
end;

procedure TfmRelDARF.qrl_data_apuraBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := DateToStr(UltimoDia_Mes(FinfoDARF.DataFinal));
end;

procedure TfmRelDARF.QRLabel14BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
var
  DataVenc : Tdatetime;
begin
  DataVenc := FinfoDARF.DataVencimento;

  if (DayOfWeek(DataVenc) = 1) or (DayOfWeek(DataVenc)=7) then
   DataVenc := DataVenc - 1;

  if (DayOfWeek(DataVenc)=1) or (DayOfWeek(DataVenc)=7) then
   DataVenc := DataVenc - 1;

  AText := DateToStr(DataVenc);
end;

procedure TfmRelDARF.SetInfoDARF(AinfoDARF: TInfoDadosDARF);
begin
  FinfoDARF := AinfoDARF;
end;

procedure TfmRelDARF.qlbCNPJBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FormatMaskText('99.999.999/9999-99;0;_', FinfoDARF.CNPJ);
end;

procedure TfmRelDARF.QRLabel9BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.CodigoDoPagamento;
end;

procedure TfmRelDARF.qlbNomeEmpresaBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.NomeEmpresa;
end;

procedure TfmRelDARF.qrCodigoBarrasTextoBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.CodigoBarrasText;
end;

constructor TfmRelDARF.Create(AinfoDARFS: TObjectList; ADataSet: TDataSet; AComCodigoBarras: Boolean = True);
begin
  Inherited Create(nil);
  if Assigned(ADataSet) then
  begin
    ADataSet.AfterScroll := AfterScroll;
    dsLocal.DataSet := ADataSet;
  end;
  FPaginaAtual := 0;
  FinfoDARFS := AinfoDARFS;
  FComCodigoBarras := AComCodigoBarras;
  SetInfoDARF(TInfoDadosDARF(FinfoDARFS[0]));
  qrCodigoBarras.Caption := FinfoDARF.CodigoBarras;
  qrCodigoBarras2.Caption := FinfoDARF.CodigoBarras;
end;


procedure TfmRelDARF.AfterScroll(ADataSet: TDataSet);
begin
  if FPaginaAtual <= FinfoDARFS.Count - 1 then
    SetInfoDARF(TInfoDadosDARF(FinfoDARFS[FPaginaAtual]));
  Inc(FPaginaAtual);
end;

procedure TfmRelDARF.qrObservacoesBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.Observacoes;
end;

procedure TfmRelDARF.qrCodigoBarras2BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.FCodigoBarras;
end;

procedure TfmRelDARF.RLLabel12BeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  AText := FinfoDARF.PracaReceimento;
end;

end.
