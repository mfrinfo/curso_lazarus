unit uCadAcaoAcesso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DbCtrls, ComCtrls, MaskEdit, DBGrids, utelaheranca, db,
  cAcaoAcesso, uEnum, uConexao;

type

  { TfrmCadAcaoAcesso }

  TfrmCadAcaoAcesso = class(TfrmTelaHeranca)
    edtacaoAcessoId: TLabeledEdit;
    edtChave: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    oAcaoAcesso:TAcaoAcesso;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;

var
  frmCadAcaoAcesso: TfrmCadAcaoAcesso;

implementation

{$R *.lfm}

function TfrmCadAcaoAcesso.Apagar: Boolean;
begin
  if oAcaoAcesso.Selecionar(QryListagem.FieldByName('acaoAcessoId').AsString) then begin
     Result:=oAcaoAcesso.Apagar;
  end;
end;

procedure TfrmCadAcaoAcesso.ConfigurarCampos;
begin
  qryListagem.Fields[0].DisplayLabel:='Código';
  qryListagem.Fields[1].DisplayLabel:='Descrição';
  qryListagem.Fields[2].DisplayLabel:='Descrição';

  grdListagem.Columns.Add();
  grdListagem.Columns[0].FieldName:='acaoAcessoId';
  grdListagem.Columns[0].Width:=250;

  grdListagem.Columns.Add();
  grdListagem.Columns[1].FieldName:='descricao';
  grdListagem.Columns[1].Width:=300;

  grdListagem.Columns.Add();
  grdListagem.Columns[2].FieldName:='chave';
  grdListagem.Columns[2].Width:=260;
end;

procedure TfrmCadAcaoAcesso.FormCreate(Sender: TObject);
begin
  inherited;
  oAcaoAcesso:=TAcaoAcesso.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='acaoAcessoId';
end;

procedure TfrmCadAcaoAcesso.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadAcaoAcesso.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  if Assigned(oAcaoAcesso) then
     FreeAndNil(oAcaoAcesso);
end;

procedure TfrmCadAcaoAcesso.btnNovoClick(Sender: TObject);
begin
  inherited;
   edtDescricao.SetFocus;
end;

procedure TfrmCadAcaoAcesso.btnGravarClick(Sender: TObject);
begin
  if edtacaoAcessoId.Text<>EmptyStr then
     oAcaoAcesso.codigo:=edtacaoAcessoId.Text
  else
     oAcaoAcesso.codigo:=EmptyStr;

  if oAcaoAcesso.ChaveExiste(edtChave.Text, oAcaoAcesso.codigo) then begin
    MessageDlg('Chave já cadastrado', mtInformation, [mbok],0);
    edtChave.SetFocus;
    abort;
  end;

  oAcaoAcesso.descricao :=edtDescricao.Text;
  oAcaoAcesso.chave     :=edtChave.Text;
  inherited;
end;

procedure TfrmCadAcaoAcesso.btnAlterarClick(Sender: TObject);
begin
  if oAcaoAcesso.Selecionar(QryListagem.FieldByName('acaoAcessoId').AsString) then begin
     edtacaoAcessoId.Text:=oAcaoAcesso.codigo;
     edtDescricao.Text   :=oAcaoAcesso.descricao;
     edtChave.Text       :=oAcaoAcesso.chave;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

function TfrmCadAcaoAcesso.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if EstadoDoCadastro=ecInserir then
     Result:= oAcaoAcesso.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oAcaoAcesso.Atualizar;
end;

end.

