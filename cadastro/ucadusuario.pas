unit ucadusuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DbCtrls, ComCtrls, MaskEdit, DBGrids, utelaheranca, db,
  cCadUsuario, uEnum, uConexao, uUtils;

type

  { TfrmCadUsuario }

  TfrmCadUsuario = class(TfrmTelaHeranca)
    edtNome: TLabeledEdit;
    edtSenha: TLabeledEdit;
    edtUsuarioId: TLabeledEdit;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    oUsuario:TUsuario;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;

var
  frmCadUsuario: TfrmCadUsuario;

implementation

{$R *.lfm}

uses cAcaoAcesso;

{ TfrmCadUsuario }

procedure TfrmCadUsuario.btnApagarClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadUsuario.btnCancelarClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadUsuario.btnFecharClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadUsuario.btnGravarClick(Sender: TObject);
var aCodigo:String;
begin
  if edtUsuarioId.Text<>EmptyStr then
     aCodigo:=edtUsuarioId.Text
  else
     aCodigo:=EmptyStr;

  if oUsuario.UsuarioExiste(edtNome.Text, aCodigo) then begin
    MessageOK('Usuário já cadastrado', mtInformation);
    edtNome.SetFocus;
    abort;
  end;

  if edtUsuarioId.Text<>EmptyStr then
     oUsuario.codigo:=edtUsuarioId.Text
  else
     oUsuario.codigo:=EmptyStr;

  oUsuario.nome :=edtNome.Text;
  oUsuario.senha:=edtSenha.Text;

  inherited;
end;

procedure TfrmCadUsuario.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtNome.SetFocus;
end;

procedure TfrmCadUsuario.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  if Assigned(oUsuario) then
     FreeAndNil(oUsuario);
end;

procedure TfrmCadUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  oUsuario:=TUsuario.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='nome';
end;

procedure TfrmCadUsuario.btnAlterarClick(Sender: TObject);
begin
  if oUsuario.Selecionar(QryListagem.FieldByName('usuarioID').AsString) then begin
     edtUsuarioId.Text:=oUsuario.codigo;
     edtNome.Text     :=oUsuario.nome;
     edtSenha.Text    :=oUsuario.senha;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

function TfrmCadUsuario.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if EstadoDoCadastro=ecInserir then
     Result:= oUsuario.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oUsuario.Atualizar;

  TAcaoAcesso.PreencherUsuariosVsAcoes(DtmPrincipal.ConDataBase);
end;

function TfrmCadUsuario.Apagar: Boolean;
begin
  if oUsuario.Selecionar(QryListagem.FieldByName('usuarioID').AsString) then begin
     Result:=oUsuario.Apagar;
  end;
end;

procedure TfrmCadUsuario.ConfigurarCampos;
begin
  qryListagem.Fields[0].DisplayLabel:='Código';
  qryListagem.Fields[1].DisplayLabel:='Nome';
  qryListagem.Fields[2].DisplayLabel:='Senha';

  grdListagem.Columns.Add();
  grdListagem.Columns[0].FieldName:='usuarioID';
  grdListagem.Columns[0].Width:=250;

  grdListagem.Columns.Add();
  grdListagem.Columns[1].FieldName:='Nome';
  grdListagem.Columns[1].Width:=500;
end;

end.

