unit cpdvvendaproduto;

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
  TpdvVendaProduto = class(TBase)

  private
    F_pdvVendaId:String;
    F_item:Integer;
    F_produtoId:String;
    F_gtin:String;
    F_descricaoProduto:String;
    F_qtde:Double;
    F_valorUnitario:Double;
    F_valorTotalProduto:Double;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;

  published
    property pdvVendaId:String  read F_pdvVendaId write F_pdvVendaId;
    property item:Integer  read F_item write F_item;
    property produtoId:String  read F_produtoId write F_produtoId;
    property gtin:String  read F_gtin write F_gtin;
    property descricaoProduto:String  read F_descricaoProduto write F_descricaoProduto;
    property qtde:Double  read F_qtde write F_qtde;
    property valorUnitario:Double  read F_valorUnitario write F_valorUnitario;
    property valorTotalProduto:Double  read F_valorTotalProduto write F_valorTotalProduto;

end;

implementation

{TpdvVendaProduto}

{$region 'Constructor and Destructor'}
constructor TpdvVendaProduto.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TpdvVendaProduto.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TpdvVendaProduto.Apagar: Boolean;
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
    Qry.SQL.Add('DELETE FROM pdvvendaprodutos'+
                '      WHERE pdvVendaId=:pdvVendaId '+
                '        AND item=:item ');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('item').AsInteger := Self.F_item;
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

function TpdvVendaProduto.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE pdvvendaprodutos'+
                '    SET produtoId=:produtoId '+
                '       ,gtin=:gtin '+
                '       ,descricaoProduto=:descricaoProduto '+
                '       ,qtde=:qtde '+
                '       ,valorUnitario=:valorUnitario '+
                '       ,valorTotalProduto=:valorTotalProduto '+
                '      WHERE pdvVendaId=:pdvVendaId '+
                '        AND item=:item ');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('item').AsInteger := Self.F_item;
    Qry.ParamByName('produtoId').AsString := Self.F_produtoId;
    Qry.ParamByName('gtin').AsString := Self.F_gtin;
    Qry.ParamByName('descricaoProduto').AsString := Self.F_descricaoProduto;
    Qry.ParamByName('qtde').AsFloat := Self.F_qtde;
    Qry.ParamByName('valorUnitario').AsFloat := Self.F_valorUnitario;
    Qry.ParamByName('valorTotalProduto').AsFloat := Self.F_valorTotalProduto;
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

function TpdvVendaProduto.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO pdvvendaprodutos ('+
                '      pdvVendaId'+
                '      ,item'+
                '      ,produtoId'+
                '      ,gtin'+
                '      ,descricaoProduto'+
                '      ,qtde'+
                '      ,valorUnitario'+
                '      ,valorTotalProduto'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :pdvVendaId '+
                '      ,:item '+
                '      ,:produtoId '+
                '      ,:gtin '+
                '      ,:descricaoProduto '+
                '      ,:qtde '+
                '      ,:valorUnitario '+
                '      ,:valorTotalProduto '+
                ')');
    Qry.ParamByName('pdvVendaId').AsString := Self.pdvVendaId;
    Qry.ParamByName('item').AsInteger := Self.item;
    Qry.ParamByName('produtoId').AsString := Self.F_produtoId;
    Qry.ParamByName('gtin').AsString := Self.F_gtin;
    Qry.ParamByName('descricaoProduto').AsString := Self.F_descricaoProduto;
    Qry.ParamByName('qtde').AsFloat := Self.F_qtde;
    Qry.ParamByName('valorUnitario').AsFloat := Self.F_valorUnitario;
    Qry.ParamByName('valorTotalProduto').AsFloat := Self.F_valorTotalProduto;
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
function TpdvVendaProduto.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      pdvVendaId '+
                '      ,item '+
                '      ,produtoId '+
                '      ,gtin '+
                '      ,descricaoProduto '+
                '      ,qtde '+
                '      ,valorUnitario '+
                '      ,valorTotalProduto '+
                ' FROM pdvvendaprodutos' +
                ' WHERE pdvVendaId=:id '+
                '   AND item=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_pdvVendaId := Qry.FieldByName('pdvVendaId').AsString;
    Self.F_item := Qry.FieldByName('item').AsInteger;
    Self.F_produtoId := Qry.FieldByName('produtoId').AsString;
    Self.F_gtin := Qry.FieldByName('gtin').AsString;
    Self.F_descricaoProduto := Qry.FieldByName('descricaoProduto').AsString;
    Self.F_qtde := Qry.FieldByName('qtde').AsFloat;
    Self.F_valorUnitario := Qry.FieldByName('valorUnitario').AsFloat;
    Self.F_valorTotalProduto := Qry.FieldByName('valorTotalProduto').AsFloat;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}
end.
