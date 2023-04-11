unit result.pair.abstract;

interface

uses
  SysUtils;

type
  TResultPairAbstract<S, F> = class abstract
  public
    function isSuccess: boolean; virtual; abstract;
    function isFailure: boolean; virtual; abstract;
    function ValueSuccess: S; virtual; abstract;
    function ValueFailure: F; virtual; abstract;

  end;

implementation

end.
