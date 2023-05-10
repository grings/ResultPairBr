{
         ResultPair - Result Multiple for Delphi/Lazarus


                   Copyright (c) 2023, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(ResultPair)
  @created(28 Mar 2023)
  @author(Isaque Pinheiro <isaquesp@gmail.com>)
  @author(Site : https://www.isaquepinheiro.com.br)
}

unit result.pair;

interface

uses
  Rtti,
  TypInfo,
  Classes,
  SysUtils;

type
  TResultType = (rtSuccess, rtFailure);

  TResultPair<S, F> = record
  private
    FResultType: TResultType;
    FSuccess: S;
    FFailure: F;
    type
      TMapFunc<R> = reference to function(
        const ASelf: TResultPair<S, F>): R;
  public
    procedure Success(const ASuccess: S);
    procedure Failure(const AFailure: F);
    procedure DestroySuccess;
    procedure DestroyFailure;
    // Map()
    function Map(const ASuccessFunc: TFunc<S, S>;
      const AFailureFunc: TFunc<F, F>): TResultPair<S, F>; //overload;
    // TryException<R>() - Function
    function TryException<R>(const ASuccess: TMapFunc<R>;
      const AFailure: TMapFunc<R>): R; overload;
    // TryException() - Procedure
    procedure TryException(const ASuccess: TProc;
      const AFailure: TProc); reintroduce; overload;
    function isSuccess: boolean;
    function isFailure: boolean;
    function ValueSuccess: S;
    function ValueFailure: F;
  end;

implementation

{ TResultPairBr<S, F> }

procedure TResultPair<S, F>.DestroySuccess;
var
  LTypeInfo: PTypeInfo;
  LObject: TValue;
begin
  LTypeInfo := TypeInfo(F);
  if LTypeInfo.Kind = tkClass then
  begin
    LObject := TValue.From<F>(FFailure);
    LObject.AsObject.Free;
  end;
end;

procedure TResultPair<S, F>.DestroyFailure;
var
  LTypeInfo: PTypeInfo;
  LObject: TValue;
begin
  LTypeInfo := TypeInfo(F);
  if LTypeInfo.Kind = tkClass then
  begin
    LObject := TValue.From<F>(FFailure);
    LObject.AsObject.Free;
  end;
end;

procedure TResultPair<S, F>.Failure(const AFailure: F);
begin
  FFailure := AFailure;
  FResultType := TResultType.rtFailure;
end;

procedure TResultPair<S, F>.Success(const ASuccess: S);
begin
  FSuccess := ASuccess;
  FResultType := TResultType.rtSuccess;
end;

function TResultPair<S, F>.Map(const ASuccessFunc: TFunc<S, S>;
  const AFailureFunc: TFunc<F, F>): TResultPair<S, F>;
begin
  if Assigned(ASuccessFunc) then
    FSuccess := ASuccessFunc(FSuccess);
  if Assigned(AFailureFunc) then
    FFailure := AFailureFunc(FFailure);
  Result := Self;
end;

function TResultPair<S, F>.isFailure: boolean;
begin
  Result :=  FResultType = TResultType.rtFailure;
end;

function TResultPair<S, F>.isSuccess: boolean;
begin
  Result :=  FResultType = TResultType.rtSuccess;
end;

procedure TResultPair<S, F>.TryException(const ASuccess: TProc;
  const AFailure: TProc);
begin
  if Self.isSuccess then ASuccess
  else
  if Self.isFailure then AFailure;
end;

function TResultPair<S, F>.TryException<R>(const ASuccess: TMapFunc<R>;
  const AFailure: TMapFunc<R>): R;
begin
  if Self.isSuccess then Result := ASuccess(Self)
  else
  if Self.isFailure then Result := AFailure(Self);
end;

function TResultPair<S, F>.ValueFailure: F;
begin
  Result := FFailure;
end;

function TResultPair<S, F>.ValueSuccess: S;
begin
  Result := FSuccess;
end;

end.

