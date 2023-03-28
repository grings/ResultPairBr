[![ResultPairBr Framework](https://github.com/HashLoad/ResultPairBr/blob/develop/Images/resultpair_fluxo.png)](https://www.isaquepinheiro.com.br)
<p align="right" width="50%">
    <a href="https://pag.ae/bglQrWD"><img src="https://www.isaquepinheiro.com.br/imagens/doepagueseguro.png"> 
</p>

# ResultPairBr Framework for Delphi   [![License](https://img.shields.io/badge/Licence-LGPL--3.0-blue.svg)](https://opensource.org/licenses/LGPL-3.0)
ResultPair Brasil - Either Result for Delphi

# :hammer: Recursos de para caputra o reorno duplo :

:heavy_check_mark: `Recurso 1`: ```TResultPairBr<String, Exception>``` para (Definição do retorno duplo)

:heavy_check_mark: `Recurso 2`: ```TResultPairBr<String, Exception>.TryException<String>``` para (Captura do retorno duplo)

:heavy_check_mark: `Recurso 3`: ```TResultPairBr<String, Exception>.Map(MapValue).TryException<String>``` para (Operações antes do retono duplo)

### Instalação ###
O ResultPairBr não precisa ser instalado, basta adicionar as units no seu projeto e começar a usa-lo.

### Requisitos ###
Embarcadero Delphi XE e superior.

### Versão Atual ###
0.2023.3.28 (28 Mar 2023)

Copyright (c) 2023 ResultPairBr Framework Team

# Como usar ?

## Modelo 1 de uso

```Delphi
function TController.Failure: String;
var
  LResult: TResultPair;
  LMessage: String;
begin
  Result := '';

  LResult := FRepository.fetchProductsFailure;
  try
    if LResult.isSuccess() then
      LMessage := LResult.ValueSuccess
    else
    if LResult.isFailure() then
      LMessage := LResult.ValueFailure.Message;

    Result := LMessage;
  finally
    LResult.Free;
  end;
end;

...

function TRepository.fetchProductsFailure: TResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsFailure;
    Result := TResultPair.Success('Success!');
  except
    Result := TResultPair.Failure(Exception.Create('Failure!'));
  end;
end;

...

function TService.fetchProductsFailure: String;
var
  LNumero: Double;
begin
  // Forçando erro só para testar.
  LNumero := 150;
  if ((LNumero < 0) or (LNumero > 100)) then
    raise Exception.Create('');

  Result := 'Result';
end;
```
## Modelo 2 de uso

```Delphi
function TController.Success: String;
var
  LResult: TResultPair;
  LMessage: String;
begin
  Result := '';
  LResult := FRepository.fetchProductsSuccess;
  try
    LMessage := LResult.TryException<String>(
      function: String
      begin
        Result := LResult.ValueSuccess;
      end,
      function: String
      begin
        Result := LResult.ValueFailure.Message;
      end
    );
    Result := LMessage;
  finally
    LResult.Free;
  end;
end;

...

function TRepository.fetchProductsSuccess: TResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsSuccess;
    Result := TResultPair.Success('Success!');
  except
    Result := TResultPair.Failure(Exception.Create('Failure!'));
  end;
end;
```
## Modelo 3 de uso com Thread
```Delphi
procedure TController.FutureNoAwait;
var
  LResult: IFuture<TResultPair>;
  LMessage: String;
begin
  LMessage := '';

  TThread.CreateAnonymousThread(
  procedure
  begin
    LResult := TTask.Future<TResultPair>(FRepository.fetchProductsFuture);
    try
      LMessage := LResult.Value.Map(MapValue).TryException<String>(
        function: String
        begin
          Result := LResult.Value.ValueSuccess;
        end,
        function: String
        begin
          Result := LResult.Value.ValueFailure.Message;
        end
      );
      TThread.Queue(nil,
        procedure
        begin
          if Assigned(FThreadObserver) then
            FThreadObserver(LMessage);
        end);
    finally
      // Libera o tipo TResultPair que é criado internamente ao TTask
      LResult.Value.Free;
      // Libera o TTask.Future<>
      LResult := nil;
    end;
  end
  ).Start;
end;

...

function TRepository.fetchProductsFuture: TResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsFuture;
    Result := TResultPair.Success('Success Future!');
  except
    Result := TResultPair.Failure(Exception.Create('Failure Future!'));
  end;
end;
```