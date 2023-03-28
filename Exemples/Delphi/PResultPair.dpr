program PResultPair;

uses
  Vcl.Forms,
  UResultPair in 'UResultPair.pas' {Form1},
  result.pair.abstract in '..\..\Source\result.pair.abstract.pas',
  result.pair.br in '..\..\Source\result.pair.br.pas',
  result.pair.failure in '..\..\Source\result.pair.failure.pas',
  result.pair.success in '..\..\Source\result.pair.success.pas',
  UController in 'UController.pas',
  URepository in 'URepository.pas',
  UService in 'UService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
