unit cInstanciarForm;

{$mode objfpc}{$H+}

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     ZAbstractConnection,
     ZConnection,
     SysUtils,
     Forms,
     Buttons,
     cUsuarioLogado,
     RLReport;

type
  TInstanciarForm = class
  private

  public
    class procedure CriarForm(aNomeForm: TFormClass; oUsuarioLogado: TUsuarioLogado; aConexao:TZConnection); static;
    class procedure CriarRelatorio(aNomeForm: TFormClass; oUsuarioLogado: TUsuarioLogado ; aConexao:TZConnection); static;

  end;

implementation


class procedure TInstanciarForm.CriarForm(aNomeForm: TFormClass; oUsuarioLogado: TUsuarioLogado; aConexao:TZConnection);
var form: TForm;
begin
  try
    form := aNomeForm.Create(Application);
    if TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, form.Name, aConexao) then
    begin
      form.ShowModal;
    end
    else begin
       MessageDlg('Usuário: '+oUsuarioLogado.nome +' Não tem Permissão de Acesso',mtWarning,[mbOK],0);
    end;
  finally
    if Assigned(form) then
       form.Release;
  end;
end;


class procedure TInstanciarForm.CriarRelatorio(aNomeForm: TFormClass; oUsuarioLogado: TUsuarioLogado; aConexao:TZConnection);
var form: TForm;
    i:Integer;
begin
  try
    form := aNomeForm.Create(Application);
    if TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, form.Name, aConexao) then
    begin
      for I := 0 to form.ComponentCount-1 do
      begin
        if form.Components[i] is TRLReport then
        begin
           TRLReport(form.Components[i]).PreviewModal;
           Break;
        end;
      end;
    end
    else begin
       MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
    end;
  finally
    if Assigned(form) then
       form.Release;
  end;
end;

end.

