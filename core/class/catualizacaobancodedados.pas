unit cAtualizacaoBancoDeDados;

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
     DB,
     uEnum,
     SysUtils;

type

  { TAtualizaBancoDados }

  TAtualizaBancoDados = class

  private

  public
    ConexaoDB:TZConnection;
    TipoDb: TTipoBancoDados;
    constructor Create(aConexao:TZConnection);
    procedure ExecutaDiretoBancoDeDados(aScript: String);
    function AtualizarBancoDeDados: Boolean;
end;

implementation

uses cAtualizacaoTabelaMYSQL, cAtualizacaoCampoMYSQL;

{ TAtualizaBancoDados }

constructor TAtualizaBancoDados.Create(aConexao: TZConnection);
begin
  ConexaoDB:=aConexao;
end;

procedure TAtualizaBancoDados.ExecutaDiretoBancoDeDados(aScript: String);
Var Qry:TZQuery;
begin
  Try
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(aScript);
    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
    End;
  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  End;
end;


function TAtualizaBancoDados.AtualizarBancoDeDados: Boolean;
var oAtualizarDB:TAtualizaBancoDados;
    oTabela: TAtualizaBancoDados;
    oCampo: TAtualizaBancoDados;
begin
  Try
    //Classe Principal de Atualização
    oAtualizarDB := TAtualizaBancoDados.Create(ConexaoDB);

    oTabela := TAtualizacaoTable.Create(ConexaoDB);
    oCampo  := TAtualizacaoCampo.Create(ConexaoDB);

    Result  :=true;
  Finally
    FreeAndNil(oCampo);
    FreeAndNil(oTabela);
    FreeAndNil(oAtualizarDB);
  End;
end;


end.

