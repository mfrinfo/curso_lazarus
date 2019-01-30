program Vendas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uPrincipal, lazcontrols, zcomponent, uConexao, utelaheranca,
  uCadCategoria, cArquivoIni, uAtualizaDB, cAtualizacaoBancoDeDados,
  cAtualizacaoTabelaMYSQL, uenum, cusuariologado, ufuncaoCriptografia, uutils,
  catualizacaocampomysql, cCadCategoria, ccadusuario, ucadusuario, uLogin,
  cacaoacesso, uCadAcaoAcesso, cInstanciarForm, uUsuarioVsAcoes, cbase;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

