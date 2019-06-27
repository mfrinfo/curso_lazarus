unit uUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ExtCtrls, graphics, ExtDlgs, db;

function  MessageYesNo(const Msg: string; DlgType: TMsgDlgType): Integer;
function  MessageNoYes(const Msg: string; DlgType: TMsgDlgType): Integer;
Procedure MessageOK(const Msg: string; DlgType: TMsgDlgType);
Procedure MessageERROR(const Msg: string);
function GuidCreate: string;
procedure CarregarImagem(aImage:TImage);
procedure LimparImagem(var aImage:TImage);
Procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);

implementation

Procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    ms.Position := 0;
    Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

procedure LimparImagem(var aImage:TImage);
begin
  aImage.Picture.Assign(nil);
end;

procedure CarregarImagem(aImage:TImage);
var
  Bmp, BmpTrans: TBitmap;
  Pic: TPicture;
  opdSelecionar:TOpenPictureDialog;
  iWidth:Integer;
  iHeight:Integer;
begin
  Try
    iWidth:=160;
    iHeight:=130;
    opdSelecionar:=TOpenPictureDialog.Create(nil);
    opdSelecionar.Filter:='All (*.bmp;*.jpg; *.jpeg;*.png)|*.jpg; *.jpeg; *.bmp;*.png|Bitmaps '+
                          '(*.bmp)|*.bmp|JPEG Image File (*.jpg;*.jpeg)|*.jpg; *.jpeg| '+
                          'PNG(*.png)|*.png';
    opdSelecionar.Title:='Selecione a Imagem';
    opdSelecionar.Execute;

    if opdSelecionar.FileName<>EmptyStr then begin
      try
        Bmp := TBitmap.Create;
        BmpTrans:= TBitmap.Create;
        Pic := TPicture.Create;

        Pic.LoadFromFile(opdSelecionar.FileName);
        BmpTrans.Assign(Pic.Bitmap);
        Bmp.Width :=iWidth;
        Bmp.Height:=iHeight;
        Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.width, Bmp.Height), BmpTrans);
        aImage.Picture.Bitmap:=Bmp;
      finally
        Pic.Free;
        BmpTrans.Free;
        Bmp.Free;
      end;
    end;

  Finally
     FreeAndNil(opdSelecionar);
  End;

end;

function MessageYesNo(const Msg: string; DlgType: TMsgDlgType): Integer;
var
  DefaultButton: TMsgDlgBtn;
  Caption:AnsiString;
begin
  DefaultButton := mbYes;
  if DlgType=mtWarning then
    Caption:='ATENÇÃO'
  else if DlgType = mtError then
    Caption:='ERRO'
  else if DlgType = mtInformation then
    Caption:='INFORMAÇÃO'
  else if DlgType = mtConfirmation then
    Caption:='CONFIRMAÇÃO'
  else
    Caption:='CONFIRMAÇÃO';

  Result := MessageDlg(Caption,Msg,DlgType, [mbYes,mbNo],0,DefaultButton);
end;

function MessageNoYes(const Msg: string; DlgType: TMsgDlgType): Integer;
var
  DefaultButton: TMsgDlgBtn;
  Caption:AnsiString;
begin
  DefaultButton := mbNo;
  if DlgType=mtWarning then
    Caption:='ATENÇÃO'
  else if DlgType = mtError then
    Caption:='ERRO'
  else if DlgType = mtInformation then
    Caption:='INFORMAÇÃO'
  else if DlgType = mtConfirmation then
    Caption:='CONFIRMAÇÃO'
  else
    Caption:='CONFIRMAÇÃO';

  Result := MessageDlg(Caption,Msg,DlgType,[mbYes, mbno],0,DefaultButton);
end;

Procedure MessageOK(const Msg: string; DlgType: TMsgDlgType);
var Caption:AnsiString;
begin
  if DlgType=mtWarning then
    Caption:='ATENÇÃO'
  else if DlgType = mtError then
    Caption:='ERRO'
  else if DlgType = mtInformation then
    Caption:='INFORMAÇÃO'
  else if DlgType = mtConfirmation then
    Caption:='CONFIRMAÇÃO'
  else
    Caption:='CONFIRMAÇÃO';

  MessageDlg(Caption,Msg,DlgType,[mbok],0);

end;


Procedure MessageERROR(const Msg: string);
var Caption:AnsiString;
begin
  Caption := 'ERRO';
  MessageDlg(Caption,msg,mtError,[mbok], 0);

end;


function GuidCreate: string;
var
  ID: TGUID;
begin
  ID.NewGuid;
  Result :=StringReplace(StringReplace(GUIDToString(ID),'}','',[rfReplaceAll]),'{','',[rfReplaceAll]);
end;




end.

