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
     cArquivoIni,
     DB,
     SysUtils;

type

  { TAtualizaBancoDados }

  TAtualizaBancoDados = class

  private

  public
    ConexaoDB:TZConnection;
    constructor Create(aConexao:TZConnection);
    procedure ExecutaDiretoBancoDeDados(aScript: String);
end;

type

  { TAtualizaBancoDadosMYSQL }

  TAtualizaBancoDadosMYSQL = Class
  private
    ConexaoDB: TZConnection;
  public
    function AtualizarBancoDeDadosMYSQL: Boolean;
    constructor Create(aConexao: TZConnection);
End;

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


{ TAtualizaBancoDadosMYSQL }

function TAtualizaBancoDadosMYSQL.AtualizarBancoDeDadosMYSQL: Boolean;
var oAtualizarDB:TAtualizaBancoDados;
    oTabela: TAtualizaBancoDados;
    oCampo: TAtualizaBancoDados;
begin
  Try
    //Classe Principal de Atualização
    oAtualizarDB := TAtualizaBancoDados.Create(ConexaoDB);

    //Sub-Class de Atualização
    if TArquivoIni.TipoDataBase='FIREBIRD' then begin

    end
    else begin
      oTabela := TAtualizacaoTableMYSQL.Create(ConexaoDB);
      oCampo  := TAtualizacaoCampoMYSQL.Create(ConexaoDB);
    end;
    Result  :=true;
  Finally
    FreeAndNil(oCampo);
    FreeAndNil(oTabela);
    FreeAndNil(oAtualizarDB);
  End;
end;

constructor TAtualizaBancoDadosMYSQL.Create(aConexao: TZConnection);
begin
  ConexaoDB:=aConexao;
end;

end.

