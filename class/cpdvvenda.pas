unit cpdvvenda;

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
  TPdvVenda = class(TBase)

  private
    F_pdvVendaId:String;
    F_usuarioId:String;
    F_data:TDateTime;
    F_hora:TDateTime;
    F_valorTotalVenda:Double;
  public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:string):Boolean;

  published
    property pdvVendaId:String  read F_pdvVendaId write F_pdvVendaId;
    property usuarioId:String  read F_usuarioId write F_usuarioId;
    property data:TDateTime  read F_data write F_data;
    property hora:TDateTime  read F_hora write F_hora;
    property valorTotalVenda:Double  read F_valorTotalVenda write F_valorTotalVenda;

end;

implementation

{TPdvVenda}

{$region 'Constructor and Destructor'}
constructor TPdvVenda.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
  F_pdvVendaId:=GuidId;
end;

destructor TPdvVenda.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TPdvVenda.Apagar: Boolean;
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
    Qry.SQL.Add('DELETE FROM pdvvenda'+
                '      WHERE pdvVendaId=:pdvVendaId ');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
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

function TPdvVenda.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' UPDATE pdvvenda'+
                '    SET usuarioId=:usuarioId '+
                '       ,data=:data '+
                '       ,hora=:hora '+
                '       ,valorTotalVenda=:valorTotalVenda '+
                '      WHERE pdvVendaId=:pdvVendaId ');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('usuarioId').AsString := Self.F_usuarioId;
    Qry.ParamByName('data').AsDateTime := Self.F_data;
    Qry.ParamByName('hora').AsDateTime := Self.F_hora;
    Qry.ParamByName('valorTotalVenda').AsFloat := Self.F_valorTotalVenda;
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

function TPdvVenda.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO pdvvenda ('+
                '      pdvVendaId'+
                '      ,usuarioId'+
                '      ,data'+
                '      ,hora'+
                '      ,valorTotalVenda'+
                ')');
    Qry.SQL.Add(' VALUES ('+
                '      :pdvVendaId '+
                '      ,:usuarioId '+
                '      ,:data '+
                '      ,:hora '+
                '      ,:valorTotalVenda '+
                ')');
    Qry.ParamByName('pdvVendaId').AsString := Self.F_pdvVendaId;
    Qry.ParamByName('usuarioId').AsString := Self.F_usuarioId;
    Qry.ParamByName('data').AsDateTime := Self.F_data;
    Qry.ParamByName('hora').AsDateTime := Self.F_hora;
    Qry.ParamByName('valorTotalVenda').AsFloat := Self.F_valorTotalVenda;
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
function TPdvVenda.Selecionar(id:string): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT '+
                '      pdvVendaId '+
                '      ,usuarioId '+
                '      ,data '+
                '      ,hora '+
                '      ,valorTotalVenda '+
                ' FROM pdvvenda' +
                ' WHERE pdvVendaId=:id ');
    Qry.ParamByName('Id').AsString:=id;
    Qry.Open;
    Self.F_pdvVendaId := Qry.FieldByName('pdvVendaId').AsString;
    Self.F_usuarioId := Qry.FieldByName('usuarioId').AsString;
    Self.F_data := Qry.FieldByName('data').AsDateTime;
    Self.F_hora := Qry.FieldByName('hora').AsDateTime;
    Self.F_valorTotalVenda := Qry.FieldByName('valorTotalVenda').AsFloat;
  finally
   if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$endRegion}
end.
