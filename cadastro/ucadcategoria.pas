unit ucadcategoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, MaskEdit, DBGrids, ACBrEnterTab, ACBrValidador,
  utelaheranca, cCadCategoria, uEnum, uConexao, db, ZDataset;

type

  { TfrmCadCategoria }

  TfrmCadCategoria = class(TfrmTelaHeranca)
    edtDescricao: TLabeledEdit;
    edtCategoriaId: TLabeledEdit;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    oCategoria:TCategoria;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;


var
  frmCadCategoria: TfrmCadCategoria;

implementation

{$R *.lfm}


{$region 'Metodos Override'}
procedure TfrmCadCategoria.ConfigurarCampos;
begin
 qryListagem.Fields[0].DisplayLabel:='Código';
 qryListagem.Fields[1].DisplayLabel:='Descrição';

 grdListagem.Columns.Add();
 grdListagem.Columns[0].FieldName:='categoriaId';
 grdListagem.Columns[0].Width:=250;

 grdListagem.Columns.Add();
 grdListagem.Columns[1].FieldName:='descricao';
 grdListagem.Columns[1].Width:=400;

end;

procedure TfrmCadCategoria.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  if Assigned(oCategoria) then
     FreeAndNil(oCategoria);
end;

procedure TfrmCadCategoria.btnGravarClick(Sender: TObject);
begin

  oCategoria.categoriaId:=edtCategoriaId.Text;
  oCategoria.descricao:=edtDescricao.Text;

  inherited;
end;

procedure TfrmCadCategoria.btnAlterarClick(Sender: TObject);
begin
  if oCategoria.Selecionar(QryListagem.FieldByName('categoriaId').AsString) then begin
     edtCategoriaId.Text := oCategoria.categoriaId;
     edtDescricao.Text   := oCategoria.descricao;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;
  inherited;
end;

procedure TfrmCadCategoria.FormCreate(Sender: TObject);
begin
  inherited;
  oCategoria:=TCategoria.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='descricao';
end;

function TfrmCadCategoria.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
 if EstadoDoCadastro=ecInserir then
    Result:= oCategoria.Inserir
 else if EstadoDoCadastro=ecAlterar then
    Result:= oCategoria.Atualizar;
end;

function TfrmCadCategoria.Apagar: boolean;
begin
 if oCategoria.Selecionar(QryListagem.FieldByName('categoriaId').AsString) then
    Result:= oCategoria.Apagar
end;
{$endRegion}

end.

