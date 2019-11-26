unit cpdvvendanfce;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ACBrNFe, ACBrDANFCeFortesFr, pcnConversao, ACBrNFeNotasFiscais,
  pcnConversaoNFe, BufDataset, db, pcnNFe, ACBrDFeSSL, ACBrUtil;


type

   { TNFCe }

   TNFCe = class
     private
       ComponenteNFe:TACBrNFe;
       ComponenteNFeDANFE:TACBrNFeDANFCeFortes;
       F_CNPJ_SW:String;
       F_CNPJ_Emitente:String;
       F_IE_Emitente:String;
       F_IM_Emitente:String;
       F_Razao_Social_Emitente:String;
       F_Fantasia_Emitente:String;
       F_Telefone_Emitente:String;
       F_CEP_Emitente:Integer;
       F_Logradouro_Emitente: String;
       F_Numero_Emitente: String;
       F_Bairro_Emitente: String;
       F_CodIBGE_Emitente:Integer;
       F_Municipio_Emitente:String;
       F_UF_Emitente: String;
       F_Cod_Pais_Emitente:Integer;
       F_Pais_Emitente:String;
       F_Codigo_Regime_Tributario:TpcnCRT;
       F_CPF_Consumidor: String;
       F_Nome_Consumidor: String;
       F_ArquivoPFX: String;
       F_Senha_Certificado:String;
       F_Token_NFCe:String;
       F_Token_NFCe_Id:String;

     public
       constructor Create;
       destructor Destroy; override;
       function Inicializar:Boolean;
       function GerarVenda(NroNF: Integer; NroSerie:Integer; bufVenda: TBufDataset; bufPagamento: TBufDataset): Boolean;
     published
       property CNPJ_SW: String         read F_CNPJ_SW          write F_CNPJ_SW;
       property CNPJ_Emitente: String   read F_CNPJ_EMITENTE    write F_CNPJ_EMITENTE;
       property IE_Emitente: String     read F_IE_Emitente      write F_IE_Emitente;
       property IM_Emitente: String     read F_IM_Emitente      write F_IM_Emitente;
       property Razao_Social_Emitente: String     read F_Razao_Social_Emitente    write F_Razao_Social_Emitente;
       property Fantasia_Emitente: String         read F_Fantasia_Emitente        write F_Fantasia_Emitente;
       property Telefone_Emitente: String         read F_Telefone_Emitente        write F_Telefone_Emitente;
       property CEP_Emitente: Integer             read F_CEP_Emitente             write F_CEP_Emitente;
       property Logradouro_Emitente: String       read F_Logradouro_Emitente      write F_Logradouro_Emitente;
       property Numero_Emitente: String           read F_Numero_Emitente          write F_Numero_Emitente;
       property Bairro_Emitente: String           read F_Bairro_Emitente          write F_Bairro_Emitente;
       property CodIBGE_Emitente: Integer         read F_CodIBGE_Emitente         write F_CodIBGE_Emitente;
       property Municipio_Emitente: String        read F_Municipio_Emitente       write F_Municipio_Emitente;
       property UF_Emitente: String               read F_UF_Emitente              write F_UF_Emitente;
       property Codigo_Regime_Tributario: TpcnCRT read F_Codigo_Regime_Tributario write F_Codigo_Regime_Tributario;
       property CPF_Consumidor: String            read F_CPF_Consumidor           write F_CPF_Consumidor;
       property Nome_Consumidor: String           read F_Nome_Consumidor          write F_Nome_Consumidor;
       property ArquivoPFXdoCertificado: String   read F_ArquivoPFX               write F_ArquivoPFX;
       property Senha_Certificado: String         read F_Senha_Certificado        write F_Senha_Certificado;
       property Token_NFCe: String                read F_Token_NFCe               write F_Token_NFCe;
       property Token_NFCe_Id: String             read F_Token_NFCe_Id            write F_Token_NFCe_Id;


   end;

implementation

{ TNFCe }

constructor TNFCe.Create;
begin
  ComponenteNFe:=TACBrNFe.Create(nil);
  ComponenteNFeDANFE:=TACBrNFeDANFCeFortes.Create(nil);
  ComponenteNFe.DANFE:=ComponenteNFeDANFE;

  Inicializar;
end;

destructor TNFCe.Destroy;
begin
  if Assigned(ComponenteNFe) then
     FreeAndNil(ComponenteNFe);

  if Assigned(ComponenteNFeDANFE) then
     FreeAndNil(ComponenteNFeDANFE);

  inherited Destroy;
end;

function TNFCe.Inicializar: Boolean;
begin
  F_Cod_Pais_Emitente:=1058;
  F_Pais_Emitente:='Brasil';
  F_Codigo_Regime_Tributario:=crtRegimeNormal; //(1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)
  F_Nome_Consumidor:='CONSUMIDOR';

  ComponenteNFe.Configuracoes.Arquivos.SepararPorAno:=true;
  ComponenteNFe.Configuracoes.Arquivos.SepararPorMes:=true;
  ComponenteNFe.Configuracoes.Arquivos.SepararPorDia:=true;

  Result := true;
end;

function TNFCe.GerarVenda(NroNF: Integer; NroSerie:Integer; bufVenda: TBufDataset; bufPagamento: TBufDataset): Boolean;
Var TotalItem:Double;
    TotalGeral:Double;
    TotalICMS, ValorICMS:Double;
begin
  ComponenteNFe.NotasFiscais.Clear;
  ComponenteNFe.Configuracoes.Certificados.ArquivoPFX:=F_ArquivoPFX;
  ComponenteNFe.Configuracoes.Certificados.Senha:=F_Senha_Certificado;

  with ComponenteNFe.Configuracoes.Geral do
   begin
     SSLLib := libOpenSSL;
     SSLCryptLib := cryOpenSSL;
     SSLHttpLib := httpOpenSSL;
     SSLXmlSignLib := xsLibXml2;
     ModeloDF := moNFCe;
     VersaoDF:= ve400;
     VersaoQrCode := veqr200;
     CSC:=F_Token_NFCe;
     IdCSC:=F_Token_NFCe_Id;    //Código de Segurança do Contribuinte
   end;

  with ComponenteNFe.NotasFiscais.Add.NFe do
    begin
      Ide.cNF:=NroNF;
      Ide.natOp:='Venda';
      Ide.indPag:=ipVista;
      Ide.modelo:=65;  //Nota Fiscal de Consumidor Eletrônica
      Ide.serie:=NroSerie;
      Ide.nNF  :=Random(99999999);
      Ide.dEmi      := now;
      Ide.dSaiEnt   := now;
      Ide.hSaiEnt   := now;
      Ide.tpNF      := tnSaida;
      Ide.tpEmis    := teNormal;
      Ide.tpAmb     := taHomologacao;
      Ide.cUF       := UFtoCUF(F_UF_Emitente);
      Ide.cMunFG    := F_CodIBGE_Emitente;
      Ide.finNFe    := fnNormal;
      Ide.tpImp     := tiNFCe;
      Ide.indFinal  := cfConsumidorFinal;
      Ide.indPres   := pcPresencial;

      Emit.CNPJCPF           := F_CNPJ_Emitente;
      Emit.IE                := F_IE_Emitente;
      Emit.xNome             := F_Razao_Social_Emitente;
      Emit.xFant             := F_Fantasia_Emitente;
      Emit.EnderEmit.fone    := F_Telefone_Emitente;
      Emit.EnderEmit.CEP     := F_CEP_Emitente;
      Emit.EnderEmit.xLgr    := F_Logradouro_Emitente;
      Emit.EnderEmit.nro     := F_Numero_Emitente;
      Emit.EnderEmit.xCpl    := '';
      Emit.EnderEmit.xBairro := F_Bairro_Emitente;
      Emit.EnderEmit.cMun    := F_CodIBGE_Emitente;
      Emit.EnderEmit.xMun    := F_Municipio_Emitente;
      Emit.EnderEmit.UF      := F_UF_Emitente;
      Emit.enderEmit.cPais   := F_Cod_Pais_Emitente;
      Emit.enderEmit.xPais   := F_Pais_Emitente;
      Emit.IEST              := ''; //IE do Substituto Tributário
      Emit.CRT               := Codigo_Regime_Tributario;

      if (F_CPF_Consumidor<>EmptyStr) then begin
         Dest.CNPJCPF        := CPF_Consumidor;
         Dest.xNome          := F_Nome_Consumidor;
      end;

      //Dest.ISUF              := '';
      //Dest.xNome             := 'Nome do Cliente Aqui';
      //Dest.EnderDest.Fone    := '9999999999';
      //Dest.EnderDest.CEP     := 99999999;
      //Dest.EnderDest.xLgr    := 'Endereco do cliente aqui';
      //Dest.EnderDest.nro     := '123';
      //Dest.EnderDest.xCpl    := 'complemento';
      //Dest.EnderDest.xBairro := 'bairro';
      //Dest.EnderDest.cMun    := 'CodIBGE';
      //Dest.EnderDest.xMun    := 'municipio';
      //Dest.EnderDest.UF      := 'SP';
      //Dest.EnderDest.cPais   := 1058;
      //Dest.EnderDest.xPais   := 'BRASIL';


      bufVenda.First;
      TotalGeral:=0;
      TotalICMS:=0;

      while not bufVenda.EOF do begin
         //Adicionando Produtos
         with Det.New do begin
           Prod.nItem    := bufVenda.FieldByName('item').AsInteger;
           Prod.cProd    := bufVenda.FieldByName('produtoId').AsString;
           Prod.cEAN     := bufVenda.FieldByName('codigogtin').AsString;
           Prod.xProd    := bufVenda.FieldByName('descricao').AsString;
           Prod.NCM      := '94051010'; // Tabela NCM disponível em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
           Prod.EXTIPI   := '';
           Prod.CFOP     := '5101';
           Prod.uCom     := 'UN';
           Prod.qCom     := bufVenda.FieldByName('quantidade').AsFloat;
           Prod.vUnCom   := bufVenda.FieldByName('valorUnitario').AsFloat;
           Prod.vProd    := bufVenda.FieldByName('valorTotal').AsFloat;

           Prod.cEANTrib  := bufVenda.FieldByName('codigogtin').AsString;
           Prod.uTrib     := 'UN';
           Prod.qTrib     := bufVenda.FieldByName('quantidade').AsFloat;
           Prod.vUnTrib   := bufVenda.FieldByName('valorTotal').AsFloat;

           Prod.vOutro    := 0;
           Prod.vFrete    := 0;
           Prod.vSeg      := 0;
           Prod.vDesc     := 0;

           Prod.CEST := '1111111';

           TotalItem  := RoundABNT((Prod.qCom * Prod.vUnCom) + Prod.vOutro - Prod.vDesc, -2);
           ValorICMS  := RoundABNT((TotalItem * 18/100), -2);
           TotalGeral := TotalGeral + TotalItem;
           TotalICMS  := TotalICMS + ValorICMS;

           with Imposto do begin
             vTotTrib := 0;
             with ICMS do begin
               CST          := cst00;
               ICMS.orig    := oeNacional;
               ICMS.modBC   := dbiValorOperacao;
               ICMS.vBC     := TotalItem;
               ICMS.pICMS   := 18;
               ICMS.vICMS   := ValorICMS;
               ICMS.modBCST := dbisMargemValorAgregado;
               ICMS.pMVAST  := 0;
               ICMS.pRedBCST:= 0;
               ICMS.vBCST   := 0;
               ICMS.pICMSST := 0;
               ICMS.vICMSST := 0;
               ICMS.pRedBC  := 0;

               // partilha do ICMS e fundo de probreza
               with ICMSUFDest do begin
                  vBCUFDest      := 0.00;
                  pFCPUFDest     := 0.00;
                  pICMSUFDest    := 0.00;
                  pICMSInter     := 0.00;
                  pICMSInterPart := 0.00;
                  vFCPUFDest     := 0.00;
                  vICMSUFDest    := 0.00;
                  vICMSUFRemet   := 0.00;
               end;
             end;
           end;
         end;
        bufVenda.Next;
      end;

      Total.ICMSTot.vBC     := TotalGeral;
      Total.ICMSTot.vICMS   := TotalICMS;
      Total.ICMSTot.vBCST   := 0;
      Total.ICMSTot.vST     := 0;
      Total.ICMSTot.vProd   := TotalGeral;
      Total.ICMSTot.vFrete  := 0;
      Total.ICMSTot.vSeg    := 0;
      Total.ICMSTot.vDesc   := 0;
      Total.ICMSTot.vII     := 0;
      Total.ICMSTot.vIPI    := 0;
      Total.ICMSTot.vPIS    := 0;
      Total.ICMSTot.vCOFINS := 0;
      Total.ICMSTot.vOutro  := 0;
      Total.ICMSTot.vNF     := TotalGeral;

      // partilha do icms e fundo de probreza
      Total.ICMSTot.vFCPUFDest   := 0.00;
      Total.ICMSTot.vICMSUFDest  := 0.00;
      Total.ICMSTot.vICMSUFRemet := 0.00;

      Total.ISSQNtot.vServ   := 0;
      Total.ISSQNTot.vBC     := 0;
      Total.ISSQNTot.vISS    := 0;
      Total.ISSQNTot.vPIS    := 0;
      Total.ISSQNTot.vCOFINS := 0;

      Transp.modFrete := mfSemFrete;

      bufPagamento.First;
      with pag.New do
      begin
        case StrToInt(bufPagamento.FieldByName('codigoMeioPagamento').AsString) of
          1: tPag := fpDinheiro;
          2: tPag := fpCheque;
          3: tPag := fpCartaoCredito;
          4: tPag := fpCartaoDebito;
          5: tPag := fpCreditoLoja;
         99: tPag := fpOutro;
        end;
        vPag := bufPagamento.FieldByName('valorPago').AsFloat;
      end;
      pag.vTroco:=bufPagamento.FieldByName('valorTroco').AsFloat;

      InfAdic.infCpl     :=   'Acesse www.mfrinfo.com.br'+
                              'Cursos para Delphi/Lazarus e Asp.Net Core';
      InfAdic.infAdFisco :=  '';

      infRespTec.CNPJ:=CNPJ_SW;
      infRespTec.xContato:='NomeEmpresa';
      infRespTec.email:='mail@teste.com.br';
      infRespTec.fone:='62999999999';
      infRespTec.idCSRT:=99;
      infRespTec.hashCSRT:='YWFhYWFhYWFhYWFhYWFhYWFhYWE=';
    end;

  ComponenteNFe.NotasFiscais.GerarNFe;
  //ComponenteNFe.NotasFiscais.Imprimir;
  //result := true;
  if (ComponenteNFe.Enviar(0,True,False)) then
    Result:=true
  else
    Result:=false;
end;

end.

