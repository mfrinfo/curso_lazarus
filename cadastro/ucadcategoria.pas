unit uCadCategoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, DbCtrls, ComCtrls, MaskEdit, DBGrids, utelaheranca, db,
  ZDataset, cCadCategoria, uEnum;

type

  { TfrmCadCategoria }

  TfrmCadCategoria = class(TfrmTelaHeranca)
    edtCategoriaId: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    qryListagemcategoriaId: TStringField;
    qryListagemdescricao: TStringField;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdListagemDblClick(Sender: TObject);
    procedure grdListagemTitleClick(Column: TColumn);
    procedure mskPesquisaChange(Sender: TObject);
  private
    oCategoria:TCategoria;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
  public

  end;

var
  frmCadCategoria: TfrmCadCategoria;

implementation

{$R *.lfm}

uses uConexao;

{ TfrmCadCategoria }

procedure TfrmCadCategoria.FormCreate(Sender: TObject);
begin

  inherited;

  oCategoria:=TCategoria.Create(DtmPrincipal.ConDataBase);

  IndiceAtual:='descricao';
end;

procedure TfrmCadCategoria.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadCategoria.grdListagemDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadCategoria.grdListagemTitleClick(Column: TColumn);
begin
  inherited;
end;

procedure TfrmCadCategoria.mskPesquisaChange(Sender: TObject);
begin
  inherited;
end;

function TfrmCadCategoria.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if EstadoDoCadastro=ecInserir then
     Result:= oCategoria.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oCategoria.Atualizar;
end;

function TfrmCadCategoria.Apagar: Boolean;
begin
  Result:=false;
  if oCategoria.Selecionar(QryListagem.FieldByName('categoriaId').AsString) then
     Result:=oCategoria.Apagar(QryListagem.FieldByName('categoriaId').AsString);

end;

procedure TfrmCadCategoria.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
   if Assigned(oCategoria) then
     FreeAndNil(oCategoria);

   inherited;
end;

procedure TfrmCadCategoria.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDescricao.SetFocus;
end;

procedure TfrmCadCategoria.btnPesquisaClick(Sender: TObject);
begin
 inherited;
end;

procedure TfrmCadCategoria.btnGravarClick(Sender: TObject);
begin
   if edtCategoriaId.Text<>EmptyStr then
      oCategoria.codigo:=edtCategoriaId.Text
   else
      oCategoria.codigo:=EmptyStr;

   oCategoria.descricao:=edtDescricao.Text;

   inherited;
end;

procedure TfrmCadCategoria.btnAlterarClick(Sender: TObject);
begin
   if oCategoria.Selecionar(QryListagem.FieldByName('categoriaId').AsString) then begin
      edtCategoriaId.Text:=oCategoria.codigo;
      edtDescricao.Text:=oCategoria.descricao;
   end
   else begin
     btnCancelar.Click;
     Abort;
   end;

   inherited;
end;

procedure TfrmCadCategoria.btnApagarClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadCategoria.btnCancelarClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadCategoria.btnFecharClick(Sender: TObject);
begin
  inherited;
end;

initialization
   RegisterClass(TfrmCadCategoria);

end.

