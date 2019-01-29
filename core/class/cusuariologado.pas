unit cUsuarioLogado;

{$mode objfpc}{$H+}

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     ZAbstractConnection,
     ZConnection,
     ZAbstractRODataset,
     ZAbstractDataset,
     ZDataset,
     SysUtils,
     cArquivoIni,
     uFuncaoCriptografia;

type
  TUsuarioLogado = class
  private
    F_usuarioId:string;
    F_nome:String;
    F_senha: string;

  public
    class function TenhoAcesso(aUsuarioId: string; aChave: String;
      aConexao: TZConnection): Boolean; static;

  published
    property codigo        :string     read F_usuarioId      write F_usuarioId;
    property nome          :string     read F_nome           write F_nome;
    property senha         :string     read F_senha          write F_senha;
  end;

implementation

class function TUsuarioLogado.TenhoAcesso(aUsuarioId:string; aChave:String; aConexao: TZConnection):Boolean;
var Qry:TZQuery;
    sSubSelect, sTipoDB:String;
begin

  sTipoDB:=TArquivoIni.TipoDataBase;
  if sTipoDb = 'MYSQL' then
     sSubSelect := '(SELECT acaoAcessoId FROM acaoAcesso WHERE chave=:chave LIMIT 1)'
  else if sTipoDb = 'FIREBIRD' then
     sSubSelect := '(SELECT FIRST 1 acaoAcessoId FROM acaoAcesso WHERE chave=:chave)'
  else
     sSubSelect := '(SELECT acaoAcessoId FROM acaoAcesso WHERE chave=:chave LIMIT 1)';

  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=aConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT usuarioId '+
                '  FROM usuariosAcaoAcesso '+
                ' WHERE usuarioId=:usuarioId  '+
                '   AND acaoAcessoId='+sSubSelect+
                '   AND ativo=1');
    Qry.ParamByName('usuarioId').AsString        :=aUsuarioId;
    Qry.ParamByName('chave').AsString            :=aChave;
    Qry.Open;

    if Qry.IsEmpty then
       Result:=false;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

end.

