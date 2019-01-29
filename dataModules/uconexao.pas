unit uConexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection;

type

  { TdtmPrincipal }

  TdtmPrincipal = class(TDataModule)
    ConDataBase: TZConnection;
    ZConnection1: TZConnection;
  private

  public

  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{$R *.lfm}

end.

