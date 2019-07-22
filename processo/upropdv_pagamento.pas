unit upropdv_pagamento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, MaskEdit, EditBtn, rxcurredit;

type

  { Tfrmpropdvpagamento }

  Tfrmpropdvpagamento = class(TForm)
    Btn01: TBitBtn;
    Btn02: TBitBtn;
    Btn03: TBitBtn;
    Btn04: TBitBtn;
    Btn05: TBitBtn;
    Btn99: TBitBtn;
    btnCancelar: TBitBtn;
    btnOK: TBitBtn;
    edtValorPago: TCurrencyEdit;
    edtTroco: TCurrencyEdit;
    edtValorTotal: TCurrencyEdit;
    lblProduto: TLabel;
    lblQtde: TLabel;
    lblQtde1: TLabel;
    lbxOperadora: TListBox;
    pnlListBox: TPanel;
    pnlOperadora: TPanel;
    pnlInterno: TPanel;
    pnlFundo: TPanel;
    procedure Btn01Click(Sender: TObject);
    procedure Btn02Click(Sender: TObject);
    procedure Btn03Click(Sender: TObject);
    procedure Btn04Click(Sender: TObject);
    procedure Btn05Click(Sender: TObject);
    procedure Btn99Click(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtValorPagoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxOperadoraClick(Sender: TObject);
  private
    procedure OperadoraCartao(Habilitar: Boolean);
    procedure ResetarBotoes;

  public
    bCancelou: Boolean;
    sCodigoMeioPagamento:String;
    sCodigoCartao:String;
  end;

var
  frmpropdvpagamento: Tfrmpropdvpagamento;

implementation

{$R *.lfm}

uses uUtils;

{ Tfrmpropdvpagamento }

procedure Tfrmpropdvpagamento.ResetarBotoes;
Var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
     if TBitBtn(Components[i]).Tag=1 then begin
        TBitBtn(Components[i]).Font.Style:=[];
        sCodigoMeioPagamento:='';
        sCodigoCartao:='99';
        OperadoraCartao(false);
     end;
  end;
end;

procedure Tfrmpropdvpagamento.OperadoraCartao(Habilitar:Boolean);
begin
  pnlOperadora.Enabled:=Habilitar;
  if (Habilitar) then begin
     lbxOperadora.SetFocus;
     lbxOperadora.ItemIndex:=0;
     edtValorPago.Value:=edtValorTotal.Value;
  end;
end;

procedure Tfrmpropdvpagamento.btnOKClick(Sender: TObject);
begin

  if sCodigoMeioPagamento='' then begin
     MessageOK('É necessário escolher um meio de pagamento ',mtWarning);
     exit;
  end;

  if edtValorPago.Value <= 0 then begin
     MessageOK('Valor pago não pode ser Zero ',mtWarning);
     exit;
  end;

  bCancelou:=false;
  Close;
end;

procedure Tfrmpropdvpagamento.edtValorPagoChange(Sender: TObject);
begin
  if edtValorPago.Value=0 then
    edtTroco.Value :=0
  else
    edtTroco.Value :=edtValorPago.Value - edtValorTotal.Value;

  if edtTroco.Value < 0 then
     edtTroco.Color:=clRed
  else
     edtTroco.Color:=clBlue;
end;

procedure Tfrmpropdvpagamento.FormShow(Sender: TObject);
begin
  edtValorPago.SetFocus;
  OperadoraCartao(false);
end;

procedure Tfrmpropdvpagamento.lbxOperadoraClick(Sender: TObject);
begin
  case lbxOperadora.ItemIndex of
    0:sCodigoCartao:='01';
    1:sCodigoCartao:='02';
    2:sCodigoCartao:='03';
    3:sCodigoCartao:='04';
    4:sCodigoCartao:='05';
    5:sCodigoCartao:='06';
    6:sCodigoCartao:='07';
    7:sCodigoCartao:='08';
    8:sCodigoCartao:='09';
    9:sCodigoCartao:='99';
  end;
end;

procedure Tfrmpropdvpagamento.btnCancelarClick(Sender: TObject);
begin
  bCancelou:=true;
  Close;
end;

procedure Tfrmpropdvpagamento.Btn01Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='01';
  Btn01.Font.Style:=[fsBold];
end;

procedure Tfrmpropdvpagamento.Btn02Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='02';
  Btn02.Font.Style:=[fsBold];
end;

procedure Tfrmpropdvpagamento.Btn03Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='03';
  Btn03.Font.Style:=[fsBold];
  OperadoraCartao(true);
end;

procedure Tfrmpropdvpagamento.Btn04Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='04';
  Btn04.Font.Style:=[fsBold];
  OperadoraCartao(true);
end;

procedure Tfrmpropdvpagamento.Btn05Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='05';
  Btn05.Font.Style:=[fsBold];
end;

procedure Tfrmpropdvpagamento.Btn99Click(Sender: TObject);
begin
  ResetarBotoes;
  sCodigoMeioPagamento:='99';
  Btn99.Font.Style:=[fsBold];
end;

end.

