unit SolInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,SolSpace,
  StdCtrls, Buttons,Solbuild;

type
  TForm1 = class(TForm)
    RunButton: TBitBtn;
    Button1: TButton;
    Memo1: TMemo;
    ButtonEarth: TButton;
    ButtonInner: TButton;
    ButtonOuter: TButton;
    EarthMoonButton: TButton;
    Button6: TButton;
    cbFixedsun: TCheckBox;
    cbPlanetplanet: TCheckBox;
    sbTimestep: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    QuitButton: TButton;
    cbStepDown: TCheckBox;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    procedure RunButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonEarthClick(Sender: TObject);
    procedure RunSimulation;
    procedure EarthMoonButtonClick(Sender: TObject);
    procedure ButtonInnerClick(Sender: TObject);
    procedure ButtonOuterClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure cbStepDownClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.RunButtonClick(Sender: TObject);
begin
  RunSimulation;
end;

procedure TForm1.RunSimulation;
begin
  fixedsun := cbFixedsun.Checked;
  planetplanet := cbPlanetplanet.Checked;
  stepdown := cbStepdown.Checked;
  momentumcheck := Checkbox1.Checked;
  timestep := 3600.0*exp(0.1*sbTimestep.Position);
  Memo1.Lines.Add('Before Show');
  Form2.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
var time0,time1 : TDateTime;
    i,n : longint;
    x : myreal;
begin
  n := 1000000;
  time0 := Time;
  for i := 1 to n do
    begin
      x := x+1.0;
      x := sqrt(x);
    end;
  time1 := Time;
  Memo1.Lines.Add('Time for sqrt: '+FloatToStr(86400*(time1-time0)));
end;
procedure TForm1.ButtonEarthClick(Sender: TObject);
begin
  Memo1.Lines.Add('Before Prepare');
  Form2.Prepare;
  Memo1.Lines.Add('Before Addsun');
  Form2.AddSun(1.0,0.0,0.0);
  Memo1.Lines.Add('Before Addplanet');
  Form2.AddPlanet(1.0,1.0,0.016);
  Memo1.Lines.Add('Before Runsimulation');
  RunSimulation;
end;

procedure TForm1.EarthMoonButtonClick(Sender: TObject);
begin
  Memo1.Lines.Add('Before Prepare');
  Form2.Prepare;
  Memo1.Lines.Add('Before Addsun');
  Form2.AddSun(1.0,0.0,0.0);
  Memo1.Lines.Add('Before Addplanet');
  Form2.AddPlanet(1.0,1.0,0.016);
  Form2.AddPlanet(0.012,0.9975,0.0165);
  Memo1.Lines.Add('Before Runsimulation');
  RunSimulation;
end;

procedure TForm1.ButtonInnerClick(Sender: TObject);
begin
  Memo1.Lines.Add('Before Prepare');
  Form2.Prepare;
  Memo1.Lines.Add('Before Addsun');
  Form2.AddSun(1.0,0.0,0.0);
  Memo1.Lines.Add('Before Addplanet');
  Form2.AddPlanet(0.0553,0.387,0.205);
  Form2.AddPlanet(0.8150,0.723,0.006);
  Form2.AddPlanet(1.0,1.0,0.016);
  Form2.AddPlanet(0.1074,1.523,0.093);
  Form2.AddPlanet(317.896,5.203,0.048);
  Memo1.Lines.Add('Before Runsimulation');
  RunSimulation;
end;

procedure TForm1.ButtonOuterClick(Sender: TObject);
begin
  Memo1.Lines.Add('Before Prepare');
  Form2.Prepare;
  Memo1.Lines.Add('Before Addsun');
  Form2.AddSun(1.0,0.0,0.0);
  Memo1.Lines.Add('Before Addplanet');
  Form2.AddPlanet(317.896,5.203,0.048);
  Form2.AddPlanet(95.185,9.537,0.054);
  Form2.AddPlanet(14.5,19.19,0.047);
  Form2.AddPlanet(17.1,30.068,0.008);
  Form2.AddPlanet(0.0025,-39.481,0.2488);
  Memo1.Lines.Add('Before Runsimulation');
  RunSimulation;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Memo1.Lines.Add('Before Prepare');
  Form2.Prepare;
  Form3.ShowModal;
  RunSimulation;
end;

procedure TForm1.QuitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.cbStepDownClick(Sender: TObject);
begin
  stepdown := cbStepdown.Checked;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  momentumcheck := Checkbox1.Checked;
end;

end.
