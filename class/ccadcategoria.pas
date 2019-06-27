unit cCadCategoria;

{$mode objfpc}{$H+}

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     cBase,
     ZAbstractConnection,
     ZConnection,
     ZAbstractRODataset,
     ZAbstractDataset,
     ZDataset,
     SysUtils,
     uUtils;

type
  TCategoria = class(TBase)

  private
    F_categoriaId:String;
    F_descricao:String;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;

  published
    property categoriaId:String  read F_categoriaId write F_categoriaId;
    property descricao:String  read F_descricao write F_descricao;

end;

implementation

{TCategoria}

{$region 'Constructor and Destructor'}
constructor TCategoria.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TCategoria.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TCategoria.Apagar: Boolean;
var Qry:TZQuery;
begin
  if MessageNoYes('Apagar o Registro? ', mtConfirmation)=mrNo then begin
     Result:=false;
     abort;
  end;
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM categorias'+
                '      WHERE categoriaId=:categoriaId ');
    Qry.ParamByName('categoriaId').AsString := Self.F_categoriaId;
    try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result:=false;
    end;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TCategoria.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE categorias'+
                '    SET descricao=:descricao '+
                '      WHERE categoriaId=:categoriaId ');
    Qry.ParamByName('categoriaId').AsString := Self.F_categoriaId;
    Qry.ParamByName('descricao').AsString := Self.F_descricao;
    try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result:=false;
    end;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TCategoria.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO categorias ('+
                '      categoriaId'+
                '      ,descricao'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :categoriaId '+
                '      ,:descricao '+
                ')');
    Qry.ParamByName('categoriaId').AsString := GuidId;
    Qry.ParamByName('descricao').AsString := Self.F_descricao;
    try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result:=false;
    end;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;


function TCategoria.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      categoriaId '+
                '      ,descricao '+
                ' FROM categorias ' +
                'WHERE categoriaId=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_categoriaId := Qry.FieldByName('categoriaId').AsString;
    Self.F_descricao := Qry.FieldByName('descricao').AsString;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}
end.
