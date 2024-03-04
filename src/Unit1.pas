unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, IdSSLOpenSSL, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  RiotAPIUrl: string;
  APIKey: string;
  Response: string;
begin
  // Replace 'YOUR_API_KEY' with your Riot API key
  APIKey := 'RGAPI-08acc8ed-93fa-4931-a095-369431886b20';

  // Replace 'REGION' and 'SUMMONER_NAME' with the desired region and summoner name
  RiotAPIUrl := 'https://EUW1.api.riotgames.com/lol/summoner/v4/summoners/by-name/asulk#2238';

  // Set up the HTTP request headers (including the API key)
  IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdHTTP1.Request.CustomHeaders.Add('X-Riot-Token: ' + APIKey);

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

end.

