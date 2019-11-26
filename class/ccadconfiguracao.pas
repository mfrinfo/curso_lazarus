unit cCadConfiguracao;

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
  TConfiguracao = class(TBase)

  private
    F_configuracaoId:String;
    F_empresa:String;
    F_cnpj:String;
    F_ie:String;
    F_cep:String;
    F_numero:String;
    F_logradouro:String;
    F_bairro:String;
    F_cidade:String;
    F_uf:String;
    F_codibge:String;
    F_tokenNfce:String;
    F_idTokenNfce:String;
    F_caminhoCertificadoDigital:String;
    F_senha:String;
    F_tipoEmissaoEletronica:Integer;
    F_nroSerieNFCe:Integer;
    F_nroNFCe:Integer;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;
    procedure Selecionar;
    function AtualizarNroNFCe: Boolean;
  published
    property configuracaoId:String  read F_configuracaoId write F_configuracaoId;
    property empresa:String  read F_empresa write F_empresa;
    property cnpj:String  read F_cnpj write F_cnpj;
    property ie:String  read F_ie write F_ie;
    property cep:String  read F_cep write F_cep;
    property numero:String  read F_numero write F_numero;
    property logradouro:String  read F_logradouro write F_logradouro;
    property bairro:String  read F_bairro write F_bairro;
    property cidade:String  read F_cidade write F_cidade;
    property uf:String  read F_uf write F_uf;
    property codibge:String  read F_codibge write F_codibge;
    property tokenNfce:String  read F_tokenNfce write F_tokenNfce;
    property idTokenNfce:String  read F_idTokenNfce write F_idTokenNfce;
    property caminhoCertificadoDigital:String  read F_caminhoCertificadoDigital write F_caminhoCertificadoDigital;
    property senha:String  read F_senha write F_senha;
    property tipoEmissaoEletronica:Integer  read F_tipoEmissaoEletronica write F_tipoEmissaoEletronica;
    property nroSerieNFCe:Integer  read F_nroSerieNFCe write F_nroSerieNFCe;
    property nroNFCe:Integer  read F_nroNFCe write F_nroNFCe;

end;

implementation

{TConfiguracao}

{$region 'Constructor and Destructor'}
constructor TConfiguracao.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TConfiguracao.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TConfiguracao.Apagar: Boolean;
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
    Qry.SQL.Add('DELETE FROM configuracoes'+
                '      WHERE configuracaoId=:configuracaoId ');
    Qry.ParamByName('configuracaoId').AsString := Self.F_configuracaoId;
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

function TConfiguracao.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE configuracoes'+
                '    SET empresa=:empresa '+
                '       ,cnpj=:cnpj '+
                '       ,ie=:ie '+
                '       ,cep=:cep '+
                '       ,numero=:numero '+
                '       ,logradouro=:logradouro '+
                '       ,bairro=:bairro '+
                '       ,cidade=:cidade '+
                '       ,uf=:uf '+
                '       ,codibge=:codibge '+
                '       ,tokenNfce=:tokenNfce '+
                '       ,idTokenNfce=:idTokenNfce '+
                '       ,caminhoCertificadoDigital=:caminhoCertificadoDigital '+
                '       ,senha=:senha '+
                '       ,tipoEmissaoEletronica=:tipoEmissaoEletronica '+
                '       ,nroSerieNFCe=:nroSerieNFCe '+
                '       ,nroNFCe=:nroNFCe '+
                '      WHERE configuracaoId=:configuracaoId ');
    Qry.ParamByName('configuracaoId').AsString := Self.F_configuracaoId;
    Qry.ParamByName('empresa').AsString := Self.F_empresa;
    Qry.ParamByName('cnpj').AsString := Self.F_cnpj;
    Qry.ParamByName('ie').AsString := Self.F_ie;
    Qry.ParamByName('cep').AsString := Self.F_cep;
    Qry.ParamByName('numero').AsString := Self.F_numero;
    Qry.ParamByName('logradouro').AsString := Self.F_logradouro;
    Qry.ParamByName('bairro').AsString := Self.F_bairro;
    Qry.ParamByName('cidade').AsString := Self.F_cidade;
    Qry.ParamByName('uf').AsString := Self.F_uf;
    Qry.ParamByName('codibge').AsString := Self.F_codibge;
    Qry.ParamByName('tokenNfce').AsString := Self.F_tokenNfce;
    Qry.ParamByName('idTokenNfce').AsString := Self.F_idTokenNfce;
    Qry.ParamByName('caminhoCertificadoDigital').AsString := Self.F_caminhoCertificadoDigital;
    Qry.ParamByName('senha').AsString := Self.F_senha;
    Qry.ParamByName('tipoEmissaoEletronica').AsInteger := Self.F_tipoEmissaoEletronica;
    Qry.ParamByName('nroSerieNFCe').AsInteger := Self.F_nroSerieNFCe;
    Qry.ParamByName('nroNFCe').AsInteger := Self.F_nroNFCe;
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

function TConfiguracao.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO configuracoes ('+
                '      configuracaoId'+
                '      ,empresa'+
                '      ,cnpj'+
                '      ,ie'+
                '      ,cep'+
                '      ,numero'+
                '      ,logradouro'+
                '      ,bairro'+
                '      ,cidade'+
                '      ,uf'+
                '      ,codibge'+
                '      ,tokenNfce'+
                '      ,idTokenNfce'+
                '      ,caminhoCertificadoDigital'+
                '      ,senha'+
                '      ,tipoEmissaoEletronica'+
                '      ,nroSerieNFCe'+
                '      ,nroNFCe'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :configuracaoId '+
                '      ,:empresa '+
                '      ,:cnpj '+
                '      ,:ie '+
                '      ,:cep '+
                '      ,:numero '+
                '      ,:logradouro '+
                '      ,:bairro '+
                '      ,:cidade '+
                '      ,:uf '+
                '      ,:codibge '+
                '      ,:tokenNfce '+
                '      ,:idTokenNfce '+
                '      ,:caminhoCertificadoDigital '+
                '      ,:senha '+
                '      ,:tipoEmissaoEletronica '+
                '      ,:nroSerieNFCe '+
                '      ,:nroNFCe '+
                ')');
    Qry.ParamByName('configuracaoId').AsString := GuidId;
    Qry.ParamByName('empresa').AsString := Self.F_empresa;
    Qry.ParamByName('cnpj').AsString := Self.F_cnpj;
    Qry.ParamByName('ie').AsString := Self.F_ie;
    Qry.ParamByName('cep').AsString := Self.F_cep;
    Qry.ParamByName('numero').AsString := Self.F_numero;
    Qry.ParamByName('logradouro').AsString := Self.F_logradouro;
    Qry.ParamByName('bairro').AsString := Self.F_bairro;
    Qry.ParamByName('cidade').AsString := Self.F_cidade;
    Qry.ParamByName('uf').AsString := Self.F_uf;
    Qry.ParamByName('codibge').AsString := Self.F_codibge;
    Qry.ParamByName('tokenNfce').AsString := Self.F_tokenNfce;
    Qry.ParamByName('idTokenNfce').AsString := Self.F_idTokenNfce;
    Qry.ParamByName('caminhoCertificadoDigital').AsString := Self.F_caminhoCertificadoDigital;
    Qry.ParamByName('senha').AsString := Self.F_senha;
    Qry.ParamByName('tipoEmissaoEletronica').AsInteger := Self.F_tipoEmissaoEletronica;
    Qry.ParamByName('nroSerieNFCe').AsInteger := Self.F_nroSerieNFCe;
    Qry.ParamByName('nroNFCe').AsInteger := Self.F_nroNFCe;
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
function TConfiguracao.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      configuracaoId '+
                '      ,empresa '+
                '      ,cnpj '+
                '      ,ie '+
                '      ,cep '+
                '      ,numero '+
                '      ,logradouro '+
                '      ,bairro '+
                '      ,cidade '+
                '      ,uf '+
                '      ,codibge '+
                '      ,tokenNfce '+
                '      ,idTokenNfce '+
                '      ,caminhoCertificadoDigital '+
                '      ,senha '+
                '      ,tipoEmissaoEletronica '+
                '      ,nroSerieNFCe '+
                '      ,nroNFCe '+
                ' FROM configuracoes' +
                ' WHERE configuracaoId=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_configuracaoId := Qry.FieldByName('configuracaoId').AsString;
    Self.F_empresa := Qry.FieldByName('empresa').AsString;
    Self.F_cnpj := Qry.FieldByName('cnpj').AsString;
    Self.F_ie := Qry.FieldByName('ie').AsString;
    Self.F_cep := Qry.FieldByName('cep').AsString;
    Self.F_numero := Qry.FieldByName('numero').AsString;
    Self.F_logradouro := Qry.FieldByName('logradouro').AsString;
    Self.F_bairro := Qry.FieldByName('bairro').AsString;
    Self.F_cidade := Qry.FieldByName('cidade').AsString;
    Self.F_uf := Qry.FieldByName('uf').AsString;
    Self.F_codibge := Qry.FieldByName('codibge').AsString;
    Self.F_tokenNfce := Qry.FieldByName('tokenNfce').AsString;
    Self.F_idTokenNfce := Qry.FieldByName('idTokenNfce').AsString;
    Self.F_caminhoCertificadoDigital := Qry.FieldByName('caminhoCertificadoDigital').AsString;
    Self.F_senha := Qry.FieldByName('senha').AsString;
    Self.F_tipoEmissaoEletronica := Qry.FieldByName('tipoEmissaoEletronica').AsInteger;
    Self.F_nroSerieNFCe := Qry.FieldByName('nroSerieNFCe').AsInteger;
    Self.F_nroNFCe := Qry.FieldByName('nroNFCe').AsInteger;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}


procedure TConfiguracao.Selecionar;
var Qry:TZQuery;
begin
  try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      configuracaoId '+
                '      ,empresa '+
                '      ,cnpj '+
                '      ,ie '+
                '      ,cep '+
                '      ,numero '+
                '      ,logradouro '+
                '      ,bairro '+
                '      ,cidade '+
                '      ,uf '+
                '      ,codibge '+
                '      ,tokenNfce '+
                '      ,idTokenNfce '+
                '      ,caminhoCertificadoDigital '+
                '      ,senha '+
                '      ,tipoEmissaoEletronica '+
                '      ,nroSerieNFCe '+
                '      ,nroNFCe '+
                ' FROM configuracoes' +
                ' LIMIT 1');
    Qry.Open;
    Self.F_configuracaoId := Qry.FieldByName('configuracaoId').AsString;
    Self.F_empresa := Qry.FieldByName('empresa').AsString;
    Self.F_cnpj := Qry.FieldByName('cnpj').AsString;
    Self.F_ie := Qry.FieldByName('ie').AsString;
    Self.F_cep := Qry.FieldByName('cep').AsString;
    Self.F_numero := Qry.FieldByName('numero').AsString;
    Self.F_logradouro := Qry.FieldByName('logradouro').AsString;
    Self.F_bairro := Qry.FieldByName('bairro').AsString;
    Self.F_cidade := Qry.FieldByName('cidade').AsString;
    Self.F_uf := Qry.FieldByName('uf').AsString;
    Self.F_codibge := Qry.FieldByName('codibge').AsString;
    Self.F_tokenNfce := Qry.FieldByName('tokenNfce').AsString;
    Self.F_idTokenNfce := Qry.FieldByName('idTokenNfce').AsString;
    Self.F_caminhoCertificadoDigital := Qry.FieldByName('caminhoCertificadoDigital').AsString;
    Self.F_senha := Qry.FieldByName('senha').AsString;
    Self.F_tipoEmissaoEletronica := Qry.FieldByName('tipoEmissaoEletronica').AsInteger;
    Self.F_nroSerieNFCe := Qry.FieldByName('nroSerieNFCe').AsInteger;
    Self.F_nroNFCe := Qry.FieldByName('nroNFCe').AsInteger;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;


function TConfiguracao.AtualizarNroNFCe: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE configuracoes'+
                '    SET nroNFCe=nroNFCe+1 '+
                '      WHERE configuracaoId=:configuracaoId ');
    Qry.ParamByName('configuracaoId').AsString := Self.F_configuracaoId;
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


end.
