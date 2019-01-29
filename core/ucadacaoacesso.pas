unit uCadAcaoAcesso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DbCtrls, ComCtrls, MaskEdit, DBGrids, utelaheranca, db,
  ZDataset, cAcaoAcesso, uEnum, uConexao;

type

  { TfrmCadAcaoAcesso }

  TfrmCadAcaoAcesso = class(TfrmTelaHeranca)
    edtacaoAcessoId: TLabeledEdit;
    edtChave: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    qryListagemacaoAcessoId: TStringField;
    qryListagemchave: TStringField;
    qryListagemdescricao: TStringField;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    oAcaoAcesso:TAcaoAcesso;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
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

procedure TfrmCadAcaoAcesso.FormCreate(Sender: TObject);
begin
  inherited;
  oAcaoAcesso:=TAcaoAcesso.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='acaoAcessoId';
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

