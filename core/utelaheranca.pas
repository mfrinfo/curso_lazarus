unit utelaheranca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DbCtrls, ComCtrls, MaskEdit, DBGrids, ZDataset, uEnum, uUtils;

type

  { TfrmTelaHeranca }

  TfrmTelaHeranca = class(TForm)
    btnAlterar: TBitBtn;
    btnApagar: TBitBtn;
    btnCancelar: TBitBtn;
    btnFechar: TBitBtn;
    btnGravar: TBitBtn;
    btnNavigator: TDBNavigator;
    btnNovo: TBitBtn;
    btnPesquisa: TBitBtn;
    dtsListagem: TDataSource;
    grdListagem: TDBGrid;
    imgIcon: TImage;
    lblIndice: TLabel;
    lblTitulo: TLabel;
    mskPesquisa: TMaskEdit;
    pgcPrincipal: TPageControl;
    pnlBotoes: TPanel;
    pnlListagemCentro: TPanel;
    pnlListagemTopo: TPanel;
    pnlTitulo: TPanel;
    qryListagem: TZQuery;
    tabListagem: TTabSheet;
    tabManutencao: TTabSheet;
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
    procedure grdListagemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdListagemTitleClick(Column: TColumn);
    procedure mskPesquisaChange(Sender: TObject);

  private
    SelectOriginal:string;
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
    procedure ControlarBotoes(aBtnNovo, aBtnAlterar, aBtnCancelar, aBtnGravar,
      aBtnApagar: TBitBtn; aBtnNavigator: TDBNavigator;
      aPgcPrincipal: TPageControl; aFlag: Boolean);

    procedure ControlaIndiceTab(aPgcPrincipal:TPageControl; i: Integer);
    procedure DesabilitarEditPK;
    procedure ExibirLabelIndice(aCampo: string; aLabel: TLabel);
    function ExisteCampoObrigatorio: Boolean;
    procedure LimparEdits;
    function RetornarCampoTraduzido(Campo: string): string;

  public
    EstadoDoCadastro:TEstadoDoCadastro;
    IndiceAtual:string;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; virtual;
    function Apagar:Boolean; virtual;
    procedure ConfigurarCampos; virtual;
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.lfm}

{ TfrmTelaHeranca }

uses uPrincipal, uConexao, cUsuarioLogado;

{$region 'OBSERVAÇÕES'}
//TAG: 1 - Chave Primaria
//TAG: 2 - Campos Obrigatórios
{$endregion}

{$region 'Function/Procedure DE CONTROLE'}
procedure TfrmTelaHeranca.ControlarBotoes(aBtnNovo, aBtnAlterar, aBtnCancelar, aBtnGravar,
                          aBtnApagar:TBitBtn; aBtnNavigator:TDBNavigator;
                          aPgcPrincipal:TPageControl; aFlag:Boolean);
begin
  btnNovo.Enabled      :=aFlag;
  btnApagar.Enabled    :=aFlag;
  btnAlterar.Enabled   :=aFlag;
  btnNavigator.Enabled :=aFlag;
  pgcPrincipal.Pages[0].TabVisible:=aFlag;

  btnCancelar.Enabled  :=not(aFlag);
  btnGravar.Enabled    :=not(aFlag);
end;

procedure TfrmTelaHeranca.ControlaIndiceTab(aPgcPrincipal:TPageControl; i: Integer);
begin
  if (pgcPrincipal.Pages[i].TabVisible) then
      pgcPrincipal.TabIndex:=0;
end;

function TfrmTelaHeranca.RetornarCampoTraduzido(Campo: string):string;
var i:Integer;
begin
  for I := 0 to QryListagem.FieldCount-1 do begin
    if LowerCase(QryListagem.Fields[i].FieldName) = LowerCase(Campo) then begin
       Result:=QryListagem.Fields[i].DisplayLabel;
       Break;
    end;
  end;
end;

function TfrmTelaHeranca.ExisteCampoObrigatorio:Boolean;
var i:Integer;
begin
  Result:=False;
  for I := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
       if (TLabeledEdit(Components[i]).Tag = 2) and (TLabeledEdit(Components[i]).Text = EmptyStr) then begin
          MessageOK(TLabeledEdit(Components[i]).EditLabel.Caption + ' é um campo obrigatório' ,mtInformation);
          TLabeledEdit(Components[i]).SetFocus;
          Result:=True;
          Break;
       end;
    end;
  end;
end;

procedure TfrmTelaHeranca.DesabilitarEditPK;
var i:Integer;
begin
  for I := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
       if (TLabeledEdit(Components[i]).Tag = 1) then begin
          TLabeledEdit(Components[i]).Enabled:=false;
          Break;
       end;
    end;
  end;
end;

procedure TfrmTelaHeranca.LimparEdits;
Var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then
      TLabeledEdit(Components[i]).Text:=EmptyStr
    else if (Components[i] is TEdit) then
      TEdit(Components[i]).Text:=''
    else if (Components[i] is TDBLookupComboBox) then
      TDBLookupComboBox(Components[i]).KeyValue:=Null
    else if (Components[i] is TMemo) then
      TMemo(Components[i]).Text:=''
    else if (Components[i] is TMaskEdit) then
      TMaskEdit(Components[i]).Text:='';

  end;
end;

procedure TfrmTelaHeranca.ExibirLabelIndice(aCampo: string; aLabel:TLabel);
begin
  aLabel.Caption:=RetornarCampoTraduzido(aCampo);
end;
{$endregion}


{$region 'Métodos Virtual'}
function TfrmTelaHeranca.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
   if (aEstadoDoCadastro=ecInserir) then
       showmessage('Inserir')
   else if (EstadoDoCadastro=ecAlterar) then
       showmessage('Alterado')
   else
      showmessage('Nada aconteceu');
   result:=true;
end;

function TfrmTelaHeranca.Apagar: Boolean;
begin
  showmessage('Apagar');
  result:=true;
end;

procedure TfrmTelaHeranca.ConfigurarCampos;
begin

end;

{$endregion}

procedure TfrmTelaHeranca.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  try
    QryListagem.Close;
  finally
    CloseAction:=caFree;
    Self:=Nil;
  end;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
begin
  QryListagem.Connection:=DtmPrincipal.ConDataBase;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
  grdListagem.Options:=[dgTitles,
                        dgIndicator,
                        dgColumnResize,
                        dgColLines,
                        dgRowLines,
                        dgTabs,
                        dgRowSelect,
                        dgAlwaysShowSelection,
                        dgCancelOnExit];
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
begin
   if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConDataBase) then
   begin
      MessageOK('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning);
      Abort;
   end;

   if (ExisteCampoObrigatorio) then
      Abort;

   Try
     if Gravar(EstadoDoCadastro) then begin
        ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
        ControlaIndiceTab(pgcPrincipal, 0);
        EstadoDoCadastro:=ecNenhum;
        LimparEdits;
        QryListagem.Refresh;
     end
     else begin
       MessageERROR('Erro ao Gravar');
     end;
   Finally
   End;

end;

procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConDataBase) then begin
     MessageOK('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning);
     Abort;
  end;

  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, false);
  EstadoDoCadastro:=ecInserir;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnPesquisaClick(Sender: TObject);
var i:Integer;
    TipoCampo:TFieldType;
    NomeCampo:String;
    WhereOrAnd:String;
    CondicaoSQL:String;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConDataBase) then begin
     MessageOK('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning);
     Abort;
  end;

  if mskPesquisa.Text='' then begin
    QryListagem.Close;
    QryListagem.SQL.Clear;
    QryListagem.SQL.Add(SelectOriginal);
    QryListagem.Open;
    Abort;
  end;

  //Localiza o Tipo do Campo
  for I := 0 to QryListagem.FieldCount-1 do  begin
    if QryListagem.Fields[i].FieldName=IndiceAtual then begin
      TipoCampo := QryListagem.Fields[i].DataType;
      if QryListagem.Fields[i].Origin<>'' then  begin
        if Pos('.', QryListagem.Fields[i].Origin) > 0 then
          NomeCampo := QryListagem.Fields[i].Origin
        else
          NomeCampo := QryListagem.Fields[i].Origin+'.'+QryListagem.Fields[i].FieldName
      end
      else
        NomeCampo := QryListagem.Fields[i].FieldName;

      Break;
    end;
  end;

  //Verifica se irá utilizar o Where ou And
  if Pos('where',LowerCase(SelectOriginal)) > 1 then begin
    WhereOrAnd := ' and '
  end
  else begin
    WhereOrAnd := ' where ';
  end;

  if (TipoCampo=ftString) or (TipoCampo=ftWideString) then begin
     CondicaoSQL := WhereOrAnd+' '+ NomeCampo + ' LIKE '+QuotedStr('%'+mskPesquisa.Text+'%');
  end
  else if (TipoCampo = ftInteger) or (TipoCampo = ftSmallint) then begin
     CondicaoSQL := WhereOrAnd+' '+NomeCampo + '='+mskPesquisa.Text
  end
  else if (TipoCampo = ftFloat) or (TipoCampo=ftCurrency) then begin
     CondicaoSQL := WhereOrAnd+' '+NomeCampo + '='+StringReplace(mskPesquisa.Text,',','.',[rfReplaceAll]);
  end
  else if (TipoCampo = ftDate) or (TipoCampo = ftDateTime) then begin
     CondicaoSQL := WhereOrAnd+' '+NomeCampo + '='+QuotedStr(mskPesquisa.Text)
  end;

  QryListagem.Close;
  QryListagem.SQL.Clear;
  QryListagem.SQL.Add(SelectOriginal);
  QryListagem.SQL.Add(CondicaoSQL);
  QryListagem.Open;

  mskPesquisa.Text := '';

end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin
   if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConDataBase) then begin
      MessageOK('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning);
      Abort;
   end;
   ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
   EstadoDoCadastro:=ecAlterar;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
begin
   if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConDataBase) then
   begin
      MessageOK('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning);
      Abort;
   end;

   try
     if (Apagar) then begin
        ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
        ControlaIndiceTab(pgcPrincipal, 0);
        LimparEdits;
        QryListagem.Refresh;
     end
     else begin
       MessageERROR('Erro ao Gravar');
     end;
   finally
     EstadoDoCadastro:=ecNenhum;
   end;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
  ControlaIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecNenhum;
  LimparEdits;
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  Self.Position:=poScreenCenter;
  ControlaIndiceTab(pgcPrincipal, 0);
  DesabilitarEditPK;
  if QryListagem.SQL.Text<>EmptyStr then begin
     SelectOriginal:=QryListagem.SQL.Text;
     QryListagem.Open;
     ConfigurarCampos;
     QryListagem.IndexFieldNames:=IndiceAtual;
     ExibirLabelIndice(IndiceAtual, lblIndice);
  end;
end;

procedure TfrmTelaHeranca.grdListagemDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmTelaHeranca.grdListagemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmTelaHeranca.grdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual                :=Column.FieldName;
  QryListagem.IndexFieldNames:=IndiceAtual;
  ExibirLabelIndice(IndiceAtual, lblIndice);
end;

procedure TfrmTelaHeranca.mskPesquisaChange(Sender: TObject);
begin
  QryListagem.Locate(IndiceAtual, TMaskEdit(Sender).Text,[loPartialKey])
end;

procedure TfrmTelaHeranca.BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
begin
   //Bloqueia o CTRL + DEL
   if (Shift = [ssCtrl]) and (Key = 46) then
      Key := 0;
end;

end.

