unit DRACMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, IdSSLOpenSSL, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, Vcl.WinXCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    InputLabel: TLabel;
    InputEdit: TEdit;
    BitBtn1: TBitBtn;
    ActivityIndicator1: TActivityIndicator;
    ComboBox1: TComboBox;
    ServerLabel: TLabel;
    KeyInputBtn: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure KeyInputBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure RequestUserInformation();
    function ValidateSummonerInput: Boolean;
    procedure MapServerName();

  private
    FAPIKey: String;
    FServerName: String;
    PUUID: String;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.StrUtils;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  ActivityIndicator1.Visible := true;
  Application.ProcessMessages;
  RequestUserInformation();
  ActivityIndicator1.Visible := false;
end;

procedure TForm1.KeyInputBtnClick(Sender: TObject);
begin
  FAPIKey := InputBox('API', 'Enter key:', '');
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  MapServerName();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ActivityIndicator1.Visible := false;
  InputEdit.Font.Color := clWebRed;
end;

procedure TForm1.RequestUserInformation();
var
  RiotAPIUrl: string;
  Response: string;
begin
  if not ValidateSummonerInput then begin

  end;

  // Replace 'REGION' and 'SUMMONER_NAME' with the desired region and summoner name
  RiotAPIUrl := Format('https://%s.api.riotgames.com/lol/summoner/v4/summoners/by-name/%s', [FServerName, InputEdit.Text]);

  // Set up the HTTP request headers (including the API key)
  IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdHTTP1.Request.CustomHeaders.Add('X-Riot-Token: ' + FAPIKey);

  try
    // Make the HTTP GET request
    Response := IdHTTP1.Get(RiotAPIUrl);

    // Display the response in Memo1 or handle it as needed
    Memo1.Lines.Text := Response;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

function TForm1.ValidateSummonerInput(): Boolean;
begin
  if (InputEdit.Text <> '') OR NOT (ContainsText(InputEdit.Text, '#')) then
    Result := false
  else
    Result := true;
end;

procedure TForm1.MapServerName();
begin
  case ComboBox1.ItemIndex of
    1:
       FServerName := 'BR1';
    3:
      FServerName := 'EUW1';
  end;
end;

end.

