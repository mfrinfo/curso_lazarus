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

    function getCodigo: string;
    function getDescricao: string;
    procedure setCodigo(const Value: string);
    procedure setDescricao(const Value: string);
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar(id:string):Boolean;
    function Selecionar(id:string):Boolean;
  published
    property codigo:string    read getCodigo    write setCodigo;
    property descricao:string read getDescricao write setDescricao;
  end;

implementation

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
function TCategoria.Apagar(id:string): Boolean;
var Qry:TZQuery;
begin
  if MessageNoYes('Apagar o Registro: '+#13+#13+
                  'Código:    '+F_categoriaId +#13+
                  'Descrição: '+F_descricao,mtConfirmation)=mrNo then begin
     Result:=false;
     abort;
  end;

  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM categorias '+
                ' WHERE categoriaId=:categoriaId ');
    Qry.ParamByName('categoriaId').AsString :=id;
    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

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
    Qry.SQL.Add('UPDATE categorias '+
                '   SET descricao=:descricao '+
                ' WHERE categoriaId=:categoriaId ');
    Qry.ParamByName('categoriaId').AsString :=Self.F_categoriaId;
    Qry.ParamByName('descricao').AsString    :=Self.F_descricao;

    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

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
    Qry.SQL.Add('INSERT INTO categorias (categoriaId, descricao) values (:categoriaId, :descricao)');
    Qry.ParamByName('categoriaId').AsString :=GuidId;
    Qry.ParamByName('descricao').AsString :=Self.F_descricao;
    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TCategoria.Selecionar(id: string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT categoriaId, '+
                '       descricao '+
                '  FROM categorias '+
                ' WHERE categoriaId=:categoriaId');
    Qry.ParamByName('categoriaId').AsString:=id;
    Try
      Qry.Open;

      Self.F_categoriaId := Qry.FieldByName('categoriaId').AsString;
      Self.F_descricao   := Qry.FieldByName('descricao').AsString;
    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;
{$endregion}

{$region 'Gets'}
function TCategoria.getCodigo: string;
begin
  Result := Self.F_categoriaId;
end;

function TCategoria.getDescricao: string;
begin
  Result := Self.F_descricao;
end;
{$endregion}

{$region 'Sets'}
procedure TCategoria.setCodigo(const Value: string);
begin
  Self.F_categoriaId := Value;
end;

procedure TCategoria.setDescricao(const Value: string);
begin
  Self.F_descricao := Value;
end;
{$endregion}

end.

