unit cCadCliente;

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
  TCliente = class(TBase)

  private
    F_clientesId:String;
    F_nome:String;
    F_documento:String;
    F_tipoPessoa:String;
    F_cep:String;
    F_logradouro:String;
    F_numero:String;
    F_bairro:String;
    F_cidade:String;
    F_uf:String;
    F_email:String;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;

  published
    property clientesId:String  read F_clientesId write F_clientesId;
    property nome:String  read F_nome write F_nome;
    property documento:String  read F_documento write F_documento;
    property tipoPessoa:String  read F_tipoPessoa write F_tipoPessoa;
    property cep:String  read F_cep write F_cep;
    property logradouro:String  read F_logradouro write F_logradouro;
    property numero:String  read F_numero write F_numero;
    property bairro:String  read F_bairro write F_bairro;
    property cidade:String  read F_cidade write F_cidade;
    property uf:String  read F_uf write F_uf;
    property email:String  read F_email write F_email;

end;

implementation

{TCliente}

{$region 'Constructor and Destructor'}
constructor TCliente.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TCliente.Apagar: Boolean;
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
    Qry.SQL.Add('DELETE FROM clientes'+
                '      WHERE clientesId=:clientesId ');
    Qry.ParamByName('clientesId').AsString := Self.F_clientesId;
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

function TCliente.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE clientes'+
                '    SET nome=:nome '+
                '       ,documento=:documento '+
                '       ,tipoPessoa=:tipoPessoa '+
                '       ,cep=:cep '+
                '       ,logradouro=:logradouro '+
                '       ,numero=:numero '+
                '       ,bairro=:bairro '+
                '       ,cidade=:cidade '+
                '       ,uf=:uf '+
                '       ,email=:email '+
                '      WHERE clientesId=:clientesId ');
    Qry.ParamByName('clientesId').AsString := Self.F_clientesId;
    Qry.ParamByName('nome').AsString := Self.F_nome;
    Qry.ParamByName('documento').AsString := Self.F_documento;
    Qry.ParamByName('tipoPessoa').AsString := Self.F_tipoPessoa;
    Qry.ParamByName('cep').AsString := Self.F_cep;
    Qry.ParamByName('logradouro').AsString := Self.F_logradouro;
    Qry.ParamByName('numero').AsString := Self.F_numero;
    Qry.ParamByName('bairro').AsString := Self.F_bairro;
    Qry.ParamByName('cidade').AsString := Self.F_cidade;
    Qry.ParamByName('uf').AsString := Self.F_uf;
    Qry.ParamByName('email').AsString := Self.F_email;
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

function TCliente.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO clientes ('+
                '      clientesId'+
                '      ,nome'+
                '      ,documento'+
                '      ,tipoPessoa'+
                '      ,cep'+
                '      ,logradouro'+
                '      ,numero'+
                '      ,bairro'+
                '      ,cidade'+
                '      ,uf'+
                '      ,email'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :clientesId '+
                '      ,:nome '+
                '      ,:documento '+
                '      ,:tipoPessoa '+
                '      ,:cep '+
                '      ,:logradouro '+
                '      ,:numero '+
                '      ,:bairro '+
                '      ,:cidade '+
                '      ,:uf '+
                '      ,:email '+
                ')');
    Qry.ParamByName('clientesId').AsString := GuidId;
    Qry.ParamByName('nome').AsString := Self.F_nome;
    Qry.ParamByName('documento').AsString := Self.F_documento;
    Qry.ParamByName('tipoPessoa').AsString := Self.F_tipoPessoa;
    Qry.ParamByName('cep').AsString := Self.F_cep;
    Qry.ParamByName('logradouro').AsString := Self.F_logradouro;
    Qry.ParamByName('numero').AsString := Self.F_numero;
    Qry.ParamByName('bairro').AsString := Self.F_bairro;
    Qry.ParamByName('cidade').AsString := Self.F_cidade;
    Qry.ParamByName('uf').AsString := Self.F_uf;
    Qry.ParamByName('email').AsString := Self.F_email;
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
function TCliente.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      clientesId '+
                '      ,nome '+
                '      ,documento '+
                '      ,tipoPessoa '+
                '      ,cep '+
                '      ,logradouro '+
                '      ,numero '+
                '      ,bairro '+
                '      ,cidade '+
                '      ,uf '+
                '      ,email '+
                ' FROM clientes' +
                ' WHERE clientesId=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_clientesId := Qry.FieldByName('clientesId').AsString;
    Self.F_nome := Qry.FieldByName('nome').AsString;
    Self.F_documento := Qry.FieldByName('documento').AsString;
    Self.F_tipoPessoa := Qry.FieldByName('tipoPessoa').AsString;
    Self.F_cep := Qry.FieldByName('cep').AsString;
    Self.F_logradouro := Qry.FieldByName('logradouro').AsString;
    Self.F_numero := Qry.FieldByName('numero').AsString;
    Self.F_bairro := Qry.FieldByName('bairro').AsString;
    Self.F_cidade := Qry.FieldByName('cidade').AsString;
    Self.F_uf := Qry.FieldByName('uf').AsString;
    Self.F_email := Qry.FieldByName('email').AsString;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}
end.
