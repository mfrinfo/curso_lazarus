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
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=aConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT usuarioId '+
                '  FROM usuariosAcaoAcesso '+
                ' WHERE usuarioId=:usuarioId  '+
                '   AND acaoAcessoId=(SELECT acaoAcessoId '+
                                     '  FROM acaoAcesso '+
                                     ' WHERE chave=:chave LIMIT 1)'+
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

