unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, StdCtrls, DBGrids, DBCtrls, ZConnection, ZDataset, SynEdit,
  SynHighlighterPas;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnGerarClasse: TBitBtn;
    btnGerarMetodos: TBitBtn;
    btnSair: TBitBtn;
    bufTemp: TBufDataset;
    chkChavePrimaria: TDBCheckBox;
    chkCampoGrid: TDBCheckBox;
    dtsbufTemp: TDataSource;
    dtsBancos: TDataSource;
    dtsTabelas: TDataSource;
    dtsCampos: TDataSource;
    edtTraducao: TDBEdit;
    dbLkpBancoDados: TDBLookupComboBox;
    dbLkpTabela: TDBLookupComboBox;
    lblRotulo: TLabel;
    nvgControle: TDBNavigator;
    grdCampos: TDBGrid;
    edtNomeDaClasse: TEdit;
    EdtTipoDaClasse: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblSelecioneBanco: TLabel;
    lblSelecioneTabela: TLabel;
    lblNomeClasse: TLabel;
    lblTipoDaClasse: TLabel;
    pnlGrid: TPanel;
    pnlControles: TPanel;
    pnlCentro: TPanel;
    pnlEsquedo: TPanel;
    pnlBotoes: TPanel;
    synCodigo: TSynEdit;
    SynPascal: TSynPasSyn;
    conDataBase: TZConnection;
    qryBancos: TZQuery;
    qryTabelas: TZQuery;
    qryCampos: TZQuery;
    procedure btnGerarClasseClick(Sender: TObject);
    procedure btnGerarMetodosClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dbLkpBancoDadosExit(Sender: TObject);
    procedure dbLkpTabelaExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function RetornaTipoCampo:String;
    procedure WhereAndParamsPK;
    function RetornaTipoCampoWithAS:String;
    procedure AddTransaction;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnGerarClasseClick(Sender: TObject);
var i:Integer;
begin
  if bufTemp.State in [dsEdit, dsInsert] then
     bufTemp.Post;

  if bufTemp.IsEmpty then begin
    MessageDlg('Não existe campos de tabela definido para a classe',mtWarning,[mbok],0);
    edtNomeDaClasse.SetFocus;
    exit;
  end;

  if edtNomeDaClasse.Text=EmptyStr then begin
    MessageDlg('Não existe o nome da classe definida',mtWarning,[mbok],0);
    edtNomeDaClasse.SetFocus;
    exit;
  end;

  if EdtTipoDaClasse.Text=EmptyStr then begin
    MessageDlg('Não existe o Tipo da classe definida',mtWarning,[mbok],0);
    EdtTipoDaClasse.SetFocus;
    exit;
  end;

  synCodigo.Lines.Clear;

  With synCodigo.Lines do begin
    Add('unit c'+edtNomeDaClasse.Text+'; ');
    Add('');
    Add('{$mode objfpc}{$H+}   ');
    Add('');
    Add('interface ');
    Add('');
    Add('uses Classes,  ');
    Add('     Controls,');
    Add('     ExtCtrls, ');
    Add('     Dialogs, ');
    Add('     cBase, ');
    Add('     ZAbstractConnection, ');
    Add('     ZConnection, ');
    Add('     ZAbstractRODataset, ');
    Add('     ZAbstractDataset, ');
    Add('     ZDataset, ');
    Add('     SysUtils, ');
    Add('     uUtils; ');
    Add('');
    Add('type ');
    Add('  T'+Copy(EdtTipoDaClasse.Text,1,50)+' = class(TBase)');
    Add('');
    Add('  private ');

    bufTemp.First;
    while not bufTemp.Eof do begin
      SynCodigo.Lines.Add('    F_'+bufTemp.FieldByName('NomeCampo').AsString+':'+RetornaTipoCampo+';');
      bufTemp.Next;
    end;
    With synCodigo.Lines do begin
      Add('  public ');
      Add('    constructor Create(aConexao:TZConnection);');
      Add('    destructor Destroy; override;');
      Add('    function Inserir:Boolean; ');
      Add('    function Atualizar:Boolean; ');
      Add('    function Apagar:Boolean; ');
      Add('    function Selecionar(id:string):Boolean; ');
      Add('');
      Add('  published ');
    end;

    bufTemp.First;
    while not bufTemp.Eof do begin
      SynCodigo.Lines.Add('    property '+bufTemp.FieldByName('NomeCampo').AsString+':' + RetornaTipoCampo +
                          '  read F_'+bufTemp.FieldByName('NomeCampo').AsString+
                          ' write F_'+bufTemp.FieldByName('NomeCampo').AsString+';' );
      bufTemp.Next;
    end;

    with  SynCodigo.Lines do begin
      Add('');
      Add('end;');
      Add('');
      Add('implementation ');
      Add('');
      Add('{T'+EdtTipoDaClasse.Text+'}');

      Add('');
      Add('{$region ''Constructor and Destructor''} ');
      Add('constructor T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Create(aConexao:TZConnection);');
      Add('begin');
      Add('  ConexaoDB:=aConexao; ');
      Add('end;');
      Add('');
      Add('destructor T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Destroy; ');
      Add('begin ');
      Add('  inherited; ');
      Add('end; ');
      Add('{$endRegion} ');
      Add('');

      Add('{$region ''CRUD''} ');
      Add('function T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Apagar: Boolean; ');
      Add('var Qry:TZQuery;   ');
      Add('begin');
      Add('  if MessageNoYes(''Apagar o Registro? '', mtConfirmation)=mrNo then begin ');
      Add('     Result:=false;');
      Add('     abort; ');
      Add('  end;');
      Add('  try');
      Add('    Result:=true;');
      Add('    Qry:=TZQuery.Create(nil);');
      Add('    Qry.Connection:=ConexaoDB;');
      Add('    Qry.SQL.Clear;');
      Add('    Qry.SQL.Add(''DELETE FROM '+ dbLkpTabela.Text + '''+ ');
      WhereAndParamsPK;
      AddTransaction;
      Add('  finally ');
      Add('   if Assigned(Qry) then ');
      Add('      FreeAndNil(Qry);  ');
      Add('  end;');
      Add('end; ');
      Add('');

      //Atualizar
      Add('function T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Atualizar: Boolean; ');
      Add('var Qry:TZQuery;   ');
      Add('begin');
      Add('  try');
      Add('    Result:=true;');
      Add('    Qry:=TZQuery.Create(nil);');
      Add('    Qry.Connection:=ConexaoDB;');
      Add('    Qry.SQL.Clear;');
      Add('    Qry.SQL.Add('' UPDATE '+ dbLkpTabela.Text + '''+ ');
      i:=0;
      bufTemp.First;
      while not bufTemp.Eof do begin
        if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
           bufTemp.Next;
           continue;
        end;

        if (i=0) then
           Add('                ''    SET '+bufTemp.FieldByName('NOMECAMPO').AsString + '=:'+ bufTemp.FieldByName('NOMECAMPO').AsString+' ''+ ')
        else
           Add('                ''       ,'+bufTemp.FieldByName('NOMECAMPO').AsString + '=:'+ bufTemp.FieldByName('NOMECAMPO').AsString+' ''+ ');


        inc(i);
        bufTemp.Next;
      end;
      WhereAndParamsPK;

      bufTemp.First;
      while not bufTemp.Eof do begin
        if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
           bufTemp.Next;
           continue;
        end;

        Add('    Qry.ParamByName('+QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').'+RetornaTipoCampoWithAS+' := Self.F_'+bufTemp.FieldByName('NOMECAMPO').AsString+'; ');

        bufTemp.Next;
      end;

      AddTransaction;
      Add('  finally ');
      Add('   if Assigned(Qry) then ');
      Add('      FreeAndNil(Qry);  ');
      Add('  end;');
      Add('end; ');
      Add('');

      Add('function T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Inserir: Boolean; ');
      Add('var Qry:TZQuery;   ');
      Add('begin');
      Add('  try');
      Add('    Result:=true;');
      Add('    Qry:=TZQuery.Create(nil);');
      Add('    Qry.Connection:=ConexaoDB;');
      Add('    Qry.SQL.Clear;');
      Add('    Qry.SQL.Add('' INSERT INTO '+ dbLkpTabela.Text + ' (''+ ');

      i:=0;
      bufTemp.First;
      while not bufTemp.Eof do begin
        if (i=0) then begin
           Add('                ''      '+bufTemp.FieldByName('NOMECAMPO').AsString + '''+ ');
        end
        else
           Add('                ''      ,'+bufTemp.FieldByName('NOMECAMPO').AsString + '''+ ');

        inc(i);
        bufTemp.Next;
      end;
      Add('               '+' '')''); ');
      Add('    Qry.SQL.Add('' VALUES (''+ ');

      i:=0;
      bufTemp.First;
      while not bufTemp.Eof do begin
        if (i=0) then begin
           Add('                ''      :'+bufTemp.FieldByName('NOMECAMPO').AsString + ' ''+ ');
        end
        else
           Add('                ''      ,:'+bufTemp.FieldByName('NOMECAMPO').AsString + ' ''+ ');

        inc(i);
        bufTemp.Next;
      end;
      Add('               '+' '')''); ');

      bufTemp.First;
      while not bufTemp.Eof do begin
        if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
          Add('    Qry.ParamByName('+QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').'+RetornaTipoCampoWithAS+' := GuidId; ');
        end
        else
          Add('    Qry.ParamByName('+QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').'+RetornaTipoCampoWithAS+' := Self.F_'+bufTemp.FieldByName('NOMECAMPO').AsString+'; ');

        bufTemp.Next;
      end;

      AddTransaction;
      Add('  finally ');
      Add('   if Assigned(Qry) then ');
      Add('      FreeAndNil(Qry);  ');
      Add('  end;');
      Add('end; ');

      Add('function T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Selecionar(id:string): Boolean; ');
      Add('var Qry:TZQuery;   ');
      Add('begin');
      Add('  try');
      Add('    Result:=true;');
      Add('    Qry:=TZQuery.Create(nil);');
      Add('    Qry.Connection:=ConexaoDB;');
      Add('    Qry.SQL.Clear;');
      Add('    Qry.SQL.Add('' SELECT ''+ ');

      i:=0;
      bufTemp.First;
      while not bufTemp.Eof do begin
        if (i=0) then begin
           Add('                ''      '+bufTemp.FieldByName('NOMECAMPO').AsString + ' ''+ ');
        end
        else
           Add('                ''      ,'+bufTemp.FieldByName('NOMECAMPO').AsString +' ''+ ');

        inc(i);
        bufTemp.Next;
      end;
      Add('                '' FROM '+dbLkpTabela.Text +''' + ');

      i:=0;
      bufTemp.First;
      while not bufTemp.Eof do begin
         if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
            Add('                '' WHERE '+bufTemp.FieldByName('NOMECAMPO').AsString + '=:id '');');
        end;
        inc(i);
        bufTemp.Next;
      end;
      Add('    Qry.ParamByName(''Id'').AsString:=id; ');


      Add('    Qry.Open; ');

      bufTemp.First;
      while not bufTemp.Eof do begin
        Add('    Self.F_'+bufTemp.FieldByName('NOMECAMPO').AsString+' := '+ 'Qry.FieldByName('+ QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').'+RetornaTipoCampoWithAS+'; ');
        bufTemp.Next;
      end;

      Add('  finally ');
      Add('   if Assigned(Qry) then ');
      Add('      FreeAndNil(Qry);  ');
      Add('  end;');
      Add('end; ');


      Add('{$endRegion} ');
      Add('end. ');
    end;
  end;

end;

procedure TfrmPrincipal.btnGerarMetodosClick(Sender: TObject);
var i:Integer;
begin
  if bufTemp.State in [dsEdit, dsInsert] then
     bufTemp.Post;

  if bufTemp.IsEmpty then begin
    MessageDlg('Não existe campos de tabela definido para a classe',mtWarning,[mbok],0);
    edtNomeDaClasse.SetFocus;
    exit;
  end;

  if edtNomeDaClasse.Text=EmptyStr then begin
    MessageDlg('Não existe o nome da classe definida',mtWarning,[mbok],0);
    edtNomeDaClasse.SetFocus;
    exit;
  end;

  if EdtTipoDaClasse.Text=EmptyStr then begin
    MessageDlg('Não existe o tipo da classe definida',mtWarning,[mbok],0);
    EdtTipoDaClasse.SetFocus;
    exit;
  end;

  SynCodigo.Lines.Clear;
  With SynCodigo.Lines do begin
    Add('  public   ');
    Add('    o'+EdtTipoDaClasse.Text+':T'+EdtTipoDaClasse.Text+'; ');
    Add('    function Gravar(aEstadoDoCadastro:TEstadoDoCadastro):boolean; override; ');
    Add('    function Apagar:Boolean; override; ');
    Add('    procedure ConfigurarCampos; override; ');
    Add('  end; ');
    Add(' ');
    Add(' ');

    Add('{$region ''Metodos Override''} ');
    Add('procedure Tfrm'+Copy(edtNomeDaClasse.Text,1,50)+'.ConfigurarCampos; ');
    Add('begin');

    i:=0;
    bufTemp.First;
    while not bufTemp.Eof do begin
      if (bufTemp.FieldByName('CAMPONOGRID').AsBoolean) then begin
         Add('  qryListagem.Fields['+i.ToString()+'].DisplayLabel:='+QuotedStr(bufTemp.FieldByName('TRADUCAOCAMPO').AsString)+';');
         inc(i);
      end;
      bufTemp.Next;
    end;
    Add(' ');

    i:=0;
    bufTemp.First;
    while not bufTemp.Eof do begin
      if (bufTemp.FieldByName('CAMPONOGRID').AsBoolean) then begin
         Add('  grdListagem.Columns.Add(); ');
         Add('  grdListagem.Columns['+i.ToString()+'].FieldName:='+QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+';');
         Add('  grdListagem.Columns['+i.ToString()+'].Width:='+bufTemp.FieldByName('TAMANHO').AsString+';');
         Add(' ');
         inc(i);
      end;
      bufTemp.Next;
    end;
    Add('end;');
    Add(' ');

    Add('function Tfrm'+Copy(edtNomeDaClasse.Text,1,50)+'.Gravar(aEstadoDoCadastro: TEstadoDoCadastro): boolean; ');
    Add('begin');
    Add('  if EstadoDoCadastro=ecInserir then ');
    Add('     Result:= o'+Copy(EdtTipoDaClasse.Text,1,50)+'.Inserir    ');
    Add('  else if EstadoDoCadastro=ecAlterar then ');
    Add('     Result:= o'+Copy(EdtTipoDaClasse.Text,1,50)+'.Atualizar; ');
    Add('end;');

    Add(' ');
    Add('function Tfrm'+Copy(edtNomeDaClasse.Text,1,50)+'.Apagar: boolean; ');
    Add('begin');
    bufTemp.First;
    while not bufTemp.Eof do begin
      if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
         Add('  if o'+Copy(EdtTipoDaClasse.Text,1,50)+'.Selecionar(QryListagem.FieldByName('+ QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').AsString) then  ');
         Add('     Result:= o'+Copy(EdtTipoDaClasse.Text,1,50)+'.Apagar    ');
         Break;
      end;
      bufTemp.Next;
    end;
    Add('end;');

    Add('{$endRegion} ');

    Add(' ');
    Add('procedure Tfrm'+Copy(edtNomeDaClasse.Text,1,50)+'.FormClose(Sender: TObject; var CloseAction: TCloseAction);');
    Add('begin');
    Add('  inherited; ');
    Add('  if Assigned(o'+Copy(EdtTipoDaClasse.Text,1,50)+') then ');
    Add('     FreeAndNil(o'+Copy(EdtTipoDaClasse.Text,1,50)+');');
    Add('end;');

    Add('procedure Tfrm'+Copy(edtNomeDaClasse.Text,1,50)+'.FormCreate(Sender: TObject);');
    Add('begin');
    Add('  o'+Copy(EdtTipoDaClasse.Text,1,50)+':= T'+Copy(EdtTipoDaClasse.Text,1,50)+'.Create(DtmPrincipal.ConDataBase);' );
    Add('  IndiceAtual:=; ');
    Add('  inherited; ');
    Add('end;');

    Add('');
    Add('===============');
    bufTemp.First;
    while not bufTemp.Eof do begin
      Add('  o'+Copy(EdtTipoDaClasse.Text,1,50)+'.'+bufTemp.FieldByName('NOMECAMPO').AsString+':=');
      bufTemp.Next;
    end;

    Add('');
    Add('===============');
    bufTemp.First;
    while not bufTemp.Eof do begin
      Add(' := o'+Copy(EdtTipoDaClasse.Text,1,50)+'.'+bufTemp.FieldByName('NOMECAMPO').AsString+';');
      bufTemp.Next;
    end;
  end;


end;

procedure TfrmPrincipal.AddTransaction;
begin
  with SynCodigo.Lines do begin
    Add('    try');
    Add('      ConexaoDB.StartTransaction; ');
    Add('      Qry.ExecSQL;');
    Add('      ConexaoDB.Commit; ');
    Add('    except ');
    Add('      ConexaoDB.Rollback; ');
    Add('      Result:=false; ');
    Add('    end;');
  end;
end;


function TfrmPrincipal.RetornaTipoCampo:String;
begin
  if LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='int' then
    result:='Integer'
  else if LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='bigint' then
    result:='Int64'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='varchar') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='longtext') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='char') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='text') then
    result:='String'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='date')then
    result:='TDate'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='timestamp') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='datetime') then
    result:='TDateTime'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='double') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='decimal') then
    result:='Double'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString) ='tinyint') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString) ='bit') then
     result:='Boolean'
  else
     result:='Implementar'
end;

function TfrmPrincipal.RetornaTipoCampoWithAS:String;
begin
  if LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='int' then
    result:='AsInteger'
  else if LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='bigint' then
    result:='AsInteger'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='varchar') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='longtext') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='char') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='text') then
    result:='AsString'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='date')then
    result:='AsDateTime'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='timestamp') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='datetime') then
    result:='AsDateTime'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='double') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString)='decimal') then
    result:='AsFloat'
  else if (LowerCase(bufTemp.FieldByName('TipoCampo').AsString) ='tinyint') or
          (LowerCase(bufTemp.FieldByName('TipoCampo').AsString) ='bit') then
     result:='AsBoolean'
  else
     result:='Implementar'
end;

procedure TfrmPrincipal.WhereAndParamsPK;
var i:Integer;
begin
  with SynCodigo.Lines do begin
    i:=0;
    bufTemp.First;
    while not bufTemp.Eof do begin
      if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
        if (i=0) then
           Add('                ''      WHERE '+bufTemp.FieldByName('NOMECAMPO').AsString + '=:'+ bufTemp.FieldByName('NOMECAMPO').AsString+' ''); ')
        else
           Add('                ''        AND '+bufTemp.FieldByName('NOMECAMPO').AsString + '=:'+ bufTemp.FieldByName('NOMECAMPO').AsString+' ''); ');
        inc(i);
      end;
      bufTemp.Next;
    end;

    bufTemp.First;
    while not bufTemp.Eof do begin
      if (bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean) then begin
          Add('    Qry.ParamByName('+QuotedStr(bufTemp.FieldByName('NOMECAMPO').AsString)+').'+RetornaTipoCampoWithAS+' := Self.F_'+bufTemp.FieldByName('NOMECAMPO').AsString+'; ');
      end;
      bufTemp.Next;
    end;
  end;
end;


procedure TfrmPrincipal.dbLkpBancoDadosExit(Sender: TObject);
begin
  if (TDBLookupComboBox(Sender).KeyValue=Null) or (TDBLookupComboBox(Sender).KeyValue='') then
      exit;

  try
    qryTabelas.Close;
    qryTabelas.Sql.Clear;
    qryTabelas.Sql.Add('SELECT table_name '+
                       '  FROM information_schema.tables '+
                       ' WHERE table_schema='+QuotedStr(TDBLookupComboBox(Sender).KeyValue));
    qryTabelas.Open;
    dbLkpTabela.KeyValue:=nil;
  except
    qryTabelas.Close;
  end;
end;

procedure TfrmPrincipal.dbLkpTabelaExit(Sender: TObject);
begin
  if (TDBLookupComboBox(Sender).KeyValue=Null) or (TDBLookupComboBox(Sender).KeyValue='') then
    exit;

  try
    qryCampos.Close;
    qryCampos.Sql.Clear;
    qryCampos.Sql.Add(' SELECT * '+
                      '   FROM INFORMATION_SCHEMA.COLUMNS '+
                      '  WHERE table_schema='+QuotedStr(dbLkpBancoDados.KeyValue)+
                      '    AND table_name  ='+QuotedStr(TDBLookupComboBox(Sender).KeyValue));
    qryCampos.Open;
    qryCampos.First;

    bufTemp.First;
    while not bufTemp.Eof do
      bufTemp.Delete;

    while not qryCampos.Eof do begin
      bufTemp.Append;
      bufTemp.FieldByName('NOMECAMPO').AsString        :=qryCampos.FieldByName('COLUMN_NAME').AsString;
      bufTemp.FieldByName('TIPOCAMPO').AsString        :=qryCampos.FieldByName('DATA_TYPE').AsString;
      bufTemp.FieldByName('TAMANHO').AsInteger         :=qryCampos.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsInteger;
      bufTemp.FieldByName('CHAVEPRIMARIA').AsBoolean   :=False;
      bufTemp.FieldByName('CAMPONOGRID').AsBoolean     :=False;
      bufTemp.FieldByName('TRADUCAOCAMPO').AsString    :=qryCampos.FieldByName('COLUMN_NAME').AsString;
      bufTemp.Post;
      qryCampos.Next;
    end;

  except
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  bufTemp.FieldDefs.Add('NOMECAMPO',ftString,50);
  bufTemp.FieldDefs.Add('TRADUCAOCAMPO',ftString,50);
  bufTemp.FieldDefs.Add('TIPOCAMPO',ftString,50);
  bufTemp.FieldDefs.Add('TAMANHO',ftInteger,0);
  bufTemp.FieldDefs.Add('CHAVEPRIMARIA',ftBoolean);
  bufTemp.FieldDefs.Add('CAMPONOGRID',ftBoolean);
  bufTemp.CreateDataset;

  conDataBase.Connected:=true;

  qryBancos.SQL.Clear;
  qryBancos.SQL.Add('SHOW databases ');
  qryBancos.Open;

  dbLkpBancoDados.ListSource := dtsBancos;
  dbLkpBancoDados.ListField  := 'DataBase';
  dbLkpBancoDados.KeyField   := 'DataBase';
  dbLkpBancoDados.KeyValue    := qryBancos.FieldByName('Database').AsString;

  dbLkpTabela.ListSource := dtsTabelas;
  dbLkpTabela.ListField  := 'table_name';
  dbLkpTabela.KeyField   := 'table_name';
  dbLkpTabela.KeyValue   := nil;


  chkChavePrimaria.DataSource:=dtsbufTemp;
  chkChavePrimaria.DataField:='CHAVEPRIMARIA';

  chkCampoGrid.DataSource:=dtsbufTemp;
  chkCampoGrid.DataField:='CAMPONOGRID';

  edtTraducao.DataSource:=dtsbufTemp;
  edtTraducao.DataField:='TRADUCAOCAMPO';

  grdCampos.DataSource:=dtsbufTemp;
  nvgControle.DataSource:=dtsbufTemp;
end;

end.

