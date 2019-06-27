unit ucadcliente;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ComCtrls, MaskEdit, DBGrids, EditBtn, Spin, SpinEx,
  ACBrValidador, ACBrCEP, utelaheranca, db, ZDataset, cCadCliente, uEnum,
  uConexao, uUtils;

type

  { TfrmCadCliente }

  TfrmCadCliente = class(TfrmTelaHeranca)
    ACBrBuscaCEP: TACBrCEP;
    BitBtn1: TBitBtn;
    edtClienteId: TLabeledEdit;
    edtCEP: TMaskEdit;
    edtNome: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtNumero: TLabeledEdit;
    edtUf: TLabeledEdit;
    lblDocumento: TLabel;
    edtDocumento: TMaskEdit;
    lblDocumento1: TLabel;
    rdgTipoDePessoa: TRadioGroup;
    procedure ACBrBuscaCEPBuscaEfetuada(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtDocumentoExit(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rdgTipoDePessoaClick(Sender: TObject);
  private

  public
    oCliente:TCliente;
    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override;
    function Apagar:Boolean; override;
    procedure ConfigurarCampos; override;
  end;

var
  frmCadCliente: TfrmCadCliente;

implementation

{$R *.lfm}

{$region 'Metodos Override'}
procedure TfrmCadCliente.ConfigurarCampos;
begin
  qryListagem.Fields[0].DisplayLabel:='Código';
  qryListagem.Fields[1].DisplayLabel:='Nome';
  qryListagem.Fields[2].DisplayLabel:='Documento';

  grdListagem.Columns.Add();
  grdListagem.Columns[0].FieldName:='clientesId';
  grdListagem.Columns[0].Width:=250;

  grdListagem.Columns.Add();
  grdListagem.Columns[1].FieldName:='nome';
  grdListagem.Columns[1].Width:=400;

  grdListagem.Columns.Add();
  grdListagem.Columns[2].FieldName:='documento';
  grdListagem.Columns[2].Width:=150;

end;

procedure TfrmCadCliente.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  if Assigned(oCliente) then
     FreeAndNil(oCliente);
end;

procedure TfrmCadCliente.btnGravarClick(Sender: TObject);
begin
  oCliente.clientesId:=edtClienteId.Text;
  oCliente.nome:=edtNome.Text;
  if (rdgTipoDePessoa.ItemIndex=0) then
    oCliente.tipoPessoa:='F'
  else
    oCliente.tipoPessoa:='J';
  oCliente.documento:=edtDocumento.Text;
  oCliente.cep:=edtCEP.Text;
  oCliente.logradouro:=edtLogradouro.Text;
  oCliente.numero:=edtNumero.Text;
  oCliente.bairro:=edtBairro.Text;
  oCliente.cidade:=edtCidade.Text;
  oCliente.uf:=edtUf.text;
  oCliente.email:=edtEmail.Text;

  inherited;
end;

procedure TfrmCadCliente.edtDocumentoExit(Sender: TObject);
begin
  if TMaskEdit(Sender).Text=EmptyStr then
     exit;

  if (rdgTipoDePessoa.ItemIndex=0) then begin
    oValidador.TipoDocto:=docCPF;
  end
  else begin
    oValidador.TipoDocto:=docCNPJ;
  end;

  oValidador.Documento:=TMaskEdit(Sender).Text;

  if not oValidador.Validar then begin
    MessageOK('Documento Inválido' ,mtInformation);
    edtDocumento.SetFocus;
  end;
end;

procedure TfrmCadCliente.edtEmailEnter(Sender: TObject);
begin
  oValidador.TipoDocto:=docEmail;
end;

procedure TfrmCadCliente.edtEmailExit(Sender: TObject);
begin
  if TLabeledEdit(Sender).Text=EmptyStr then
    exit;

  oValidador.Documento:=TLabeledEdit(Sender).Text;
  if not oValidador.Validar then begin
    MessageOK('Email Inválido' ,mtInformation);
    edtEmail.SetFocus;
  end;
end;

procedure TfrmCadCliente.btnCancelarClick(Sender: TObject);
begin
  inherited;
end;

procedure TfrmCadCliente.btnAlterarClick(Sender: TObject);
begin
  if oCliente.Selecionar(QryListagem.FieldByName('clientesId').AsString) then begin
     edtClienteId.Text   := oCliente.clientesId;
     edtNome.Text        := oCliente.nome;
     if (oCliente.tipoPessoa='F') then begin
        rdgTipoDePessoa.ItemIndex:=0;
        oValidador.TipoDocto:=docCPF;
     end
     else begin
       rdgTipoDePessoa.ItemIndex:=1;
       oValidador.TipoDocto:=docCNPJ;
     end;

     edtDocumento.Text:= oCliente.documento;
     edtCEP.Text := oCliente.cep;
     edtLogradouro.Text := oCliente.logradouro;
     edtNumero.Text :=oCliente.numero;
     edtBairro.Text := oCliente.bairro;
     edtCidade.Text := oCliente.cidade;
     edtUf.text := oCliente.uf;
     edtEmail.Text := oCliente.email;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadCliente.BitBtn1Click(Sender: TObject);
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

procedure TfrmCadCliente.ACBrBuscaCEPBuscaEfetuada(Sender: TObject);
begin
  if ACBrBuscaCEP.Enderecos.Count < 1 then
     MessageOK('Nenhum Endereço encontrado',mtInformation);

  edtLogradouro.Text:=ACBrBuscaCEP.Enderecos[0].Logradouro;
  edtBairro.Text:=ACBrBuscaCEP.Enderecos[0].Bairro;
  edtCidade.Text:=ACBrBuscaCEP.Enderecos[0].Municipio;
  edtUf.Text:=ACBrBuscaCEP.Enderecos[0].UF;

end;

procedure TfrmCadCliente.FormCreate(Sender: TObject);
begin
  inherited;
  oCliente:=TCliente.Create(DtmPrincipal.ConDataBase);
  IndiceAtual:='nome';
end;

procedure TfrmCadCliente.rdgTipoDePessoaClick(Sender: TObject);
begin
  if (TRadioGroup(Sender).ItemIndex=0) then begin
    lblDocumento.Caption:='CPF';
    oValidador.TipoDocto:=docCPF;
  end
  else begin
    lblDocumento.Caption:='CNPJ';
    oValidador.TipoDocto:=docCNPJ;
  end;
end;

function TfrmCadCliente.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  if EstadoDoCadastro=ecInserir then
     Result:= oCliente.Inserir
  else if EstadoDoCadastro=ecAlterar then
     Result:= oCliente.Atualizar;
end;

function TfrmCadCliente.Apagar: boolean;
begin
  if oCliente.Selecionar(QryListagem.FieldByName('clientesId').AsString) then
     Result:= oCliente.Apagar
end;
{$endRegion}

end.

