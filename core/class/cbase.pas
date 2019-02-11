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
  ZDataset,
  uUtils;

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
var Qry:TZQuery;
    sSelect:String;
begin
  Result:='';
  sSelect := ' SELECT UUID() AS UUID ';
  try
    try
      Qry:=TZQuery.Create(nil);
      Qry.Connection:=ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add(sSelect);
      Qry.Open;
      Result:=UpperCase(Qry.FieldByName('UUID').AsString);
    finally
      Qry.Close;
      if Assigned(Qry) then
         FreeAndNil(Qry);
    end;
  except
     Result := UpperCase(GuidCreate());
  end;

end;

destructor TBase.Destroy;
begin
  inherited Destroy;
end;

end.

