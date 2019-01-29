unit cbase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, cArquivoIni;

type

  { TBase }

  TBase = class
  private
    F_ConexaoDB:TZConnection;
    F_GuidId:String;
    function getGuidId: String;

  public
    destructor Destroy; override;
  protected
    property ConexaoDB :TZConnection    read F_ConexaoDB     write F_ConexaoDB;
    property GuidId:String              read getGuidId;
  end;

implementation

{ TUsuario }

function TBase.getGuidId: String;
var sTipoDB:String;
begin
  sTipoDB:=TArquivoIni.TipoDataBase;
  if sTipoDB='MYSQL' then begin
    Result := ' UUID() '
  end
  else if sTipoDB = 'FIREBIRD' then begin
    Result := ' (select gen_uuid() from rdb$database) '
  end
  else
    Result := ' UUID() ';
end;


destructor TBase.Destroy;
begin
  inherited Destroy;
end;

end.

