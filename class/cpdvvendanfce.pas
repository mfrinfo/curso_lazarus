unit cpdvvendanfce;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ACBrNFe, ACBrDANFCeFortesFr, pcnConversao;


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
     public
       constructor Create;
       destructor Destroy; override;
       function Inicializar:Boolean;
     published
       property CNPJ_SW: String         read F_CNPJ_SW          write F_CNPJ_SW;
       property CNPJ_Emitente: String   read F_CNPJ_EMITENTE    write F_CNPJ_EMITENTE;
       property IE_Emitente: String     read F_IE_Emitente      write F_IE_Emitente;
       property IM_Emitente: String     read F_IM_Emitente      write F_IM_Emitente;
   end;

implementation

{ TNFCe }

constructor TNFCe.Create;
begin
  ComponenteNFe:=TACBrNFe.Create(nil);
  ComponenteNFeDANFE:=TACBrNFeDANFCeFortes.Create(nil);
  ComponenteNFe.DANFE:=ComponenteNFeDANFE;

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
  Result := true;
end;

end.

