unit uUsuarioVsAcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DBGrids, ZDataset, Grids;

type

  { TfrmUsuarioVsAcoes }

  TfrmUsuarioVsAcoes = class(TForm)
    btnFechar: TBitBtn;
    grdUsuario: TDBGrid;
    DtsAcoes: TDataSource;
    dtsUsuario: TDataSource;
    grdAcoes: TDBGrid;
    imgIcon: TImage;
    lblTitulo: TLabel;
    pnlAcoes: TPanel;
    pnlRodape: TPanel;
    pnlTitulo: TPanel;
    pnlUsuarios: TPanel;
    QryAcoes: TZQuery;
    QryUsuario: TZQuery;
    Splitter1: TSplitter;
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdAcoesDblClick(Sender: TObject);
    procedure grdAcoesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grdAcoesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure QryUsuarioAfterScroll(DataSet: TDataSet);
  private
    procedure SelecionarAcoesAcessoPorUsuario;
    procedure ConfigurarCampos;

  public

  end;

var
  frmUsuarioVsAcoes: TfrmUsuarioVsAcoes;

implementation

{$R *.lfm}

uses uConexao;

{ TfrmUsuarioVsAcoes }

procedure TfrmUsuarioVsAcoes.SelecionarAcoesAcessoPorUsuario;
begin
  QryAcoes.Close;
  QryAcoes.ParamByName('usuarioId').AsString := QryUsuario.FieldByName('usuarioID').AsString;
  QryAcoes.Open;
end;

procedure TfrmUsuarioVsAcoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarioVsAcoes.ConfigurarCampos;
begin
  QryAcoes.Fields[0].DisplayLabel:='Cód. Usuário';
  QryAcoes.Fields[1].DisplayLabel:='Código';
  QryAcoes.Fields[2].DisplayLabel:='Descrição';
  QryAcoes.Fields[3].DisplayLabel:='Ativo';

  QryUsuario.Fields[0].DisplayLabel:='Usuário';
  QryUsuario.Fields[1].DisplayLabel:='Cod. Usuário';

  grdUsuario.Columns.Add();
  grdUsuario.Columns[0].FieldName:='Nome';
  grdUsuario.Columns[0].Width:=200;

  grdAcoes.Columns.Add();
  grdAcoes.Columns[0].FieldName:='descricao';
  grdAcoes.Columns[0].Width:=553;
end;

procedure TfrmUsuarioVsAcoes.FormShow(Sender: TObject);
begin
  Try
    QryUsuario.DisableControls;
    QryUsuario.Open;
    ConfigurarCampos;
    SelecionarAcoesAcessoPorUsuario;
  Finally
    QryUsuario.EnableControls;
  End;
end;

procedure TfrmUsuarioVsAcoes.grdAcoesDblClick(Sender: TObject);
var Qry:TZQuery;
    bmRegistroAtual:TBookmark;
begin
  try
    bmRegistroAtual := QryAcoes.GetBookMark; //Marcar o Registro Selecionado
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=DtmPrincipal.ConDataBase;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE usuariosAcaoAcesso '+
                '   SET ativo=:ativo '+
                ' WHERE usuarioId=:usuarioId '+
                '   AND acaoAcessoId=:acaoAcessoId ');
    Qry.ParamByName('usuarioId').AsString     :=QryAcoes.FieldByName('usuarioId').AsString;
    Qry.ParamByName('acaoAcessoId').AsString  :=QryAcoes.FieldByName('acaoAcessoId').AsString;
    if QryAcoes.FieldByName('ativo').AsInteger = 1 then
       Qry.ParamByName('ativo').AsInteger     :=0
    else
       Qry.ParamByName('ativo').AsInteger     :=1;

    Try
      DtmPrincipal.ConDataBase.StartTransaction;
      Qry.ExecSQL;
      DtmPrincipal.ConDataBase.Commit;
    Except
      DtmPrincipal.ConDataBase.Rollback;
    End;

  finally
    SelecionarAcoesAcessoPorUsuario;
    QryAcoes.GotoBookMark(bmRegistroAtual);  //Faz o Retorno do Registro depois que a query foi fechada e aberta
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;

end;

procedure TfrmUsuarioVsAcoes.grdAcoesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TfrmUsuarioVsAcoes.grdAcoesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  If QryAcoes.FieldByName('ativo').AsInteger = 0  then
  begin
    (Sender AS TDBGrid).Canvas.Font.Color:= clWhite;
    (Sender AS TDBGrid).Canvas.Brush.Color:=clRed
  end;
end;


procedure TfrmUsuarioVsAcoes.QryUsuarioAfterScroll(DataSet: TDataSet);
begin
  SelecionarAcoesAcessoPorUsuario;
end;

end.

