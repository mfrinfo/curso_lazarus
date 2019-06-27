unit upropdv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, MaskEdit,
  EditBtn, StdCtrls;

type

  { Tfrmpropdv }

  Tfrmpropdv = class(TForm)
    edtQtde: TCalcEdit;
    imgFotoProduto: TImage;
    edtCodigo: TMaskEdit;
    edtDescricao: TMaskEdit;
    edtValor: TMaskEdit;
    lblCodigoGTIN: TLabel;
    lblDescricao: TLabel;
    lblProduto: TLabel;
    lblQtde: TLabel;
    Panel1: TPanel;
    pnlFotoProduto: TPanel;
  private

  public

  end;

var
  frmpropdv: Tfrmpropdv;

implementation

{$R *.lfm}

end.

