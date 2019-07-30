program Vendas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uPrincipal, rxnew, lazcontrols, zcomponent, uConexao, utelaheranca,
  cArquivoIni, uAtualizaDB, cAtualizacaoBancoDeDados, cAtualizacaoTabelaMYSQL,
  uenum, cusuariologado, ufuncaoCriptografia, uutils, catualizacaocampomysql,
  ccadusuario, ucadusuario, uLogin, cacaoacesso, uCadAcaoAcesso,
  cInstanciarForm, uUsuarioVsAcoes, cbase, ucadcategoria, ucadcliente,
  ucadproduto, upropdv, cpdvvenda, upropdv_pagamento;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

