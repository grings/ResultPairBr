unit result.pair.failure;

interface

uses
  SysUtils,
  TypInfo,
  result.pair.br;

type
  TResultFailure<S, F> = class(TResultPairBr<S, F>)
  protected
    constructor Create(AValue: F);
  public
    destructor Destroy; override;
    function isSuccess: boolean; override;
    function isFailure: boolean; override;
    function ValueSuccess: S; override;
    function ValueFailure: F; override;
  end;

implementation

{ TFailure<S, F> }

constructor TResultFailure<S, F>.Create(AValue: F);
begin
  FFailure := AValue;
end;

function TResultFailure<S, F>.ValueFailure: F;
begin
  Result := FFailure;
end;

destructor TResultFailure<S, F>.Destroy;
var
  LTypeInfo: PTypeInfo;
begin
  LTypeInfo := TypeInfo(F);
  if LTypeInfo.Kind = tkClass then
    FreeAndNil(FFailure);
  inherited;
end;

function TResultFailure<S, F>.isFailure: boolean;
begin
  Result := true;
end;

function TResultFailure<S, F>.isSuccess: boolean;
begin
  Result := false;
end;

function TResultFailure<S, F>.ValueSuccess: S;
begin
  raise Exception.Create('Not implemented in failure!');
end;

end.
