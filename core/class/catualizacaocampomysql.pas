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
     uEnum,
     cAtualizacaoBancoDeDados;

type

  { TAtualizacaoCampoMYSQL }

  TAtualizacaoCampo = class(TAtualizaBancoDados)

  private
    sColumn:String;
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

    if Self.TipoDb = dbMySQL then begin
      Qry.SQL.Add(' SELECT COLUMN_NAME AS Campo ');
      Qry.SQL.Add('   FROM INFORMATION_SCHEMA.COLUMNS ');
      Qry.SQL.Add('  WHERE TABLE_NAME =:Tabela ');
      Qry.SQL.Add('    AND COLUMN_NAME=:Campo ');
      Qry.SQL.Add('    AND TABLE_SCHEMA=:Schema limit 1  ');
      Qry.ParamByName('Tabela').AsString:=aNomeTabela;
      Qry.ParamByName('Campo').AsString :=aCampo;
      Qry.ParamByName('Schema').ASString:=ConexaoDB.DataBase;
    end
    else if (Self.TipoDb = dbFirebird) then begin
      Qry.SQL.Add('  SELECT r.rdb$field_name as Campo ,');
      Qry.SQL.Add('         t.rdb$Type_name as Tipo, ');
      Qry.SQL.Add('         f.rdb$field_length as Tamanho ');
      Qry.SQL.Add('    FROM rdb$relation_Fields r ');
      Qry.SQL.Add('         JOIN rdb$fields f on f.rdb$field_name = r.rdb$field_source ');
      Qry.SQL.Add('         JOIN rdb$types t on f.rdb$field_type = t.rdb$type ');
      Qry.SQL.Add('   WHERE (r.rdb$relation_name=:Tabela) ');
      Qry.SQL.Add('     AND (r.rdb$field_Name   =:Campo) ');
      Qry.SQL.Add('     AND (t.rdb$field_name   =''RDB$FIELD_TYPE'') ');
      Qry.ParamByName('Tabela').AsString:=aNomeTabela;
      Qry.ParamByName('Campo').AsString :=aCampo;
    end;
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
    //if not CampoExisteNaTabela('categorias','testeColuna') then begin
    //   ExecutaDiretoBancoDeDados('ALTER TABLE categorias ADD '+sColumn+' testeColuna varchar(30) ');
    //end;

    //if CampoExisteNaTabela('categorias','testeColuna') then begin
    //   ExecutaDiretoBancoDeDados('ALTER TABLE categorias DROP '+sColumn+' testeColuna ');
    //end;
  {$endregion}
end;

constructor TAtualizacaoCampo.Create(aConexao: TZConnection);
begin
  ConexaoDB:=aConexao;
  if (ConexaoDb.Protocol='firebird-3.0') then begin
     TipoDb:=dbFirebird;
     sColumn:='';
  end
  else begin
     TipoDb:=dbMySQL;
     sColumn:= ' Add Column ';
  end;

  Versao1;
end;

destructor TAtualizacaoCampo.Destroy;
begin
  inherited Destroy;
end;

end.

