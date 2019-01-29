unit uUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

function  MessageYesNo(const Msg: string; DlgType: TMsgDlgType): Integer;
function  MessageNoYes(const Msg: string; DlgType: TMsgDlgType): Integer;
Procedure MessageOK(const Msg: string; DlgType: TMsgDlgType);
Procedure MessageERROR(const Msg: string);
function GuidCreate: string;

implementation


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

