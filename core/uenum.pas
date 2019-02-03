unit uEnum;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type
   TEstadoDoCadastro = (ecInserir, ecAlterar, ecNenhum);
   TAcaoExcluirEstoque = (aeeApagar, aeeAlterar);
   TTipoBancoDados = (dbMySQL, dbFirebird);

implementation

end.

