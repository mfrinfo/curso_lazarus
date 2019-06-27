unit cCadProduto;

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
     graphics,
     db,
     uEnum,
     uUtils;

type
  TProduto = class(TBase)

  private
    F_produtoId:String;
    F_descricao:String;
    F_gtin:String;
    F_valorVenda:Double;
    F_qtdeEstoque:Double;
    F_dataUltimaCompra:TDateTime;
    F_Foto:TBitmap;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;
    function GTINExiste(aCodigo:string; aProdutoId:string; aEstadoDoCadastro:TEstadoDoCadastro): Boolean;

  published
    property produtoId:String  read F_produtoId write F_produtoId;
    property descricao:String  read F_descricao write F_descricao;
    property gtin:String  read F_gtin write F_gtin;
    property valorVenda:Double  read F_valorVenda write F_valorVenda;
    property qtdeEstoque:Double  read F_qtdeEstoque write F_qtdeEstoque;
    property dataUltimaCompra:TDateTime  read F_dataUltimaCompra write F_dataUltimaCompra;
    property foto:TBitmap read F_Foto  write F_Foto;

end;

implementation

{TProduto}

{$region 'Constructor and Destructor'}
constructor TProduto.Create(aConexao:TZConnection);
begin
  ConexaoDB:= aConexao;
  F_Foto   := TBitmap.Create;
  F_Foto.Assign(nil);
end;

destructor TProduto.Destroy;
begin
  if Assigned(F_Foto) then begin
    F_Foto.Assign(nil);
    F_Foto.Free;
  end;

  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TProduto.Apagar: Boolean;
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
    Qry.SQL.Add('DELETE FROM produtos'+
                '      WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsString := Self.F_produtoId;
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

function TProduto.Atualizar: Boolean;
var Qry:TZQuery;
    MS:TMemoryStream;
begin
  try
    MS := TMemoryStream.Create;

    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE produtos'+
                '    SET descricao=:descricao '+
                '       ,gtin=:gtin '+
                '       ,valorVenda=:valorVenda '+
                '       ,qtdeEstoque=:qtdeEstoque '+
                '       ,dataUltimaCompra=:dataUltimaCompra '+
                '       ,foto=:foto '+
                '      WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsString := Self.F_produtoId;
    Qry.ParamByName('descricao').AsString := Self.F_descricao;
    Qry.ParamByName('gtin').AsString := Self.F_gtin;
    Qry.ParamByName('valorVenda').AsFloat := Self.F_valorVenda;
    Qry.ParamByName('qtdeEstoque').AsFloat := Self.F_qtdeEstoque;
    Qry.ParamByName('dataUltimaCompra').AsDateTime := Self.F_dataUltimaCompra;

    if Self.F_Foto.Empty then
       Qry.ParamByName('foto').Clear
    else begin
      Self.F_Foto.SaveToStream(MS);
      Qry.ParamByName('foto').LoadFromStream(MS, ftBlob);
    end;

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

   if Assigned(MS) then
      MS.free;
  end;
end;

function TProduto.Inserir: Boolean;
var Qry:TZQuery;
    MS:TMemoryStream;
begin
  try
    MS := TMemoryStream.Create;
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO produtos ('+
                '      produtoId'+
                '      ,descricao'+
                '      ,gtin'+
                '      ,valorVenda'+
                '      ,qtdeEstoque'+
                '      ,dataUltimaCompra'+
                '      ,foto '+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :produtoId '+
                '      ,:descricao '+
                '      ,:gtin '+
                '      ,:valorVenda '+
                '      ,:qtdeEstoque '+
                '      ,:dataUltimaCompra '+
                '      ,:foto '+
                ')');
    Qry.ParamByName('produtoId').AsString := GuidId;
    Qry.ParamByName('descricao').AsString := Self.F_descricao;
    Qry.ParamByName('gtin').AsString := Self.F_gtin;
    Qry.ParamByName('valorVenda').AsFloat := Self.F_valorVenda;
    Qry.ParamByName('qtdeEstoque').AsFloat := Self.F_qtdeEstoque;
    Qry.ParamByName('dataUltimaCompra').AsDateTime := Self.F_dataUltimaCompra;
    if Self.F_Foto.Empty then
       Qry.ParamByName('foto').Clear
    else begin
      Self.F_Foto.SaveToStream(MS);
      Qry.ParamByName('foto').LoadFromStream(MS, ftBlob);
    end;

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

   if Assigned(MS) then
      MS.free;
  end;
end;
function TProduto.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      produtoId '+
                '      ,descricao '+
                '      ,gtin '+
                '      ,valorVenda '+
                '      ,qtdeEstoque '+
                '      ,dataUltimaCompra '+
                '      ,foto '+
                ' FROM produtos' +
                ' WHERE produtoId=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_produtoId := Qry.FieldByName('produtoId').AsString;
    Self.F_descricao := Qry.FieldByName('descricao').AsString;
    Self.F_gtin := Qry.FieldByName('gtin').AsString;
    Self.F_valorVenda := Qry.FieldByName('valorVenda').AsFloat;
    Self.F_qtdeEstoque := Qry.FieldByName('qtdeEstoque').AsFloat;
    Self.F_dataUltimaCompra := Qry.FieldByName('dataUltimaCompra').AsDateTime;
    LoadBitmapFromBlob(Self.F_Foto, TBlobField(Qry.FieldByName('foto')));
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}


function TProduto.GTINExiste(aCodigo:string; aProdutoId:string; aEstadoDoCadastro:TEstadoDoCadastro): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=false;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT produtoId, descricao');
    Qry.SQL.Add('   FROM produtos' );
    Qry.SQL.Add('  WHERE gtin=:gtin ');

    if (aEstadoDoCadastro=ecAlterar) then begin
       Qry.SQL.Add('  AND produtoId<>:produtoId ');
       Qry.ParamByName('produtoId').AsString:=aProdutoId;
    end;

    Qry.ParamByName('gtin').AsString:=aCodigo;
    Qry.Open;

    if not Qry.IsEmpty then begin
       Result:=true;
       MessageOK('Já Existe um produto com este Código :'+#13+
                 Qry.FieldByName('produtoId').AsString+' - '+Qry.FieldByName('descricao').AsString, mtWarning);
    end;

  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;



end.
