unit ucadconfiguracao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, MaskEdit, DBGrids, ACBrCEP, rxcurredit,
  utelaheranca, cCadConfiguracao, uEnum, uConexao, db, ZDataset, uUtils;

type

  { TfrmCadConfiguracao }

  TfrmCadConfiguracao = class(TfrmTelaHeranca)
    ACBrBuscaCEP: TACBrCEP;
    edtBuscarCEP: TBitBtn;
    edtBairro: TLabeledEdit;
    edtCEP: TMaskEdit;
    edtCertificadoDigital: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtCNPJ: TMaskEdit;
    edtConfiguracaoId: TLabeledEdit;
    EdtIBGEMunicipio: TLabeledEdit;
    edtIdTokenNFCe: TLabeledEdit;
    edtIE: TMaskEdit;
    edtLogradouro: TLabeledEdit;
    edtNomeEmpresa: TLabeledEdit;
    edtNroNFCe: TCurrencyEdit;
    edtNumero: TLabeledEdit;
    edtSenhaCertificado: TLabeledEdit;
    edtSerieNFCe: TCurrencyEdit;
    edtTokenNfce: TLabeledEdit;
    edtUf: TLabeledEdit;
    lblCNPJ: TLabel;
    lblIe: TLabel;
    lblDocumento2: TLabel;
    lblSerieNFCe: TLabel;
    lblNroUltimaNFCe: TLabel;
    OpenDialog1: TOpenDialog;
    rdgTipoDeEmissao: TRadioGroup;
    btnLocalizaCertificadoDigital: TSpeedButton;
    procedure ACBrBuscaCEPBuscaEfetuada(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnLocalizaCertificadoDigitalClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure edtBuscarCEPClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    oConfiguracao:TConfiguracao;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;

var
  frmCadConfiguracao: TfrmCadConfiguracao;

implementation

{$R *.lfm}

{$region 'Metodos Override'}
procedure TfrmCadConfiguracao.ConfigurarCampos;
begin
  qryListagem.Fields[0].DisplayLabel:='Código';
  qryListagem.Fields[1].DisplayLabel:='Nome da Empresa';
  qryListagem.Fields[2].DisplayLabel:='CNPJ';

  grdListagem.Columns.Add();
  grdListagem.Columns[0].FieldName:='configuracaoId';
  grdListagem.Columns[0].Width:=180;

  grdListagem.Columns.Add();
  grdListagem.Columns[1].FieldName:='empresa';
  grdListagem.Columns[1].Width:=400;

  grdListagem.Columns.Add();
  grdListagem.Columns[2].FieldName:='cnpj';
  grdListagem.Columns[2].Width:=180;

end;

procedure TfrmCadConfiguracao.btnAlterarClick(Sender: TObject);
begin
  if oConfiguracao.Selecionar(QryListagem.FieldByName('configuracaoId').AsString) then begin
    edtConfiguracaoId.Text := oConfiguracao.configuracaoId;
    edtNomeEmpresa.Text:= oConfiguracao.empresa;
    edtCNPJ.Text := oConfiguracao.cnpj;
    edtIE.Text := oConfiguracao.ie;
    edtCEP.Text := oConfiguracao.cep;
    edtNumero.Text := oConfiguracao.numero;
    edtLogradouro.Text := oConfiguracao.logradouro;
    edtBairro.Text := oConfiguracao.bairro;
    edtCidade.Text := oConfiguracao.cidade;
    edtUf.Text := oConfiguracao.uf;
    EdtIBGEMunicipio.Text := oConfiguracao.codibge;
    edtTokenNfce.Text := oConfiguracao.tokenNfce;
    edtIdTokenNFCe.Text:= oConfiguracao.idTokenNfce;
    edtCertificadoDigital.Text:=oConfiguracao.caminhoCertificadoDigital;
    edtSenhaCertificado.Text:=oConfiguracao.senha;
    rdgTipoDeEmissao.ItemIndex := oConfiguracao.tipoEmissaoEletronica;
    edtNroNFCe.Value:=oConfiguracao.nroNFCe;
    edtSerieNFCe.Value:=oConfiguracao.nroSerieNFCe;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;
  inherited;
end;

procedure TfrmCadConfiguracao.ACBrBuscaCEPBuscaEfetuada(Sender: TObject);
begin
  if ACBrBuscaCEP.Enderecos.Count < 1 then
     MessageOK('Nenhum Endereço encontrado',mtInformation);

  edtLogradouro.Text:=ACBrBuscaCEP.Enderecos[0].Logradouro;
  edtBairro.Text:=ACBrBuscaCEP.Enderecos[0].Bairro;
  edtCidade.Text:=ACBrBuscaCEP.Enderecos[0].Municipio;
  edtUf.Text:=ACBrBuscaCEP.Enderecos[0].UF;
  EdtIBGEMunicipio.Text:=ACBrBuscaCEP.Enderecos[0].IBGE_Municipio;
end;

procedure TfrmCadConfiguracao.btnGravarClick(Sender: TObject);
begin
  oConfiguracao.configuracaoId := edtConfiguracaoId.Text;
  oConfiguracao.empresa        := edtNomeEmpresa.Text;
  oConfiguracao.cnpj           := edtCNPJ.Text;
  oConfiguracao.ie             := edtIE.Text;
  oConfiguracao.cep            := edtCEP.Text;
  oConfiguracao.numero         := edtNumero.Text;
  oConfiguracao.logradouro     := edtLogradouro.Text;
  oConfiguracao.cidade         := edtCidade.Text;
  oConfiguracao.bairro         := edtBairro.Text;
  oConfiguracao.uf             := edtUf.Text;
  oConfiguracao.codibge        := EdtIBGEMunicipio.Text;
  oConfiguracao.tokenNfce      := edtTokenNfce.Text;
  oConfiguracao.idTokenNfce    := edtIdTokenNFCe.Text;
  oConfiguracao.caminhoCertificadoDigital:=edtCertificadoDigital.Text;
  oConfiguracao.senha          :=edtSenhaCertificado.Text;
  case rdgTipoDeEmissao.ItemIndex of
    0:oConfiguracao.tipoEmissaoEletronica:=0;
    1:oConfiguracao.tipoEmissaoEletronica:=1;
    2:oConfiguracao.tipoEmissaoEletronica:=2;
  end;
  oConfiguracao.nroNFCe:=edtNroNFCe.Value.ToString.ToInteger;
  oConfiguracao.nroSerieNFCe:=edtSerieNFCe.Value.ToString.ToInteger;

  inherited;
end;

procedure TfrmCadConfiguracao.btnLocalizaCertificadoDigitalClick(Sender: TObject
  );
begin
  OpenDialog1.Title := 'Selecione o Certificado';
  OpenDialog1.DefaultExt := '*.pfx';
  OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtCertificadoDigital.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmCadConfiguracao.btnNovoClick(Sender: TObject);
begin
  if (qryListagem.FieldByName('Qtde').AsInteger >= 1) then  begin
    MessageOK('Já existe uma configuração cadastrada', mtWarning);
    abort;
  end;

  inherited;
end;

procedure TfrmCadConfiguracao.edtBuscarCEPClick(Sender: TObject);
begin
  try
     ACBrBuscaCEP.BuscarPorCEP(edtCEP.Text);
  except
     On E : Exception do
     begin
        MessageERROR(E.Message);
     end ;
  end ;
end;

procedure TfrmCadConfiguracao.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  if Assigned(oConfiguracao) then
     FreeAndNil(oConfiguracao);
end;

procedure TfrmCadConfiguracao.FormCreate(Sender: TObject);
begin
  oConfiguracao:= TConfiguracao.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='configuracaoId';
  inherited;
end;

function TfrmCadConfiguracao.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if EstadoDoCadastro=ecInserir then
     Result:= oConfiguracao.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oConfiguracao.Atualizar;
end;

function TfrmCadConfiguracao.Apagar: boolean;
begin
  if oConfiguracao.Selecionar(QryListagem.FieldByName('configuracaoId').AsString) then
     Result:= oConfiguracao.Apagar
end;
{$endRegion}


end.

