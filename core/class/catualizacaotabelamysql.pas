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
    procedure PdvVenda;
    procedure PdvVendaProdutos;
    procedure PdvVendaFormaPagamento;
    procedure Usuario;
    procedure AcaoAcesso;
    procedure UsuariosAcaoAcesso;
    procedure Configuracoes;
end;

implementation

{ TAtualizacaoTableMYSQL }

constructor TAtualizacaoTable.Create(aConexao: TZConnection);
begin

  ConexaoDB:=aConexao;
  Categoria;
  Cliente;
  Produto;
  PdvVenda;
  PdvVendaProdutos;
  PdvVendaFormaPagamento;
  Usuario;
  AcaoAcesso;
  UsuariosAcaoAcesso;
  Configuracoes;
end;

destructor TAtualizacaoTable.Destroy;
begin
  inherited Destroy;
end;


function TAtualizacaoTable.TabelaExisteNoBancoDeDados(aNomeTabela: String
  ): Boolean;
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
  if not TabelaExisteNoBancoDeDados('clientes') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE clientes ( '+
      '	 clientesId   VARCHAR(36) NOT NULL, '+
      '	 nome         VARCHAR(50), '+
      '	 documento    VARCHAR(20), '+
      '	 tipoPessoa   CHAR(1), '+
      '	 cep          VARCHAR(10), '+
      '	 logradouro   VARCHAR(50), '+
      '	 numero       VARCHAR(10), '+
      '	 bairro       VARCHAR(40), '+
      '	 cidade       VARCHAR(50), '+
      '	 uf           CHAR(2), '+
      '	 email        VARCHAR(100), '+
      '	 PRIMARY KEY (clientesId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.Produto;
begin
  if not TabelaExisteNoBancoDeDados('produtos') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE produtos ( '+
      '	 produtoId    VARCHAR(36) NOT NULL, '+
      '	 descricao    VARCHAR(50), '+
      '	 gtin         VARCHAR(14), '+
      '	 valorVenda   Decimal(18,2), '+
      '	 qtdeEstoque  Decimal(18,2), '+
      '	 dataUltimaCompra DateTime, '+
      '	 PRIMARY KEY (produtoId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.PdvVenda;
begin
  if not TabelaExisteNoBancoDeDados('pdvVenda') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE pdvVenda ( '+
      '	 pdvVendaId VARCHAR(36) NOT NULL, '+
      '  usuarioId VARCHAR(36) NOT NULL, '+
      '	 data DateTime, '+
      '	 hora DateTime, '+
      '	 valorTotalVenda Decimal(18,2), '+
      '	 PRIMARY KEY (pdvVendaId), '+
      '  CONSTRAINT FK_PdvVendaUsuario FOREIGN KEY (usuarioId) references usuarios(usuarioId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.PdvVendaProdutos;
begin
  if not TabelaExisteNoBancoDeDados('pdvVendaProdutos') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE pdvVendaProdutos ( '+
      '	 pdvVendaId VARCHAR(36) NOT NULL, '+
      '  item Integer, '+
      '	 produtoId VARCHAR(36) NOT NULL, '+
      '	 gtin VARCHAR(14), '+
      '	 descricaoProduto VARCHAR(50), '+
      '	 qtde Decimal(18,2), '+
      '	 valorUnitario Decimal(18,2), '+
      '	 valorTotalProduto Decimal(18,2), '+
      '	 PRIMARY KEY (pdvVendaId, item), '+
      '  CONSTRAINT FK_PdvVendaProdutosProduto FOREIGN KEY (produtoId) references produtos(produtoId), '+
      '  CONSTRAINT FK_PdvVendaProdutosPdvVenda FOREIGN KEY (pdvVendaId) references pdvVenda(pdvVendaId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.PdvVendaFormaPagamento;
begin
  if not TabelaExisteNoBancoDeDados('PdvVendaFormaPagamento') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE PdvVendaFormaPagamento ( '+
      '	 pdvVendaId VARCHAR(36) NOT NULL, '+
      '  item Integer, '+
      '	 codigoMeioPagamento CHAR(2) NOT NULL, '+
      '	 descricaoMeioPagamento VARCHAR(40), '+
      '	 codigoCartao CHAR(2), '+
      '	 operadoraCartao VARCHAR(30), '+
      '	 cnpjOperadoraCartao VARCHAR(20), '+
      '	 valorPago Decimal(18,2), '+
      '	 valorTroco Decimal(18,2), '+
      '	 PRIMARY KEY (pdvVendaId, item), '+
      '  CONSTRAINT FK_PdvVendaFormaPagamento FOREIGN KEY (pdvVendaId) references pdvVenda(pdvVendaId) '+
      '	) '
    );
  end;
end;

procedure TAtualizacaoTable.Usuario;
Var oUsuario:TUsuario;
begin
  if not TabelaExisteNoBancoDeDados('usuarios') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE usuarios ( '+
      '	 usuarioId VARCHAR(36) NOT NULL, '+
      '	 nome VARCHAR(50) NOT NULL UNIQUE, '+
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

procedure TAtualizacaoTable.Configuracoes;
begin
  if not TabelaExisteNoBancoDeDados('configuracoes') then begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE configuracoes( '+
      '	 configuracaoId VARCHAR(36) NOT NULL, '+
      '	 empresa VARCHAR(50) NOT NULL, '+
      '	 cnpj VARCHAR(18) NOT NULL, '+
      '	 ie VARCHAR(15), '+
      '	 cep  VARCHAR(10), '+
      '	 numero  VARCHAR(10), '+
      '	 logradouro VARCHAR(50), '+
      '	 bairro VARCHAR(40), '+
      '	 cidade VARCHAR(50), '+
      '	 uf CHAR(2), '+
      '	 codibge VARCHAR(7), '+
      '	 tokenNfce VARCHAR(36), '+
      '	 idTokenNfce VARCHAR(6), '+
      '  caminhoCertificadoDigital VARCHAR(255), '+
      '  senha VARCHAR(30), '+
      '  tipoEmissaoEletronica Integer DEFAULT 0 NOT NULL, '+
      '  nroSerieNFCe Integer DEFAULT 0 NOT NULL, '+
      '  nroNFCe Integer DEFAULT 0 NOT NULL, '+
      '	 PRIMARY KEY (configuracaoId) '+
      '	) '
    );
  end;
end;

end.

