unit result.pair.success;

interface

uses
  SysUtils,
  TypInfo,
  result.pair.br;

type
  TResultSuccess<S, F> = class(TResultPairBr<S, F>)
  protected
    constructor Create(AValue: S);
  public
    destructor Destroy; override;
    function isSuccess: boolean; override;
    function isFailure: boolean; override;
    function ValueSuccess: S; override;
    function ValueFailure: F; override;
  end;

implementation

{ TSuccess<S, F> }

constructor TResultSuccess<S, F>.Create(AValue: S);
begin
  FSuccess := AValue;
end;

function TResultSuccess<S, F>.ValueFailure: F;
begin
  raise Exception.Create('Not implemented in success!');
end;

destructor TResultSuccess<S, F>.Destroy;
var
  LTypeInfo: PTypeInfo;
begin
  LTypeInfo := TypeInfo(S);
  if LTypeInfo.Kind = tkClass then
    FreeAndNil(FSuccess);
  inherited;
end;

function TResultSuccess<S, F>.isFailure: boolean;
begin
  Result := false;
end;

function TResultSuccess<S, F>.isSuccess: boolean;
begin
 Result := true;
end;

function TResultSuccess<S, F>.ValueSuccess: S;
begin
  Result := FSuccess;
end;

end.
