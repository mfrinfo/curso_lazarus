unit cPdvVendaFormaPagamento;

{$mode objfpc}{$H+}

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     cBase,
     ZAbstractConnection,
     ZConnection,
     ZAbstractRODataset,
     ZAbstractDataset,
     ZDataset,
     SysUtils,
     uUtils;

type
  TPdvVendaFormaPagamento = class(TBase)

  private
    F_pdvVendaId:String;
    F_item:Integer;
    F_codigoMeioPagamento:String;
    F_descricaoMeioPagamento:String;
    F_codigoCartao:String;
    F_operadoraCartao:String;
    F_cnpjOperadoraCartao:String;
    F_valorPago:Double;
    F_valorTroco:Double;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Apagar:Boolean;

  published
    property pdvVendaId:String  read F_pdvVendaId write F_pdvVendaId;
    property item:Integer  read F_item write F_item;
    property codigoMeioPagamento:String  read F_codigoMeioPagamento write F_codigoMeioPagamento;
    property descricaoMeioPagamento:String  read F_descricaoMeioPagamento write F_descricaoMeioPagamento;
    property codigoCartao:String  read F_codigoCartao write F_codigoCartao;
    property operadoraCartao:String  read F_operadoraCartao write F_operadoraCartao;
    property cnpjOperadoraCartao:String  read F_cnpjOperadoraCartao write F_cnpjOperadoraCartao;
    property valorPago:Double  read F_valorPago write F_valorPago;
    property valorTroco:Double  read F_valorTroco write F_valorTroco;

end;

implementation

{TPdvVendaFormaPagamento}

{$region 'Constructor and Destructor'}
constructor TPdvVendaFormaPagamento.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TPdvVendaFormaPagamento.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TPdvVendaFormaPagamento.Apagar: Boolean;
var Qry:TZQuery;
begin
  if MessageNoYes('Apagar o Registro? ', mtConfirmation)=mrNo then begin
     Result:=false;
     abort;
  end;
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM pdvvendaformapagamento'+
                '      WHERE pdvVendaId=:pdvVendaId '+
                '        AND item=:item ');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('item').AsInteger := Self.F_item;
    try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result:=false;
    end;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;



function TPdvVendaFormaPagamento.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO pdvvendaformapagamento ('+
                '      pdvVendaId'+
                '      ,item'+
                '      ,codigoMeioPagamento'+
                '      ,descricaoMeioPagamento'+
                '      ,codigoCartao'+
                '      ,operadoraCartao'+
                '      ,cnpjOperadoraCartao'+
                '      ,valorPago'+
                '      ,valorTroco'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :pdvVendaId '+
                '      ,:item '+
                '      ,:codigoMeioPagamento '+
                '      ,:descricaoMeioPagamento '+
                '      ,:codigoCartao '+
                '      ,:operadoraCartao '+
                '      ,:cnpjOperadoraCartao '+
                '      ,:valorPago '+
                '      ,:valorTroco '+
                ')');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('item').AsInteger := Self.F_item;
    Qry.ParamByName('codigoMeioPagamento').AsString := Self.F_codigoMeioPagamento;
    Qry.ParamByName('descricaoMeioPagamento').AsString := Self.F_descricaoMeioPagamento;
    Qry.ParamByName('codigoCartao').AsString := Self.F_codigoCartao;
    Qry.ParamByName('operadoraCartao').AsString := Self.F_operadoraCartao;
    Qry.ParamByName('cnpjOperadoraCartao').AsString := Self.F_cnpjOperadoraCartao;
    Qry.ParamByName('valorPago').AsFloat := Self.F_valorPago;
    Qry.ParamByName('valorTroco').AsFloat := Self.F_valorTroco;
    try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result:=false;
    end;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

{$endRegion}
end.
