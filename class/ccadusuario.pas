unit cCadUsuario;

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
     uFuncaoCriptografia,
     uUtils;


type
  TUsuario = class(TBase)
  private
    F_usuarioId:string;
    F_nome:String;
    F_senha: string;
    function getSenha: String;
    procedure setSenha(const Value: String);

  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:String):Boolean;
    function Logar(aUsuario, aSenha: String): Boolean;
    function UsuarioExiste(aUsuario: String; aGuid:String=''): Boolean;
    function AlterarSenha: Boolean;

  published
    property codigo        :string     read F_usuarioId      write F_usuarioId;
    property nome          :string     read F_nome           write F_nome;
    property senha         :string     read getSenha         write setSenha;
  end;

implementation


{$region 'Constructor and Destructor'}
constructor TUsuario.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TUsuario.Destroy;
begin

  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TUsuario.Apagar: Boolean;
var Qry:TZQuery;
begin
  if MessageNoYes('Apagar o Registro: '+#13+#13+
                  'Código: '+F_usuarioId+#13+
                  'Nome: '  +F_nome,mtConfirmation)=mrNo then begin
     Result:=false;
     abort;
  end;

  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM usuarios '+
                ' WHERE usuarioId=:usuarioId ');
    Qry.ParamByName('usuarioId').AsString :=F_usuarioId;
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

function TUsuario.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE usuarios '+
                '   SET nome           =:nome '+
                '       ,senha         =:senha '+
                ' WHERE usuarioId=:usuarioId ');
    Qry.ParamByName('usuarioId').AsString        :=Self.F_usuarioId;
    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('senha').AsString            :=Self.F_Senha;

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

function TUsuario.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO usuarios (usuarioId, '+
                '                      nome, '+
                '                      senha )'+
                ' VALUES              (:usuarioId, '+
                '                      :nome, '+
                '                      :senha )' );
    Qry.ParamByName('usuarioId').AsString  :=GuidId;
    Qry.ParamByName('nome').AsString       :=Self.F_nome;
    Qry.ParamByName('senha').AsString      :=Self.F_senha;

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

function TUsuario.Selecionar(id: String): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT usuarioId,'+
                '       nome, '+
                '       senha '+
                '  FROM usuarios '+
                ' WHERE usuarioId=:usuarioId');
    Qry.ParamByName('usuarioId').AsString:=id;
    Try
      Qry.Open;

      Self.F_usuarioId     := Qry.FieldByName('usuarioId').AsString;
      Self.F_nome          := Qry.FieldByName('nome').AsString;
      Self.F_Senha         := Qry.FieldByName('senha').AsString;;
    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TUsuario.UsuarioExiste(aUsuario:String; aGuid:String=''):Boolean;
var Qry:TZQuery;
begin
  try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT(usuarioId) AS Qtde ');
    Qry.SQL.Add('  FROM usuarios  ');
    Qry.SQL.Add(' WHERE nome =:nome  ');
    if aGuid<>EmptyStr then
    begin
      Qry.SQL.Add('  AND usuarioId =:usuarioId  ');
      Qry.ParamByName('usuarioId').AsString :=aUsuario;
    end;

    Qry.ParamByName('nome').AsString :=aUsuario;
    Try
      Qry.Open;

      if Qry.FieldByName('Qtde').AsInteger>0 then
         result := true
      else
         result := false;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

{$endregion}

{$region 'GET E SET'}

function TUsuario.getSenha: String;
begin
  Result := Descriptografar(Self.F_senha);
end;

procedure TUsuario.setSenha(const Value: String);
begin
  Self.F_senha := Criptografar(Value);
end;
{$endregion}

{$region 'LOGIN'}
function TUsuario.Logar(aUsuario:String; aSenha:String):Boolean;
var Qry:TZQuery;
begin
  try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT usuarioId, '+
                '       nome, '+
                '       senha '+
                '  FROM usuarios '+
                ' WHERE nome =:nome '+
                '   AND senha=:Senha');
    Qry.ParamByName('nome').AsString :=aUsuario;
    Qry.ParamByName('senha').AsString:=Criptografar(aSenha);
    Try
      Qry.Open;

      if Qry.FieldByName('usuarioId').AsString<>EmptyStr then begin
         result := true;
         F_usuarioId:= Qry.FieldByName('usuarioId').AsString;
         F_nome     := Qry.FieldByName('nome').AsString;
         F_senha    := Qry.FieldByName('senha').AsString;
      end
      else
         result := false;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;
{$endregion}

{$region 'ALTERAÇÃO DE SENHA'}
function TUsuario.AlterarSenha: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE usuarios '+
                '   SET senha =:senha '+
                ' WHERE usuarioId=:usuarioId ');
    Qry.ParamByName('usuarioId').AsString        :=Self.F_usuarioId;
    Qry.ParamByName('senha').AsString            :=Self.F_Senha;

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

{$endregion}
end.

