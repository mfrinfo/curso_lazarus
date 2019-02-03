unit cbase;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  cArquivoIni,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset;

type

  { TBase }

  TBase = class
  private
    F_ConexaoDB:TZConnection;
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
    Qry:TZQuery;
    sSelect:String;
begin
  Result:='';
  sTipoDB:=TArquivoIni.TipoDataBase;
  if sTipoDB='MYSQL' then begin
    sSelect := ' SELECT UUID() AS UUID'
  end
  else if sTipoDB = 'FIREBIRD' then begin
    sSelect := ' select gen_uuid() AS UUID from rdb$database  '
  end
  else
    sSelect := ' SELECT UUID() AS UUID ';

  Try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(sSelect);
    Qry.Open;
    Result:=Qry.FieldByName('UUID').AsString;
  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  End;
end;

destructor TBase.Destroy;
begin
  inherited Destroy;
end;

end.

