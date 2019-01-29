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

  TAtualizacaoCampoMYSQL = class(TAtualizaBancoDados)

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

function TAtualizacaoCampoMYSQL.CampoExisteNaTabela(aNomeTabela, aCampo: String): Boolean;
Var Qry:TZQuery;
Begin
  Try
    Result:=False;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT COUNT(COLUMN_NAME) AS Qtde ');
    Qry.SQL.Add('   FROM INFORMATION_SCHEMA.COLUMNS ');
    Qry.SQL.Add('  WHERE TABLE_NAME =:Tabela ');
    Qry.SQL.Add('    AND COLUMN_NAME=:Campo ');
    Qry.ParamByName('Tabela').AsString:=aNomeTabela;
    Qry.ParamByName('Campo').AsString :=aCampo;
    Qry.Open;

    if Qry.FieldByName('Qtde').AsInteger>0 then
       Result:=True;

  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

procedure TAtualizacaoCampoMYSQL.Versao1;
begin

end;

constructor TAtualizacaoCampoMYSQL.Create(aConexao: TZConnection);
begin
  ConexaoDB := aConexao;
  Versao1;
end;

destructor TAtualizacaoCampoMYSQL.Destroy;
begin
  inherited Destroy;
end;

end.

