unit ucadproduto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, MaskEdit, DBGrids, EditBtn, ACBrBarCode,
  ACBrValidador, utelaheranca, db, ZDataset, cCadProduto, uEnum, uConexao,
  uUtils;

type

  { TfrmCadProduto }

  TfrmCadProduto = class(TfrmTelaHeranca)
    barGTIN: TACBrBarCode;
    edtValorDaVenda: TCalcEdit;
    edtDataUltimaVenda: TDateEdit;
    edtQtdeEstoque: TCalcEdit;
    edtDescricao: TLabeledEdit;
    edtGTIN: TLabeledEdit;
    edtProdutoId: TLabeledEdit;
    imgFoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    btnCarregar: TSpeedButton;
    btnLimpar: TSpeedButton;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure edtGTINChange(Sender: TObject);
    procedure edtGTINExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    oProduto:TProduto;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

{$R *.lfm}

{$region 'Metodos Override'}
procedure TfrmCadProduto.ConfigurarCampos;
begin
  qryListagem.Fields[0].DisplayLabel:='Código';
  qryListagem.Fields[1].DisplayLabel:='Descrição';
  qryListagem.Fields[2].DisplayLabel:='GTIN - Código de Barra';
  qryListagem.Fields[3].DisplayLabel:='Valor de Venda';

  grdListagem.Columns.Add();
  grdListagem.Columns[0].FieldName:='produtoId';
  grdListagem.Columns[0].Width:=250;

  grdListagem.Columns.Add();
  grdListagem.Columns[1].FieldName:='descricao';
  grdListagem.Columns[1].Width:=400;

  grdListagem.Columns.Add();
  grdListagem.Columns[2].FieldName:='gtin';
  grdListagem.Columns[2].Width:=200;

  grdListagem.Columns.Add();
  grdListagem.Columns[3].FieldName:='valorVenda';
  grdListagem.Columns[3].Width:=150;

end;

procedure TfrmCadProduto.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;

  if Assigned(oProduto) then
     FreeAndNil(oProduto);
end;

procedure TfrmCadProduto.btnGravarClick(Sender: TObject);
begin

  oProduto.produtoId  := edtProdutoId.Text;
  oProduto.descricao  := edtDescricao.Text;
  oProduto.gtin       := edtGTIN.Text;
  oProduto.valorVenda := edtValorDaVenda.AsFloat;
  oProduto.qtdeEstoque:= edtQtdeEstoque.AsFloat;
  oProduto.dataUltimaCompra:= edtDataUltimaVenda.Date;
  oProduto.foto.Assign(imgFoto.Picture);

  inherited;
end;

procedure TfrmCadProduto.btnLimparClick(Sender: TObject);
begin
  LimparImagem(imgFoto);
end;

procedure TfrmCadProduto.edtGTINChange(Sender: TObject);
begin
  barGTIN.Text:=TLabeledEdit(Sender).Text;
end;

procedure TfrmCadProduto.edtGTINExit(Sender: TObject);
begin
  if (TLabeledEdit(Sender).Text)=EmptyStr then
     exit;

  oValidador.TipoDocto:=docGTIN;
  oValidador.Documento:=TLabeledEdit(Sender).Text;
  if not (oValidador.Validar) then begin
    MessageOK('Código GTIN Inválido',mtInformation);
    TLabeledEdit(Sender).SetFocus;
  end;
end;

procedure TfrmCadProduto.btnAlterarClick(Sender: TObject);
begin
  if oProduto.Selecionar(QryListagem.FieldByName('produtoId').AsString) then begin
    edtProdutoId.Text := oProduto.produtoId;
    edtDescricao.Text := oProduto.descricao;
    edtGTIN.Text      := oProduto.gtin;
    edtValorDaVenda.AsFloat := oProduto.valorVenda;
    edtQtdeEstoque.AsFloat  := oProduto.qtdeEstoque;
    edtDataUltimaVenda.Date := oProduto.dataUltimaCompra;
    imgFoto.Picture.Assign(oProduto.foto);
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;

end;

procedure TfrmCadProduto.btnCarregarClick(Sender: TObject);
begin
  CarregarImagem(imgFoto);
end;

procedure TfrmCadProduto.FormCreate(Sender: TObject);
begin
  oProduto:= TProduto.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='Descricao';

  inherited;
end;

function TfrmCadProduto.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if oProduto.GTINExiste(oProduto.gtin, oProduto.produtoId, aEstadoDoCadastro) then
     abort;

  if EstadoDoCadastro=ecInserir then
     Result:= oProduto.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oProduto.Atualizar;
end;

function TfrmCadProduto.Apagar: boolean;
begin
  if oProduto.Selecionar(QryListagem.FieldByName('produtoId').AsString) then
     Result:= oProduto.Apagar
end;
{$endRegion}
end.

