unit cAtualizacaoTabelaMYSQL;

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
     uEnum,
     cAtualizacaoBancoDeDados,
     cCadUsuario;

type

  { TAtualizacaoTableMYSQL }

  TAtualizacaoTable = class(TAtualizaBancoDados)

  private

  protected

  public
    constructor Create(aConexao:TZConnection);
    Function TabelaExisteNoBancoDeDados(aNomeTabela:String):Boolean;
    destructor Destroy; override;

    procedure Categoria;
    procedure Cliente;
    procedure Produto;
    procedure Vendas;
    procedure VendasItens;
    procedure Usuario;
    procedure AcaoAcesso;
    procedure UsuariosAcaoAcesso;
end;

implementation

{ TAtualizacaoTableMYSQL }

constructor TAtualizacaoTable.Create(aConexao: TZConnection);
begin

  ConexaoDB:=aConexao;
  Categoria;
  Cliente;
  Produto;
  Vendas;
  VendasItens;
  Usuario;
  AcaoAcesso;
  UsuariosAcaoAcesso;
end;

destructor TAtualizacaoTable.Destroy;
begin
  inherited Destroy;
end;


Function TAtualizacaoTable.TabelaExisteNoBancoDeDados(aNomeTabela:String):Boolean;
Var Qry:TZQuery;
Begin

  Try
    Qry:=TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('  SELECT table_name ');
    Qry.SQL.Add('    FROM information_schema.tables ');
    Qry.SQL.Add('   WHERE table_schema =:Schema ');
    Qry.SQL.Add('     AND table_name =:Tabela ');
    Qry.ParamByName('Tabela').AsString := aNomeTabela;
    Qry.ParamByName('Schema').ASString:=ConexaoDB.DataBase;
    Qry.Open;

    if Qry.IsEmpty then
      Result:=False
    else
      Result:=True;

  Finally
    Qry.Close;
    FreeAndNil(Qry);
  End;

End;

procedure TAtualizacaoTable.Categoria;
begin
  if not TabelaExisteNoBancoDeDados('categorias') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE categorias ( '+
      '	 categoriaId VARCHAR(36) NOT NULL, '+
      '	 descricao   VARCHAR(30), '+
      '	 PRIMARY KEY (categoriaId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.Cliente;
begin

end;

procedure TAtualizacaoTable.Produto;
begin

end;

procedure TAtualizacaoTable.Vendas;
begin

end;

procedure TAtualizacaoTable.VendasItens;
begin

end;

procedure TAtualizacaoTable.Usuario;
Var oUsuario:TUsuario;
begin
  if not TabelaExisteNoBancoDeDados('usuarios') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE usuarios ( '+
      '	 usuarioId VARCHAR(36) NOT NULL, '+
      '	 nome VARCHAR(50) NOT NULL, '+
      '	 senha VARCHAR(40) NOT NULL, '+
      '	 PRIMARY KEY (usuarioId) '+
      '	) '
    );
  end;
  Try
    oUsuario:=TUsuario.Create(ConexaoDB);
    oUsuario.nome:='ADMIN';
    oUsuario.senha:='mudar@123';
    if not oUsuario.UsuarioExiste(oUsuario.nome) then
      oUsuario.Inserir;
  Finally
    if Assigned(oUsuario) then
       FreeAndNil(oUsuario);
  End;
end;

procedure TAtualizacaoTable.AcaoAcesso;
begin
  if not TabelaExisteNoBancoDeDados('acaoAcesso') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE acaoAcesso ( '+
      '	 acaoAcessoId VARCHAR(36) NOT NULL, '+
      '	 descricao varchar(100) NOT NULL, '+
      '	 chave varchar(60) NOT NULL UNIQUE, '+
      '	 PRIMARY KEY (acaoAcessoId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.UsuariosAcaoAcesso;
begin
  if not TabelaExisteNoBancoDeDados('usuariosAcaoAcesso') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE usuariosAcaoAcesso( '+
      '	 usuarioId  VARCHAR(36) NOT NULL, '+
      '	 acaoAcessoId VARCHAR(36) NOT NULL, '+
      '	 ativo tinyint(1) DEFAULT 1 NOT NULL, '+
      '	 PRIMARY KEY (usuarioId, acaoAcessoId), '+
      '	 CONSTRAINT FK_UsuarioAcaoAcessoUsuario FOREIGN KEY (usuarioId) references usuarios(usuarioId), '+
      '	 CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso FOREIGN KEY (acaoAcessoId) references acaoAcesso(acaoAcessoId) '+
      '	) '
    );
  end;
end;

end.

