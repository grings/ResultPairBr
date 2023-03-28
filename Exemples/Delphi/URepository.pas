unit URepository;

interface

uses
  SysUtils,
  UService,
  result.pair.br;

type
  Success = String;
  Error = Exception;
  TResultPair = TResultPairBr<Success, Error>;

  TRepository = class
  private
    FService: TService;
  public
    constructor Create;
    destructor Destroy; override;

    function fetchProductsSuccess: TResultPair;
    function fetchProductsFailure: TResultPair;
    function fetchProductsFuture: TResultPair;
  end;

implementation

{ TRepository }

constructor TRepository.Create;
begin
  FService := TService.Create;
end;

destructor TRepository.Destroy;
begin
  FService.Free;
  inherited;
end;

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

function TRepository.fetchProductsFuture: TResultPair;
var
  LNumero: Double;
  LResult: String;
begin
  LNumero := 150;
  try
    LResult := FService.fetchProductsFuture;
    Result := TResultPair.Success('Success Future!');
  except
    Result := TResultPair.Failure(Exception.Create('Failure Future!'));
  end;
end;

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

end.
