# GeracaoDARF
Geração de DARF com Código de Barras

Usando a Unit: DARF.Gerador

A geração do Código de Barras é bem simples:
type

  RBarCode = record
    LinhaDigitavel: AnsiString;
    CodigoBarras: AnsiString;
    Image: TImage;
  end;
  
var
  Dados: TInfoDadosDARF;
  Objs: TObjectList;
  BarCode: RBarCode;
begin  
     BarCode :=  TDARFCodigoBarras.Gerar( Dados.CodigoDoPagamento,
                                         Dados.CNPJ,
                                         Dados.DataVencimento,
                                         Dados.DataFinal,
                                         Dados.Valor);
    dados.CodigoBarras := BarCode.CodigoBarras;
    dados.CodigoBarrasText := BarCode.LinhaDigitavel;
end;

Retorno é um record "RBarCode" que contem:

- CodigoBarras [Código numerico da geração do codigo de barras]
- LinhaDigitavel [Linha digitavel]
- Image [Contem a imagem do código de barras em bmp]


Segue telas com Demonstração.

![Alt text](Imgs/Tela.png?raw=true "Tela de Demonstração")

![Alt text](Imgs/Darf.png?raw=true "Darf de Demonstração")
