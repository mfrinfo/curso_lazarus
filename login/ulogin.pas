unit uLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, uUtils;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnAcessar: TBitBtn;
    btnFechar: TBitBtn;
    edtSenha: TEdit;
    edtUsuario: TEdit;
    imgIcon: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblTitulo: TLabel;
    pnlTitulo: TPanel;
    procedure btnAcessarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    bFechar:Boolean;
    procedure FecharAplicacao;
    procedure FecharFormulario;
  public

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.lfm}

uses uPrincipal, cCadUsuario, uConexao;

procedure TfrmLogin.FecharAplicacao;
begin
  bFechar := true;
  Application.Terminate;
end;

procedure TfrmLogin.FecharFormulario;
begin
  bFechar := true;
  Close;
end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=bFechar;
end;

procedure TfrmLogin.btnFecharClick(Sender: TObject);
begin
  FecharAplicacao;
end;

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
var oUsuario:TUsuario;
begin
  Try
    oUsuario:=TUsuario.Create(dtmPrincipal.ConDataBase);
    if oUsuario.Logar(edtUsuario.Text,edtSenha.Text) then begin
       oUsuarioLogado.codigo := oUsuario.codigo;
       oUsuarioLogado.nome   := oUsuario.nome;
       oUsuarioLogado.senha  := oUsuario.senha;

       FecharFormulario //Fecha o Formulario do Login
    end
    else begin
      MessageOK('Usuário Inválido',mtInformation);
      edtUsuario.SetFocus;
    end;

  Finally
    if Assigned(oUsuario) then
       FreeAndNil(oUsuario);
  End;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  bFechar:=false;
end;

end.

