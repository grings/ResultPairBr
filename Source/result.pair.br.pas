unit result.pair.br;

interface

uses
  Classes,
  SysUtils,
  Threading,
  result.pair.abstract;

type
  TResultPairBr<S, F> = class(TResultPairAbstract<S, F>)
  protected
    FSuccess: S;
    FFailure: F;
  public
    class function Success(ASuccess: S): TResultPairBr<S, F>;
    class function Failure(AFailure: F): TResultPairBr<S, F>;
    // Map() - Success
    function Map(AFunc: TFunc<S, S>): TResultPairBr<S, F>; overload;
    // Map() - Failure
    function Map(AFunc: TFunc<F, F>): TResultPairBr<S, F>; reintroduce; overload;
    // TryException<R>() - Function
    function TryException<R>(ASuccess: TFunc<R>; AFailure: TFunc<R>): R; overload;
    // TryException() - Procedure
    procedure TryException(ASuccess: TProc; AFailure: TProc); reintroduce; overload;
  end;

implementation

uses
  result.pair.failure,
  result.pair.success;

{ TResultPairBrBr<S, F> }

class function TResultPairBr<S, F>.Failure(AFailure: F): TResultPairBr<S, F>;
begin
  Result := TResultFailure<S, F>.Create(AFailure);
end;

function TResultPairBr<S, F>.Map(AFunc: TFunc<S, S>): TResultPairBr<S, F>;
begin
  FSuccess := AFunc(FSuccess);
  Result := Self;
end;

function TResultPairBr<S, F>.Map(AFunc: TFunc<F, F>): TResultPairBr<S, F>;
begin
  FFailure := AFunc(FFailure);
  Result := Self;
end;

class function TResultPairBr<S, F>.Success(ASuccess: S): TResultPairBr<S, F>;
begin
  Result := TResultSuccess<S, F>.Create(ASuccess);
end;

procedure TResultPairBr<S, F>.TryException(ASuccess: TProc;
  AFailure: TProc);
begin
  if Self.isSuccess then ASuccess
  else
  if Self.isFailure then AFailure;
end;

function TResultPairBr<S, F>.TryException<R>(ASuccess: TFunc<R>;
  AFailure: TFunc<R>): R;
begin
  if Self.isSuccess then Result := ASuccess
  else
  if Self.isFailure then Result := AFailure;
end;

end.
