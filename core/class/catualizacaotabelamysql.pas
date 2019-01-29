unit cAtualizacaoTabelaMYSQL;

{$mode objfpc}{$H+}

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     ZAbstractConnection,
     ZConnection,
     SysUtils,
     cAtualizacaoBancoDeDados,
     cCadUsuario;

type

  { TAtualizacaoTableMYSQL }

  TAtualizacaoTableMYSQL = class(TAtualizaBancoDados)

  private

  protected

  public
    constructor Create(aConexao:TZConnection);
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

constructor TAtualizacaoTableMYSQL.Create(aConexao: TZConnection);
begin
  ConexaoDB := aConexao;
  Categoria;
  Cliente;
  Produto;
  Vendas;
  VendasItens;
  Usuario;
  AcaoAcesso;
  UsuariosAcaoAcesso;
end;

destructor TAtualizacaoTableMYSQL.Destroy;
begin
  inherited Destroy;
end;


procedure TAtualizacaoTableMYSQL.Categoria;
begin
  ExecutaDiretoBancoDeDados(
    'CREATE TABLE IF NOT EXISTS categorias ( '+
    '	 categoriaId VARCHAR(36) not null, '+
    '	 descricao  varchar(30) NULL, '+
    '	 PRIMARY KEY (categoriaId) '+
    '	) '
  );
end;

procedure TAtualizacaoTableMYSQL.Cliente;
begin

end;

procedure TAtualizacaoTableMYSQL.Produto;
begin

end;

procedure TAtualizacaoTableMYSQL.Vendas;
begin

end;

procedure TAtualizacaoTableMYSQL.VendasItens;
begin

end;

procedure TAtualizacaoTableMYSQL.Usuario;
Var oUsuario:TUsuario;
begin
  ExecutaDiretoBancoDeDados(
    'CREATE TABLE IF NOT EXISTS usuarios ( '+
    '	 usuarioId VARCHAR(36) not null, '+
    '	 nome VARCHAR(50) not null, '+
    '	 senha VARCHAR(40) not null, '+
    '	 PRIMARY KEY (usuarioId) '+
    '	) '
  );

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

procedure TAtualizacaoTableMYSQL.AcaoAcesso;
begin
  ExecutaDiretoBancoDeDados(
    'CREATE TABLE IF NOT EXISTS acaoAcesso ( '+
    '	 acaoAcessoId VARCHAR(36) not null, '+
    '	 descricao varchar(100) not null, '+
    '	 chave varchar(60) not null unique, '+
    '	 PRIMARY KEY (acaoAcessoId) '+
    '	) '
  );
end;

procedure TAtualizacaoTableMYSQL.UsuariosAcaoAcesso;
begin
  ExecutaDiretoBancoDeDados(
    'CREATE TABLE IF NOT EXISTS usuariosAcaoAcesso( '+
    '	 usuarioId  VARCHAR(36) not null, '+
    '	 acaoAcessoId VARCHAR(36) not null, '+
    '	 ativo tinyint(1) not null default 1, '+
    '	 PRIMARY KEY (usuarioId, acaoAcessoId), '+
    '	 CONSTRAINT FK_UsuarioAcaoAcessoUsuario '+
    '	 FOREIGN KEY (usuarioId) references usuarios(usuarioId), '+
    '	 CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso '+
    '	 FOREIGN KEY (acaoAcessoId) references acaoAcesso(acaoAcessoId) '+
    '	) '
  );
end;

end.

