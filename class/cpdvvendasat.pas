unit cpdvvendasat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ACBrSAT, ACBrSATClass, ACBrSATExtratoFortesFr,
  pcnConversao, ACBrUtil, uEnum, Forms, BufDataset, db;

type

   { TSAT }

   TSAT = class
     private
      ComponenteSAT:TACBrSAT;
      ComponenteSATExtrato:TACBrSATExtratoFortes;
      F_CNPJ_SW:String;
      F_CNPJ_Emitente:String;
      F_IE_Emitente:String;
      F_IM_Emitente:String;

      F_NomeDll:String;
      F_Modelo :TModeloSAT;
      F_CodigoAtivacao:String;
      F_AssinaturaSW:String;
      F_NumeroCaixa:Integer;

      F_XML_Retorno:AnsiString;
      F_Codigo_Retorno_SAT:Integer;
      F_Mensagem_SAT:String;
      F_Mensagem_SEFAZ:String;

      procedure GetsignAC(var Chave: AnsiString);
      procedure GetCodigoDeAtivacao(var Chave: AnsiString);
     public
      constructor Create;
      destructor Destroy; override;
      function Inicializar:Boolean;
      function ConsultarSAT: string;
      function GerarVenda(bufVenda: TBufDataset; bufPagamento: TBufDataset):Boolean;
      procedure ImprimirCFeSAT;
      procedure ImprimirCFeSATResumido;

     published
      property CNPJ_SW: String         read F_CNPJ_SW          write F_CNPJ_SW;
      property CNPJ_Emitente: String   read F_CNPJ_EMITENTE    write F_CNPJ_EMITENTE;
      property IE_Emitente: String     read F_IE_Emitente      write F_IE_Emitente;
      property IM_Emitente: String     read F_IM_Emitente      write F_IM_Emitente;

      property NomeDll:String          read F_NomeDll          write F_NomeDll;
      property Modelo:TModeloSAT       read F_Modelo           write F_Modelo;
      property AssinaturaSW:String     read F_AssinaturaSW     write F_AssinaturaSW;
      property CodigoAtivacao:String   read F_CodigoAtivacao   write F_CodigoAtivacao;
      property NumeroDoCaixa:Integer   read F_NumeroCaixa      write F_NumeroCaixa;

      property XML_Retorno:String         read F_XML_Retorno         write F_XML_Retorno;
      property Codigo_Retorno_SAT:Integer read F_Codigo_Retorno_SAT  write F_Codigo_Retorno_SAT;
      property Mensagem_SAT:String        read F_Mensagem_SAT        write F_Mensagem_SAT;
      property Mensagem_SEFAZ:String      read F_Mensagem_SEFAZ      write F_Mensagem_SEFAZ;

   end;

implementation

{ TSAT }

constructor TSAT.Create;
begin
  ComponenteSAT:=TACBrSAT.Create(nil);
  ComponenteSATExtrato:=TACBrSATExtratoFortes.Create(nil);
  ComponenteSAT.Extrato:=ComponenteSATExtrato;
end;

destructor TSAT.Destroy;
begin
  if Assigned(ComponenteSAT) then
     FreeAndNil(ComponenteSAT);

  if Assigned(ComponenteSATExtrato) then
    FreeAndNil(ComponenteSATExtrato);

  inherited Destroy;
end;

function TSAT.Inicializar: Boolean;
begin
  if F_Modelo=msStdCall then
     ComponenteSAT.Modelo:=satDinamico_stdcall
  else if F_Modelo=msCdEcl then
     ComponenteSAT.Modelo:=satDinamico_cdecl
  else
     ComponenteSAT.Modelo:=satNenhum;

  ComponenteSAT.NomeDll:=F_NomeDll;
  ComponenteSAT.Config.ide_numeroCaixa:=F_NumeroCaixa;
  ComponenteSAT.Config.ide_tpAmb:=taHomologacao;  //taProducao
  ComponenteSAT.Config.ide_CNPJ :=CNPJ_SW;

  ComponenteSAT.Config.emit_CNPJ:=CNPJ_Emitente;
  ComponenteSAT.Config.emit_IE :=IE_Emitente;
  ComponenteSAT.Config.emit_IM :=IM_Emitente;
  ComponenteSAT.Config.emit_cRegTrib:=RTSimplesNacional; //RTRegimeNormal
  ComponenteSAT.Config.emit_cRegTribISSQN := RTISSNenhum;
  ComponenteSAT.Config.emit_indRatISSQN := irNao;
  ComponenteSAT.Config.PaginaDeCodigo   := 0;
  ComponenteSAT.Config.EhUTF8           := false;
  ComponenteSAT.Config.infCFe_versaoDadosEnt:=0.07;

  ComponenteSAT.ConfigArquivos.SalvarCFe        := true;
  ComponenteSAT.ConfigArquivos.SalvarCFeCanc    := true;
  ComponenteSAT.ConfigArquivos.SalvarEnvio      := true;
  ComponenteSAT.ConfigArquivos.SepararPorCNPJ   := true;
  ComponenteSAT.ConfigArquivos.SepararPorModelo := true;
  ComponenteSAT.ConfigArquivos.SepararPorDia    := true;
  ComponenteSAT.ConfigArquivos.SepararPorMes    := true;
  ComponenteSAT.ConfigArquivos.SepararPorAno    := true;

  ComponenteSAT.OnGetsignAC:=@GetsignAC;
  ComponenteSAT.OnGetcodigoDeAtivacao:=@GetCodigoDeAtivacao;

  //Extrato Fortes Report
  ComponenteSATExtrato.LarguraBobina    := 302;
  ComponenteSATExtrato.MargemSuperior   := 2;
  ComponenteSATExtrato.MargemInferior   := 4;
  ComponenteSATExtrato.MargemEsquerda   := 2;
  ComponenteSATExtrato.MargemDireita    := 2;
  ComponenteSATExtrato.MostraPreview    := true;
  ComponenteSATExtrato.Sistema:='www.MFRinfo.com.br - Cursos de Delphi/Lazarus e AspNetCore';
  ComponenteSATExtrato.PictureLogo.LoadFromFile(ExtractFileDir(Application.ExeName)+'\logo.jpg');
  ComponenteSATExtrato.LogoAutoSize:=true;
  ComponenteSATExtrato.LogoStretch:=true;

  ComponenteSAT.Inicializar;
  result := ComponenteSAT.Inicializado;
end;

procedure TSAT.GetsignAC(var Chave: AnsiString);
begin
  Chave := AnsiString( F_AssinaturaSW );
end;

procedure TSAT.GetCodigoDeAtivacao(var Chave: AnsiString);
begin
  Chave := AnsiString( F_CodigoAtivacao );
end;

function TSAT.ConsultarSAT: string;
begin
  ComponenteSAT.ConsultarSAT;
  result:=ComponenteSAT.Resposta.mensagemRetorno;
end;

function TSAT.GerarVenda(bufVenda: TBufDataset; bufPagamento: TBufDataset): Boolean;
Var TotalItem:Double;
    TotalGeral:Double;
begin
  ComponenteSAT.CFe.IdentarXML := true;
  ComponenteSAT.CFe.TamanhoIdentacao := 3;
  ComponenteSAT.CFe.RetirarAcentos := true;
  ComponenteSAT.InicializaCFe;

  with ComponenteSAT.CFe do begin
    ide.numeroCaixa := F_NumeroCaixa;
    ide.cNF         := Random(999999);

    //Dest.CNPJCPF    := '45.288.813/0001-67';
    //Dest.xNome      := 'Nome do Cliente Aqui';
    //
    //Entrega.xLgr    := 'Endereco do cliente aqui';
    //Entrega.nro     := '123';
    //Entrega.xCpl    := 'complemento';
    //Entrega.xBairro := 'bairro';
    //Entrega.xMun    := 'municipio';
    //Entrega.UF      := 'SP';

    bufVenda.First;
    while not bufVenda.EOF do begin
      with Det.Add do
      begin
        nItem         := bufVenda.FieldByName('item').AsInteger;
        Prod.cProd    := bufVenda.FieldByName('produtoId').AsString;
        Prod.cEAN     := bufVenda.FieldByName('codigogtin').AsString;
        Prod.xProd    := bufVenda.FieldByName('descricao').AsString;
        prod.NCM      := '99';
        Prod.CFOP     := '5120';
        Prod.uCom     := 'UN';
        Prod.qCom     := bufVenda.FieldByName('quantidade').AsFloat;
        Prod.vUnCom   := bufVenda.FieldByName('valorUnitario').AsFloat;
        Prod.indRegra := irTruncamento;
        Prod.vDesc    := 0;

        TotalItem  := RoundABNT((Prod.qCom * Prod.vUnCom) + Prod.vOutro - Prod.vDesc, -2);  //ACBrUtil
        TotalGeral := TotalGeral + TotalItem;

        Imposto.vItem12741 := TotalItem * 0.12;  //Lei da Transparencia para Calcular quanto a nota tem de imposto
        Imposto.ICMS.orig := oeNacional;
        if Emit.cRegTrib = RTSimplesNacional then
          Imposto.ICMS.CSOSN := csosn102
        else
          Imposto.ICMS.CST := cst00;

        Imposto.ICMS.pICMS := 18;

        Imposto.PIS.CST := pis49;
        Imposto.PIS.vBC := TotalItem;
        Imposto.PIS.pPIS := 0.0065;

        Imposto.COFINS.CST := cof49;
        Imposto.COFINS.vBC := TotalItem;
        Imposto.COFINS.pCOFINS := 0.0065;

      end;
      bufVenda.Next;
    end;

    Total.DescAcrEntr.vDescSubtot := 0;
    Total.vCFeLei12741 := TotalGeral * 0.12;

    bufPagamento.First;
    with Pagto.Add do
    begin
      case StrToInt(bufPagamento.FieldByName('codigoMeioPagamento').AsString) of
        1: cMP := mpDinheiro;
        2: cMP := mpCheque;
        3: cMP := mpCartaodeCredito;
        4: cMP := mpCartaodeDebito;
        5: cMP := mpCreditoLoja;
       99: cMP := mpOutros;
      end;
      vMP := bufPagamento.FieldByName('valorPago').AsFloat;
    end;

    InfAdic.infCpl := 'Acesse www.mfrinfo.com.br'+
                      'Cursos para Delphi/Lazarus e Asp.Net Core';
  end;

  ComponenteSAT.EnviarDadosVenda(ComponenteSAT.CFe.GerarXML(True));

  if (ComponenteSAT.Resposta.codigoDeRetorno = 6000) then
    Result:=true
  else
    Result:=false;

  F_XML_Retorno:= ComponenteSAT.CFe.AsXMLString;
  F_Codigo_Retorno_SAT := ComponenteSAT.Resposta.codigoDeRetorno;
  F_Mensagem_SAT:= ComponenteSAT.Resposta.mensagemRetorno;
  F_Mensagem_SEFAZ:= ComponenteSAT.Resposta.mensagemSEFAZ;

end;

procedure TSAT.ImprimirCFeSAT;
begin
  ComponenteSAT.ImprimirExtrato;
end;

procedure TSAT.ImprimirCFeSATResumido;
begin
  ComponenteSAT.ImprimirExtratoResumido;
end;

end.

