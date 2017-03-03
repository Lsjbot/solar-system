unit SolBuild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,SolSpace, StdCtrls;

type
  TForm3 = class(TForm)
    OK: TButton;
    Cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    sbNplanets: TScrollBar;
    Label3: TLabel;
    Label4: TLabel;
    ScrollBar1: TScrollBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ScrollBar2: TScrollBar;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ScrollBar3: TScrollBar;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ScrollBar4: TScrollBar;
    ScrollBar5: TScrollBar;
    ScrollBar6: TScrollBar;
    ScrollBar7: TScrollBar;
    ScrollBar8: TScrollBar;
    ScrollBar9: TScrollBar;
    ScrollBar10: TScrollBar;
    ScrollBar11: TScrollBar;
    ScrollBar12: TScrollBar;
    ScrollBar13: TScrollBar;
    ScrollBar14: TScrollBar;
    ScrollBar15: TScrollBar;
    ScrollBar16: TScrollBar;
    ScrollBar17: TScrollBar;
    ScrollBar18: TScrollBar;
    ScrollBar19: TScrollBar;
    ScrollBar20: TScrollBar;
    ScrollBar21: TScrollBar;
    ScrollBar22: TScrollBar;
    ScrollBar23: TScrollBar;
    ScrollBar24: TScrollBar;
    ScrollBar25: TScrollBar;
    ScrollBar26: TScrollBar;
    ScrollBar27: TScrollBar;
    ScrollBar28: TScrollBar;
    ScrollBar29: TScrollBar;
    ScrollBar30: TScrollBar;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    ScrollBar34: TScrollBar;
    ScrollBar36: TScrollBar;
    Label24: TLabel;
    Label25: TLabel;
    sbNsuns: TScrollBar;
    Label26: TLabel;
    ScrollBar32: TScrollBar;
    ScrollBar33: TScrollBar;
    ScrollBar37: TScrollBar;
    Label27: TLabel;
    ScrollBar38: TScrollBar;
    ScrollBar39: TScrollBar;
    ScrollBar40: TScrollBar;
    Label28: TLabel;
    ScrollBar41: TScrollBar;
    ScrollBar42: TScrollBar;
    ScrollBar43: TScrollBar;
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure sbNsunsChange(Sender: TObject);
    procedure sbNplanetsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm3.OKClick(Sender: TObject);
var np,ns:integer;
begin

  ns := sbNsuns.Position;
  Form2.AddSun(exp(0.1*(Scrollbar34.Position-50)),0.0,0.0);
  if ns > 1 then
    Form2.AddSun(exp(0.1*(Scrollbar32.Position-50)),
                     exp(0.1*(Scrollbar33.Position-50)),
                         0.009*Scrollbar37.Position);
  if ns > 2 then
    Form2.AddSun(exp(0.1*(Scrollbar38.Position-50)),
                     exp(0.1*(Scrollbar39.Position-50)),
                         0.009*Scrollbar40.Position);
  if ns > 3 then
    Form2.AddSun(exp(0.1*(Scrollbar41.Position-50)),
                     exp(0.1*(Scrollbar42.Position-50)),
                         0.009*Scrollbar43.Position);

  np := sbNplanets.Position;
  if np > 0 then
    Form2.AddPlanet(exp(0.15*(Scrollbar1.Position-50)),
                     exp(0.1*(Scrollbar2.Position-50)),
                         0.01*Scrollbar3.Position);
  if np > 1 then
    Form2.AddPlanet(exp(0.15*(Scrollbar4.Position-50)),
                     exp(0.1*(Scrollbar5.Position-50)),
                         0.01*Scrollbar6.Position);
  if np > 2 then
    Form2.AddPlanet(exp(0.15*(Scrollbar7.Position-50)),
                     exp(0.1*(Scrollbar8.Position-50)),
                         0.01*Scrollbar9.Position);
  if np > 3 then
    Form2.AddPlanet(exp(0.15*(Scrollbar10.Position-50)),
                     exp(0.1*(Scrollbar11.Position-50)),
                         0.01*Scrollbar12.Position);
  if np > 4 then
    Form2.AddPlanet(exp(0.15*(Scrollbar13.Position-50)),
                     exp(0.1*(Scrollbar14.Position-50)),
                         0.01*Scrollbar15.Position);
  if np > 5 then
    Form2.AddPlanet(exp(0.15*(Scrollbar16.Position-50)),
                     exp(0.1*(Scrollbar17.Position-50)),
                         0.01*Scrollbar18.Position);
  if np > 6 then
    Form2.AddPlanet(exp(0.15*(Scrollbar19.Position-50)),
                     exp(0.1*(Scrollbar20.Position-50)),
                         0.01*Scrollbar21.Position);
  if np > 7 then
    Form2.AddPlanet(exp(0.15*(Scrollbar22.Position-50)),
                     exp(0.1*(Scrollbar23.Position-50)),
                         0.01*Scrollbar24.Position);
  if np > 8 then
    Form2.AddPlanet(exp(0.15*(Scrollbar25.Position-50)),
                     exp(0.1*(Scrollbar26.Position-50)),
                         0.01*Scrollbar27.Position);
  if np > 9 then
    Form2.AddPlanet(exp(0.15*(Scrollbar28.Position-50)),
                     exp(0.1*(Scrollbar29.Position-50)),
                         0.01*Scrollbar30.Position);

  Close;
end;

procedure TForm3.sbNplanetsChange(Sender: TObject);
begin
  Label2.Caption := IntToStr(sbNplanets.Position);
end;
procedure TForm3.sbNsunsChange(Sender: TObject);
begin
  Label25.Caption := IntToStr(sbNsuns.Position);
end;

end.
