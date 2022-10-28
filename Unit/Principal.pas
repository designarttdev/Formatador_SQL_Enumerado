unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrPrincipal = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    pnlFooter: TPanel;
    btnRemoverFormatacao: TButton;
    btnFormatar: TButton;
    pnlQuery: TPanel;
    Memo3: TMemo;
    btnCopiarQuery: TButton;
    AdcBaseDados: TFDConnection;
    AdcEmpresa: TFDConnection;
    vQuery: TFDQuery;
    cbEmpresa: TComboBox;
    chkBancoMais: TCheckBox;
    procedure btnCopiarQueryClick(Sender: TObject);
    procedure btnFormatarClick(Sender: TObject);
    procedure btnRemoverFormatacaoClick(Sender: TObject);
    procedure cbEmpresaChange(Sender: TObject);
    procedure chkBancoMaisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    vBaseDados, vEmpresa : String;
    CodigoEmpresa : Integer;
    vUserName, vPassword : String;
    procedure ConectarBaseDados;
    function RetornaTipoCampo(vNomeCampo: String): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frPrincipal: TfrPrincipal;

implementation

{$R *.dfm}

procedure TfrPrincipal.btnCopiarQueryClick(Sender: TObject);
begin
  Memo3.SelectAll;
  Memo3.CopyToClipboard;
end;

procedure TfrPrincipal.btnFormatarClick(Sender: TObject);
var
  vAux, vTextoLinha, vTextoAux : String;
  i, x : Integer;
  vRecomeca : Boolean;
  vNomeDoCampo : String;
begin
  if Trim(Memo1.Lines.Text) = '' then
  begin
    Application.MessageBox(PChar('Campo de origem vazio, favor preencher antes de continuar!'), 'Mais Soluções', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    Memo1.SetFocus;
    Exit;
  end;

  if Copy(Trim(memo1.Lines.Text), 1, Pos(' ', Trim(memo1.Lines.Text)) - 1) = 'INSERT' then
  begin
    {$REGION 'Insert'}

      memo2.lines.clear;
      vAux := Trim(Memo1.Lines.Text.Replace(#13#10, '').Replace(';', '')); // Retira o enter da string
      vAux := Trim(vAux.Replace(')', sLineBreak + ') ')); // Dá Enter quando encontrar o ")"
      vAux := Trim(vAux.Replace('(', '(' + sLineBreak));  // Da enter depois do "("
      vAux := Trim(vAux.Replace(',', ',' + sLineBreak));  // Insere Enter depois da Vírgula
      vAux := Trim(vAux.Replace(sLineBreak + ' ', '' + sLineBreak)); // Retira o enter e esaço e apenas coloca o Enter
      vAux := Trim(vAux.Replace('''', '"')); // Troca áspas simples por áspas duplas
      vAux := Trim(vAux.Replace('CASE', 'CASE' + sLineBreak));  // Insere Enter depois do CASE
      vAux := Trim(vAux.Replace('WHEN', sLineBreak + '  WHEN'));  // Insere Enter antes do WHEN
      vAux := Trim(vAux.Replace('ELSE', sLineBreak + '  ELSE'));  // Insere Enter antes do ELSE
      memo2.Lines.Add(Trim(vAux));
      vRecomeca := False;
      x := 000;
      for i := 0 to Memo2.Lines.Count -1 do
      begin
        if (not (Pos('(', memo2.Lines.Strings[i]) <> 0) and not(Pos(')', memo2.Lines.Strings[i]) <> 0)) then
        begin
          vTextoLinha := vTextoLinha + '{' + FormatFloat('000',x) + '}  ''' + memo2.Lines.Strings[i] + ' '' + ' + sLineBreak;
        end
        else if (Pos('VALUES', memo2.Lines.Strings[i]) <> 0) then
        begin
          x := 000;
          vTextoLinha := vTextoLinha + sLineBreak + '{' + FormatFloat('000',x) + '}  ''' + memo2.Lines.Strings[i] + ' '' + ' + sLineBreak;
          vRecomeca := True;
        end
        else
          vTextoLinha := vTextoLinha + '{' + FormatFloat('000',x) + '}  ''' + memo2.Lines.Strings[i] + ' '' + ' + sLineBreak;
        x := X + 1;
      end;

      memo2.Lines.Clear;
      memo2.Lines.Add(Trim(Copy(Trim(vTextoLinha), 1, Length(Trim(vTextoLinha)) - 1).Replace('"', '''' + '''')) + ';');
      Memo2.SelectAll;
      memo2.CopyToClipboard;
      ShowMessage('Copiado!');

    {$ENDREGION}
  end
  else if Copy(Trim(memo1.Lines.Text), 1, Pos(' ', Trim(memo1.Lines.Text)) - 1) = 'UPDATE' then
  begin
    {$REGION 'Update'}

      memo2.lines.clear;
      vAux := Trim(Memo1.Lines.Text.Replace(#13#10, '').Replace(';', '')); // Retira o enter da string
      vAux := Trim(vAux.Replace(')', sLineBreak + ') ')); // Dá Enter quando encontrar o ")"
      vAux := Trim(vAux.Replace('(', '(' + sLineBreak));  // Da enter depois do "("
      vAux := Trim(vAux.Replace(',', ',' + sLineBreak));  // Insere Enter depois da Vírgula
      vAux := Trim(vAux.Replace(sLineBreak + ' ', '' + sLineBreak)); // Retira o enter e esaço e apenas coloca o Enter
      vAux := Trim(vAux.Replace('WHERE', sLineBreak + 'WHERE ')); // Faz quebra de linha no where
      vAux := Trim(vAux.Replace('FROM ', sLineBreak + 'FROM ')); // Faz quebra de linha no FROM
      vAux := Trim(vAux.Replace('AND ', sLineBreak + 'AND ')); // Faz quebra de linha no AND
      vAux := Trim(vAux.Replace('INNER JOIN ', sLineBreak + 'INNER JOIN ')); // Faz quebra de linha no INNER JOIN
      vAux := Trim(vAux.Replace('LEFT JOIN ', sLineBreak + 'LEFT JOIN ')); // Faz quebra de linha no LEFT JOIN
      vAux := Trim(vAux.Replace('RIGHT JOIN ', sLineBreak + 'RIGHT JOIN ')); // Faz quebra de linha no RIGHT JOIN
      vAux := Trim(vAux.Replace('CASE', 'CASE' + sLineBreak));  // Insere Enter depois do CASE
      vAux := Trim(vAux.Replace('WHEN', sLineBreak + '  WHEN'));  // Insere Enter antes do WHEN
      vAux := Trim(vAux.Replace('ELSE', sLineBreak + '  ELSE'));  // Insere Enter antes do ELSE
      vAux := Trim(vAux.Replace('''', '"')); // Troca áspas simples por áspas duplas
      memo2.Lines.Add(Trim(vAux));
      x := 000;
      for i := 0 to Memo2.Lines.Count -1 do
      begin
        vTextoLinha := vTextoLinha + '{' + FormatFloat('000',x) + '}  ''' + memo2.Lines.Strings[i] + ' '' + ' + sLineBreak;
        x := X + 1;
      end;

      memo2.Lines.Clear;
      memo2.Lines.Add(Trim(Copy(Trim(vTextoLinha), 1, Length(Trim(vTextoLinha)) - 1).Replace('"', '''' + '''')) + ';');
      Memo2.SelectAll;
      memo2.CopyToClipboard;
      ShowMessage('Copiado!');

    {$ENDREGION}
  end
  else if (Copy(Trim(memo1.Lines.Text), 1, Pos(' ', Trim(memo1.Lines.Text)) - 1) = 'SELECT') or (Copy(Trim(memo1.Lines.Text), 1, Pos(#$D#$A, Trim(memo1.Lines.Text)) - 1) = 'SELECT') then
  begin
    {$REGION 'Select'}

      memo2.lines.clear;
      vAux := Trim(Memo1.Lines.Text.Replace(#13#10, '').Replace(';', '')); // Retira o enter da string
      vAux := Trim(vAux.Replace(')', sLineBreak + ') ')); // Dá Enter quando encontrar o ")"
  //    vAux := Trim(vAux.Replace('(', '(' + sLineBreak));  // Da enter depois do "("
      vAux := Trim(vAux.Replace(',', ',' + sLineBreak));  // Insere Enter depois da Vírgula
      vAux := Trim(vAux.Replace(sLineBreak + ' ', '' + sLineBreak)); // Retira o enter e esaço e apenas coloca o Enter
      vAux := Trim(vAux.Replace('WHERE', sLineBreak + ' WHERE ')); // Faz quebra de linha no where
      vAux := Trim(vAux.Replace('FROM ', sLineBreak + ' FROM ')); // Faz quebra de linha no FROM
      vAux := Trim(vAux.Replace('AND', sLineBreak + ' AND ')); // Faz quebra de linha no AND
      vAux := Trim(vAux.Replace('INNER JOIN ', sLineBreak + ' INNER JOIN ')); // Faz quebra de linha no INNER JOIN
      vAux := Trim(vAux.Replace('LEFT JOIN ', sLineBreak + ' LEFT JOIN ')); // Faz quebra de linha no LEFT JOIN
      vAux := Trim(vAux.Replace('RIGHT JOIN ', sLineBreak + ' RIGHT JOIN ')); // Faz quebra de linha no RIGHT JOIN
      vAux := Trim(vAux.Replace('CASE', ' CASE ' + sLineBreak));  // Insere Enter depois do CASE
      vAux := Trim(vAux.Replace('WHEN', ' WHEN '+ sLineBreak));  // Insere Enter depois do WHEN
      vAux := Trim(vAux.Replace('ELSE', ' ELSE '+ sLineBreak));  // Insere Enter depois do ELSE
      vAux := Trim(vAux.Replace('ORDER BY', sLineBreak + ' ORDER BY ')); // Faz quebra de linha no LEFT JOIN
      vAux := Trim(vAux.Replace('''', '"')); // Troca áspas simples por áspas duplas
      memo2.Lines.Add(Trim(vAux));
      x := 000;
      for i := 0 to Memo2.Lines.Count -1 do
      begin
        vTextoLinha := vTextoLinha + '{' + FormatFloat('000',x) + '}  ''' + memo2.Lines.Strings[i] + ' '' + ' + sLineBreak;
        x := X + 1;
      end;

      memo2.Lines.Clear;
      memo2.Lines.Add(Trim(Copy(Trim(vTextoLinha), 1, Length(Trim(vTextoLinha)) - 1).Replace('"', '''' + '''')) + ';');
      Memo2.SelectAll;
      memo2.CopyToClipboard;
      ShowMessage('Copiado!');

    {$ENDREGION}
  end;

  x := 1;
  Memo3.Lines.Clear;
  for i := 0 to Memo2.Lines.Count - 1 do
  begin
    if Pos(':', Memo2.Lines.Strings[i]) > 0 then
    begin
      vTextoAux := Memo2.Lines.Strings[i];
      if chkBancoMais.Checked then
      begin
        if Pos('+', vTextoAux) <> 0 then
        begin
          vNomeDoCampo := Trim(Copy(vTextoAux, Pos(':', vTextoAux) +1, Length(vTextoAux) - (Pos(':', vTextoAux))-4).Replace(',', ''));
          Memo3.Lines.Add('vQuery.ParamByName(''' + vNomeDoCampo + ''').' + RetornaTipoCampo(vNomeDoCampo) + ' := Auxiliar' + IntToStr(x) + ';');
        end
        else
        begin
          vNomeDoCampo := Trim(Copy(vTextoAux, Pos(':', vTextoAux) +1, Length(vTextoAux) - (Pos(':', vTextoAux))-3).Replace(',', ''));
          Memo3.Lines.Add('vQuery.ParamByName(''' + vNomeDoCampo + ''').' + RetornaTipoCampo(vNomeDoCampo) + ' := Auxiliar' + IntToStr(x) + ';');
        end;
      end
      else
      begin
        if Pos('+', vTextoAux) <> 0 then
        begin
          vNomeDoCampo := Trim(Copy(vTextoAux, Pos(':', vTextoAux) +1, Length(vTextoAux) - (Pos(':', vTextoAux))-4).Replace(',', ''));
          Memo3.Lines.Add('vQuery.ParamByName(''' + vNomeDoCampo + ''').Value := Auxiliar' + IntToStr(x) + ';');
        end
        else
        begin
          vNomeDoCampo := Trim(Copy(vTextoAux, Pos(':', vTextoAux) +1, Length(vTextoAux) - (Pos(':', vTextoAux))-3).Replace(',', ''));
          Memo3.Lines.Add('vQuery.ParamByName(''' + vNomeDoCampo + ''').Value := Auxiliar' + IntToStr(x) + ';');
        end;
      end;

      Inc(x);
    end;
  end;
end;

Function TfrPrincipal.RetornaTipoCampo(vNomeCampo : String) : String;
var
  vQueryBanco : TFDQuery;
begin

  Result := '';
  try

    vQueryBanco := TFDQuery.Create(nil);
    vQueryBanco.Connection := AdcEmpresa;
    vQueryBanco.Close;
    vQueryBanco.Sql.Clear;
    vQueryBanco.Sql.Text := 'SELECT DISTINCT R.RDB$FIELD_NAME AS NOME, ' + sLineBreak
                    + 'R.RDB$DESCRIPTION AS DESCRICAO, ' + sLineBreak
                    + 'F.RDB$FIELD_LENGTH AS TAMANHO, ' + sLineBreak
                    + 'CASE F.RDB$FIELD_TYPE ' + sLineBreak
                    + 'WHEN 261 THEN ''BLOB'' ' + sLineBreak
                    + 'WHEN 14 THEN ''CHAR'' ' + sLineBreak
                    + 'WHEN 40 THEN ''CSTRING'' ' + sLineBreak
                    + 'WHEN 11 THEN ''D_FLOAT'' ' + sLineBreak
                    + 'WHEN 27 THEN ''DOUBLE'' ' + sLineBreak
                    + 'WHEN 10 THEN ''FLOAT'' ' + sLineBreak
                    + 'WHEN 16 THEN ''INT64'' ' + sLineBreak
                    + 'WHEN 8 THEN ''INTEGER'' ' + sLineBreak
                    + 'WHEN 9 THEN ''QUAD'' ' + sLineBreak
                    + 'WHEN 7 THEN ''SMALLINT'' ' + sLineBreak
                    + 'WHEN 12 THEN ''DATE'' ' + sLineBreak
                    + 'WHEN 13 THEN ''TIME'' ' + sLineBreak
                    + 'WHEN 35 THEN ''TIMESTAMP'' ' + sLineBreak
                    + 'WHEN 37 THEN ''VARCHAR'' ' + sLineBreak
                    + 'ELSE ''UNKNOWN'' ' + sLineBreak
                    + 'END AS TIPO ' + sLineBreak
                    + 'FROM RDB$RELATION_FIELDS R ' + sLineBreak
                    + 'LEFT JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ' + sLineBreak
                    + 'WHERE --R.RDB$RELATION_NAME = UPPER(:NOME_TABELA) AND -- NOME DA TABELA ' + sLineBreak
                    + 'R.RDB$FIELD_NAME = UPPER(:NOMECAMPO) ' + sLineBreak
                    + 'ORDER BY R.RDB$FIELD_POSITION; ';
    vQueryBanco.ParamByName('NOMECAMPO').AsString := vNomeCampo;
    vQueryBanco.Open;
    vQueryBanco.First;

    if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('INTEGER')) then
      Result := 'AsInteger'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('VARCHAR')) then
      Result := 'AsString'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('CHAR')) then
      Result := 'AsString'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('BLOB')) then
      Result := 'Value'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('FLOAT')) then
      Result := 'AsFloat'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('DOUBLE')) then
      Result := 'AsFloat'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('DATE')) then
      Result := 'AsDateTime'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('TIME')) then
      Result := 'AsDateTime'
    else if UpperCase(Trim(vQueryBanco.FieldByName('TIPO').AsString)) = UpperCase(Trim('TIMESTAMP')) then
      Result := 'AsDateTime'
    else
      Result := 'Value';
  finally
    vQueryBanco.Free;
  end;

end;

procedure TfrPrincipal.btnRemoverFormatacaoClick(Sender: TObject);
var
  i : integer;
  vTextoLinha : String;
begin
  memo1.Lines.Clear;

  for i := 0 to memo2.Lines.Count -1 do
  begin
    vTextoLinha := Trim(memo2.Lines.Strings[i].Replace('  ', ' ').Replace(''' +', ''));
    if i = memo2.Lines.Count -1 then
    begin
      memo1.Lines.Add(Copy(vTextoLinha.Replace(''';', ''), Pos('''', vTextoLinha) + 1, Length(vTextoLinha)));
    end
    else
      memo1.Lines.Add(Copy(vTextoLinha.Replace('''' + '''', ''''), Pos('''', vTextoLinha) + 1, Length(vTextoLinha)));
  end;
end;

procedure TfrPrincipal.cbEmpresaChange(Sender: TObject);
var
  aIni : TIniFile;
  I : Integer;
  vAlias,vCodigoEmpStr : String;
begin

  vAlias := 'EMPRESA' + FormatFloat('000', StrToFloat(Copy(cbEmpresa.Text, 1, pos(' ', cbEmpresa.Text))));
  vCodigoEmpStr := Copy(cbEmpresa.Text, 1, pos(' ', cbEmpresa.Text));

  if AdcBaseDados.Connected then
  begin
    try
      aIni     := TIniFile.Create(ExtractFileDrive(Application.ExeName) + '\Sge32\alias.ini');
      vEmpresa := Trim(aIni.ReadString(vAlias, 'database', ''));
      if vEmpresa <> '' then
      begin
        try
          AdcEmpresa.Connected       := False;
          AdcEmpresa.Params.UserName := vUserName;
          AdcEmpresa.Params.Password := vPassword;
          AdcEmpresa.Params.Database := vEmpresa;
          AdcEmpresa.Connected       := True;

          CodigoEmpresa := StrToInt(Trim(vCodigoEmpStr));

        except on E:Exception do
          begin
            Application.MessageBox('Erro ao conectar no banco de dados!',
              'Atenção!', MB_OK + MB_ICONSTOP);
            cbEmpresa.ItemIndex := -1;
            CodigoEmpresa := -1;
            Exit;
          end;
        end;
      end;
    finally
      aIni.Free
    end;

  end;
end;

procedure TfrPrincipal.chkBancoMaisClick(Sender: TObject);
begin
  if chkBancoMais.Enabled then
  begin
    ConectarBaseDados;
    cbEmpresa.Enabled := True;
    cbEmpresa.ItemIndex := 0;
    cbEmpresaChange(nil);
  end
  else
  begin
    cbEmpresa.Enabled   := False;
    cbEmpresa.ItemIndex := -1;
    AdcBaseDados.Connected := False;
  end;
end;

procedure TfrPrincipal.FormShow(Sender: TObject);
begin
  memo1.lines.Clear;
  memo2.lines.clear;
end;

procedure TfrPrincipal.ConectarBaseDados;
var
  aIni : TIniFile;
  I : Integer;
begin
  try
    aIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\acessobanco.ini');
    vUserName := Trim(aIni.ReadString('ACESSO', 'usuario', ''));
    vPassword := Trim(aIni.ReadString('ACESSO', 'password', ''));
  finally
    aIni.Free;
  end;

  try
    aIni := TIniFile.Create(ExtractFileDrive(Application.ExeName) + '\Sge32\alias.ini');
    vBaseDados := Trim(aIni.ReadString('BASEDADOS', 'database', ''));
    if vBaseDados <> '' then
    begin
      try
        AdcBaseDados.Connected       := False;
        AdcBaseDados.Params.UserName := vUserName;
        AdcBaseDados.Params.Password := vPassword;
        AdcBaseDados.Params.Database := vBaseDados;
        AdcBaseDados.Connected       := True;

        vQuery.Connection := AdcBaseDados;
        vQuery.Close;
        vQuery.Sql.Clear;
        vQuery.sql.Text := 'SELECT E.CODIGOEMPRESA, E.ALIAS, E.NOMEEMPRESA FROM DGLOB000 E ORDER BY E.CODIGOEMPRESA';
        vQuery.open;
        vQuery.First;

        for I := 0 to vQuery.RecordCount - 1 do
        begin
          cbEmpresa.Items.Add(Trim(vQuery.FieldByName('CODIGOEMPRESA').AsInteger.ToString + ' - ' + vQuery.FieldByName('NOMEEMPRESA').AsString));
          vQuery.Next;
        end;

        cbEmpresa.Enabled := True;

      except on E:Exception do
        begin
          Application.MessageBox('Erro ao conectar no BaseDados!',
            'Atenção!', MB_OK + MB_ICONSTOP);
          cbEmpresa.ItemIndex := -1;
          CodigoEmpresa := -1;
          Exit;
        end;
      end;
    end;
  finally
    aIni.Free
  end;
end;


end.
