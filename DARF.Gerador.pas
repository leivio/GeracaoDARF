unit DARF.Gerador;

interface

uses Windows, classes, SysUtils, Graphics, extctrls;

type

  RBarCode = record
    LinhaDigitavel: AnsiString;
    CodigoBarras: AnsiString;
    Image: TImage;
  end;

   TCodBar = class
   private
      FCodigo: AnsiString;
      function Define2de5: AnsiString;
      function GetImagem: TImage;
   public
      property Codigo: AnsiString  read fCodigo write fCodigo;
      property Imagem: TImage read GetImagem;
   end;

  TDARFCodigoBarras = class
  private
    class function CalculaMod10(ACodigo: string): Integer;
    class function StrToZero(const AString: string; ATamanho : Integer; AEsquerda: Boolean = true): string;
    class function iff(AExpressao: Boolean; ACasoVerdadeiro, ACasoFalso: variant): variant;
    class function FormatarValorToStr(AValor: Extended): AnsiString;
  public
    class function SomenteNumeros(const AString: string): AnsiString;
    class function Gerar(ACodigoReceita: AnsiString; ACodigoContribuinte: AnsiString; ADataVencimento,
      ADataApuracao: TDateTime; AValor: Extended): RBarCode;
  end;

implementation

{
85650000025-7 00000064105-0 30642754910-1 33029041059-7
  -> 8560000025000000641053064275491033029041059
85610000025-1 00000064105-0 70642754910-2 33029041059-7
  -> 8560000025000000641057064275491033029041059

codigo 2904
cnpj 64275491033
valo 2500
apuracao 28/02/2021
venc 22/02/2021
DARF RECEITA: 0064
Data vencimento: 1057 26/02/2021
Perido apuracao: 1059  28/02/2021

856 5 00000250000 0064 1053 064275491033 02904 1059

856 1 00000250000 0064 1057 064275491033 02904 1059
}

uses Dateutils;

{ TDARFCodigoBarras }

class function TDARFCodigoBarras.CalculaMod10(ACodigo: string): Integer;
var
  Codigo, valor, Totvalor, dig, Tx, Posidig : Integer;
begin
  Codigo := Length(ACodigo);
  valor := 0; Totvalor := 0; dig := 0; Tx := 2; Posidig := 1;
  while (Posidig <= Codigo) do begin
    valor := 0;
    valor := StrToInt(Copy(ACodigo,Posidig,1)) * Tx;
    if (valor > 9) then
      valor := StrToInt(Copy(IntToStr(valor),Length(IntToStr(valor))-1,1))+
                StrToInt(Copy(IntToStr(valor),Length(IntToStr(valor)),1));
    Totvalor := Totvalor + valor;
    Inc(Posidig);
    Tx := (Tx - 1);
    if (Tx < 1) then
      Tx := 2;
  end;
  dig := (10 - StrToInt(Copy(IntToStr(Totvalor),Length(IntToStr(Totvalor)),1)));
  if (dig = 10) then
    dig := 0;
  Result := dig;
end;


class function TDARFCodigoBarras.FormatarValorToStr(AValor: Extended): AnsiString;
begin
  Result :=  FormatFloat('0.00', AValor);
end;

class function TDARFCodigoBarras.Gerar(ACodigoReceita, ACodigoContribuinte: AnsiString; ADataVencimento, ADataApuracao: TDateTime;
  AValor: Extended): RBarCode;
const
  PRE = '856'; // 8 - Arrecadação | 5 - Órgãos Governamentais | 6 - - Valor a ser cobrado efetivamente em reais
  DATA_ZERO = 43196;
  ORGAO = '0064'; // 0064 - DARF IRRF | 0179 - FGTS | 0239 - FGTS Rescisório | 0328 - Simples Nacional
  CODIGO_RECEITA = '02904';
var
  Valor: AnsiString;
  Vencimento, Apuracao: Integer;
  CodigoContribuinte: AnsiString;
  Digito0: AnsiString;
  PreFor: AnsiString;
  PreFor1: AnsiString;
  PreFor2: AnsiString;
  PreFor3: AnsiString;
  PreFor4: AnsiString;

  CodigoDeBarras: TCodBar;
begin
  Valor       := StrToZero(SomenteNumeros(FormatarValorToStr(AValor)), 11);
  Vencimento  := DaysBetween(ADataVencimento, DATA_ZERO);
  Apuracao    := DaysBetween(ADataApuracao, DATA_ZERO);
  if Length(ACodigoContribuinte) = 14 then
    CodigoContribuinte := '1' + Copy(ACodigoContribuinte, 1, 12)
  else
    CodigoContribuinte := '0' + ACodigoContribuinte;

  PreFor := PRE + Valor + ORGAO + InttoStr(Vencimento) + CodigoContribuinte +
    StrToZero(ACodigoReceita, iff(Length(ACodigoContribuinte) = 11, 5, 4)) +
    InttoStr(Apuracao);
  Digito0 := IntToStr(CalculaMod10(PreFor));
  Insert(Digito0, PreFor, 4);
  PreFor1 := Copy(PreFor, 1, 11);
  PreFor1 := PreFor1 + '-' +IntToStr(CalculaMod10(PreFor1));
  PreFor2 := Copy(PreFor, 12, 11);
  PreFor2 := PreFor2 + '-' +IntToStr(CalculaMod10(PreFor2));
  PreFor3 := Copy(PreFor, 23, 11);
  PreFor3 := PreFor3 + '-' +IntToStr(CalculaMod10(PreFor3));
  PreFor4 := Copy(PreFor, 34, 11);
  PreFor4 := PreFor4 + '-' +IntToStr(CalculaMod10(PreFor4));

  Result.LinhaDigitavel := PreFor1 + ' ' + PreFor2 + ' ' + PreFor3 + ' ' + PreFor4;
  Result.CodigoBarras := PreFor;

  CodigoDeBarras := TCodBar.Create;
  try
    CodigoDeBarras.Codigo := PreFor;
    Result.Image := CodigoDeBarras.GetImagem;
    {$IFDEF DEBUG}
    Result.Image.Picture.SaveToFile('CodigoDeBarras.bmp');
    {$ENDIF}
  finally
    CodigoDeBarras.Free;
  end;
end;

class function TDARFCodigoBarras.iff(AExpressao: Boolean; ACasoVerdadeiro, ACasoFalso: variant): variant;
begin
  if AExpressao then
    Result := ACasoVerdadeiro
  else
    Result := ACasoFalso;
end;

class function TDARFCodigoBarras.SomenteNumeros(const AString: string): AnsiString;
var
  X: Integer;
begin
  Result := EmptyStr;
  for X := 1 to Length(AString) do
  begin
    if AString[X] in ['0'..'9'] then
      Result := Result + AString[X];
  end;
end;

class function TDARFCodigoBarras.StrToZero(const AString: string; ATamanho: Integer; AEsquerda: Boolean): string;
var
  Str: string;
begin
  Str := AString;
  while Length(Str) < ATamanho do
  begin
    if AEsquerda then
      Str := '0' + Str
    Else
      Str := Str + '0';
  end;
  Result := Str;
end;

{ TCodBar }

function TCodBar.Define2de5: AnsiString;
{Traduz dígitos do código de barras para valores de 0 e 1, formando um código do tipo Intercalado 2 de 5}
var
   CodigoAuxiliar : string;
   Start   : string;
   Stop    : string;
   T2de5   : array[0..9] of string;
   Codifi  : string;
   I       : integer;

begin
   Result := 'Erro';
   Start    := '0000';
   Stop     := '100';
   T2de5[0] := '00110';
   T2de5[1] := '10001';
   T2de5[2] := '01001';
   T2de5[3] := '11000';
   T2de5[4] := '00101';
   T2de5[5] := '10100';
   T2de5[6] := '01100';
   T2de5[7] := '00011';
   T2de5[8] := '10010';
   T2de5[9] := '01010';

   { Digitos }
   for I := 1 to length(Codigo) do
   begin
      if pos(Codigo[I],'0123456789') <> 0 then
         Codifi := Codifi + T2de5[StrToInt(Codigo[I])]
      else
         Exit;
   end;

   {Se houver um número ímpar de dígitos no Código, acrescentar um ZERO no início}
   if odd(length(Codigo)) then
      Codifi := T2de5[0] + Codifi;

   {Intercalar números - O primeiro com o segundo, o terceiro com o quarto, etc...}
   I := 1;
   CodigoAuxiliar := '';
   while I <= (length(Codifi) - 9)do
   begin
      CodigoAuxiliar := CodigoAuxiliar + Codifi[I] + Codifi[I+5] + Codifi[I+1] + Codifi[I+6] + Codifi[I+2] + Codifi[I+7] + Codifi[I+3] + Codifi[I+8] + Codifi[I+4] + Codifi[I+9];
      I := I + 10;
   end;

   { Acrescentar caracteres Start e Stop }
   Result := Start + CodigoAuxiliar + Stop;
end;

function TCodBar.GetImagem: TImage;
const
   CorBarra           = clBlack;
   CorEspaco          = clWhite;
   LarguraBarraFina   = 1; //1;
   LarguraBarraGrossa = 3; //3;
   //AlturaBarra        = 50;
   AlturaBarra        = 50;
var
   X            : integer;
   Col          : integer;
   Lar          : integer;
   CodigoAuxiliar : string;
begin
   CodigoAuxiliar := Define2de5;
   Result := TImage.Create(nil);
   Result.Height := AlturaBarra;
   Result.Width := 0;
   For X := 1 to Length(CodigoAuxiliar) do
      case CodigoAuxiliar[X] of
         '0' : Result.Width := Result.Width + LarguraBarraFina;
         '1' : Result.Width := Result.Width + LarguraBarraGrossa;
      end;

   Col    := 0;

   if CodigoAuxiliar <> 'Erro' then
   begin
      for X := 1 to length(CodigoAuxiliar) do
      begin
         {Desenha barra}
         with Result.Canvas do
         begin
            if Odd(X) then
               Pen.Color := CorBarra
            else
               Pen.Color := CorEspaco;

            if CodigoAuxiliar[X] = '0' then
            begin
               for Lar := 1 to LarguraBarraFina do
               begin
                  MoveTo(Col,0);
                  LineTo(Col,AlturaBarra);
                  Col := Col + 1;
               end;
            end
            else
            begin
               for Lar := 1 to LarguraBarraGrossa do
               begin
                  MoveTo(Col,0);
                  LineTo(Col,AlturaBarra);
                  Col := Col + 1;
               end;
            end;
         end;
      end;
   end
   else
      Result.Canvas.TextOut(0,0,'Erro');
end;

end.
