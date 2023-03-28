unit UController;

interface

uses
  Classes,
  SysUtils,
  Threading,

  URepository,
  result.pair.br;

type
  TThreadObserver = procedure(AValue: String) of object;

  TController = class
  private
    FRepository: TRepository;
    FThreadObserver: TThreadObserver;
    function MapValue(AValue: String): String;
  public
    constructor Create;
    destructor Destroy; override;
    function Success: String;
    function Failure: String;
    function FutureAwait: String;
    procedure FutureNoAwait;

    property OnThreadObserver: TThreadObserver read FThreadObserver write FThreadObserver;
  end;

implementation

{ TController }

constructor TController.Create;
begin
  FRepository := TRepository.Create;
end;

destructor TController.Destroy;
begin
  FRepository.Free;
  inherited;
end;

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

function TController.FutureAwait: String;
var
  LResult: IFuture<TResultPair>;
  LMessage: String;
begin
  Result := '';
  LMessage := '';

  LResult := TTask.Future<TResultPair>(FRepository.fetchProductsFuture);
  try
    LResult.Value.TryException(
      procedure
      begin
        LMessage := LResult.Value.ValueSuccess;
      end,
      procedure
      begin
        LMessage := LResult.Value.ValueFailure.Message;
      end
    );
  finally
    // Libera o tipo TResultPair que é criado internamente
    LResult.Value.Free;
    // Libera o TTask.Future<>
    LResult := nil;
  end;
  Result := LMessage;
end;

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

function TController.MapValue(AValue: String): String;
begin
  Result := Format('Map() - %s', [AValue]);
end;

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

end.
