program Project4;

uses
  Vcl.Forms,
  ufrDARF in 'ufrDARF.pas' {frDARF},
  unRelDARF2 in 'unRelDARF2.pas' {fmRelDARF},
  DARF.Gerador in 'DARF.Gerador.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrDARF, frDARF);
  Application.Run;
end.
