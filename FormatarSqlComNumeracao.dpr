program FormatarSqlComNumeracao;

uses
  Vcl.Forms,
  Principal in 'Unit\Principal.pas' {frPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
