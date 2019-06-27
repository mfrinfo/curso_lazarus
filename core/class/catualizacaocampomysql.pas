unit cAtualizacaoCampoMYSQL;

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
     cAtualizacaoBancoDeDados;

type

  { TAtualizacaoCampoMYSQL }

  TAtualizacaoCampo = class(TAtualizaBancoDados)

  private
    function CampoExisteNaTabela(aNomeTabela, aCampo: String): Boolean;
    procedure Versao1;

  protected

  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;

end;
implementation

{ TAtualizacaoCampoMYSQL }

function TAtualizacaoCampo.CampoExisteNaTabela(aNomeTabela, aCampo: String): Boolean;
Var Qry:TZQuery;
Begin
  Try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT COLUMN_NAME AS Campo ');
    Qry.SQL.Add('   FROM INFORMATION_SCHEMA.COLUMNS ');
    Qry.SQL.Add('  WHERE TABLE_NAME =:Tabela ');
    Qry.SQL.Add('    AND COLUMN_NAME=:Campo ');
    Qry.SQL.Add('    AND TABLE_SCHEMA=:Schema limit 1  ');
    Qry.ParamByName('Tabela').AsString:=aNomeTabela;
    Qry.ParamByName('Campo').AsString :=aCampo;
    Qry.ParamByName('Schema').ASString:=ConexaoDB.DataBase;
    Qry.Open;

    if Qry.IsEmpty then
      Result:=False
    else
      Result:=True;

  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

procedure TAtualizacaoCampo.Versao1;
begin
  {$region 'Exemplo de Atualização e Remoção de Colunas da Tabela'}
    if not CampoExisteNaTabela('categorias','testeColuna') then begin
       ExecutaDiretoBancoDeDados('ALTER TABLE categorias ADD Column testeColuna varchar(30) ');
    end;

    if CampoExisteNaTabela('categorias','testeColuna') then begin
       ExecutaDiretoBancoDeDados('ALTER TABLE categorias DROP Column testeColuna ');
    end;

    if not CampoExisteNaTabela('produtos','foto') then begin
       ExecutaDiretoBancoDeDados('ALTER TABLE produtos ADD Column foto LONGBLOB ');
    end;
  {$endregion}
end;

constructor TAtualizacaoCampo.Create(aConexao: TZConnection);
begin
  ConexaoDB:=aConexao;
  Versao1;
end;

destructor TAtualizacaoCampo.Destroy;
begin
  inherited Destroy;
end;

end.

