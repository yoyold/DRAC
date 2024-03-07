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
    ComboBox2: TComboBox;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure KeyInputBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure RequestUserInformation();
    function ValidateSummonerInput: Boolean;
    procedure MapServerName();
    procedure UserToJson(const JSonResponse: String);
    procedure FindMatchbyID(AMatchID: String);

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
  System.StrUtils, System.JSON;

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
  // todo: make default input grey at first
  // InputEdit.Font.Color
end;

procedure TForm1.RequestUserInformation();
var
  RiotAPIUrl: string;
  Response: string;
begin
  if not ValidateSummonerInput then begin
    exit;
  end;

  // Replace 'REGION' and 'SUMMONER_NAME' with the desired region and summoner name
  FServerName := 'EUW1';
  RiotAPIUrl := Format('https://%s.api.riotgames.com/lol/summoner/v4/summoners/by-name/%s', [FServerName, InputEdit.Text]);

  // Set up the HTTP request headers (including the API key)
  IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdHTTP1.Request.CustomHeaders.Add('X-Riot-Token: ' + FAPIKey);

  try
    // Make the HTTP GET request
    Response := IdHTTP1.Get(RiotAPIUrl);

    // Display the response in Memo1 or handle it as needed
    Memo1.Lines.Text := Response;
    UserToJson(Response);
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

function TForm1.ValidateSummonerInput(): Boolean;
begin
  if (InputEdit.Text = '') OR NOT (ContainsText(InputEdit.Text, '#')) then
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

// cast the user response to json object for further processing
procedure TForm1.UserToJSon(const JsonResponse: String);
var
  LJsonObject: TJSONObject;
  RiotApiUrl: String;
  LNextResponse: String;
  LNextJSon: TJSONObject;
  LMatchID: String;
begin
  try
    LJsonObject := TJSONObject.ParseJSONValue(JsonResponse) as TJSONObject;

    if Assigned(LJsonObject) then
      begin
        try
          // Check if the 'puuid' key exists in the JSON object
          if LJsonObject.TryGetValue<string>('puuid', PUUID) then
          begin
            // PUUID is there and can be used now
            FServerName := 'EUROPE'; // different for this api
            RiotAPIUrl := Format('https://%s.api.riotgames.com/lol/match/v5/matches/by-puuid/%s/ids', [FServerName, PUUID]);

            // Set up the HTTP request headers (including the API key)
            IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

            try
              // Make the HTTP GET request
             LNextResponse := IdHTTP1.Get(RiotAPIUrl);
             //  LNextJSon := TJSONObject.ParseJSONValue(LNextResponse) as TJSONObject;
             Memo1.Lines.Add(LNextResponse);
              //LMatchID := LJsonObject.TryGetValue<String>('', LMatchID);
              LMatchID := 'EUW1_6845153197';
              FindMatchbyID(LMatchID);
            except
              on E: Exception do
                ShowMessage('Error: ' + E.Message);
            end;

          end
          else
          begin
            // Handle the case where 'puuid' key is not present in the JSON
            // ...
          end;
        finally
          LJsonObject.Free;
        end;
      end
      else
      begin
        // Handle the case where JSON parsing failed
        // ...
      end;
    except
      // Handle exceptions if any
    end;
end;

procedure TForm1.FindMatchByID(AMatchID: String);
var
  RiotApiUrl: String;
  LNextResponse: String;
begin
  FServerName := 'EUROPE';
  RiotApiUrl := Format('https://%s.api.riotgames.com/lol/match/v5/matches/%s', [FServerName, AMatchID]);
  LNextResponse := IdHTTP1.Get(RiotApiUrl);
  Memo1.Lines.Add(LNextResponse);
end;

end.

