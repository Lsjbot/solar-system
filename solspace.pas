unit SolSpace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  maxplanet = 10;
  maxsun = 4;
  G = 6.67e-11;
  Msun = 2.0e30;
  Mearth = 6.0e24;
  AU = 1.5e11;

type
  myreal = double;

  TForm2 = class(TForm)
    RunButton: TButton;
    QuitButton: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Timewindow: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormPaint(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure AddSun(m,a,e:myreal);
    procedure AddPlanet(m,a,e:myreal);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Prepare;
    procedure Run;
  end;

  TPlanet = class
    id : integer;
    mass : myreal;
    radius : integer;
    aphelion : myreal;
    x,y : myreal;
    prelx,prely : myreal;
    vx,vy : myreal;
    pot : myreal;
    hyp : boolean;
    oldx,oldy,oldvx,oldvy,oldpot:myreal;
    xpix,ypix,oldxpix,oldypix,ancientxpix,ancientypix:integer;
    potarray : array[-1..1,-1..1] of myreal;
    function potential(xx,yy:myreal):myreal;
    procedure move;
    procedure draw;
  end;

var
  Form2: TForm2;
  Planet: array[1..maxplanet] of TPlanet;
  Sun : array[1..maxsun] of TPlanet;
  nplanet,nsun : integer;
  firstpaint : boolean;
  zoomfactor:myreal;
  bm : TBitMap;
  orix,oriy : integer;
  scale : myreal;
  timestep : myreal;
  stepmin : myreal;
  fixedsun,planetplanet,stepdown,momentumcheck : boolean;
  elapsedtime : myreal;

implementation

{$R *.DFM}

function TPlanet.potential(xx,yy:myreal):myreal;
var r:myreal;
begin
  r := sqrt(sqr(xx-x)+sqr(yy-y));
  potential := -G*mass/r;
end;

procedure TPlanet.move;
var xstep,ystep,xx,yy,ax,ay,olde,e,de,vv,dv : myreal;
    u,v,i : integer;
begin
  xstep := 0.5*vx*timestep;
  ystep := 0.5*vy*timestep;
  if abs(xstep) < stepmin then
    if xstep < 0 then
      xstep := -stepmin
    else
      xstep := stepmin;
  if abs(ystep) < stepmin then
    if ystep < 0 then
      ystep := -stepmin
    else
      ystep := stepmin;
  for u := -1 to 1 do
    begin
      xx := (u+1)*xstep + x;
      for v := -1 to 1 do
        begin
          yy := (v+1)*ystep + y;
          potarray[u,v] := 0.0;
          for i := 1 to nsun do
            if Sun[i].id <> id then
              potarray[u,v] := potarray[u,v] + Sun[i].potential(xx,yy);
          if planetplanet then
            for i := 1 to nplanet do
              if Planet[i].id <> id then
                potarray[u,v] := potarray[u,v] + Planet[i].potential(xx,yy);
        end;
    end;
  ax := 0.0;
  for v := -1 to 1 do
    ax := ax + (potarray[1,v]-potarray[-1,v])/(2.0*xstep);
  ax := -ax/3.0;
  ay := 0.0;
  for u := -1 to 1 do
    ay := ay + (potarray[u,1]-potarray[u,-1])/(2.0*ystep);
  ay := -ay/3.0;
  if stepdown and (timestep > 360.0) and ( sqr(ax*timestep)+sqr(ay*timestep) > 0.01*(sqr(vx)+sqr(vy)) ) then
    begin
      timestep := 0.1*timestep;
      (*Form2.Memo1.Lines.Add('Decrease step');*)
      for i := 1 to 10 do
        move;
      timestep := 10*timestep;
    end
else
 begin
  oldvx := vx;
  oldvy := vy;
  vx := vx + ax*timestep;
  vy := vy + ay*timestep;
  oldx := x;
  oldy := y;
  x := oldx + oldvx*timestep + 0.5*ax*sqr(timestep);
  y := oldy + oldvy*timestep + 0.5*ay*sqr(timestep);
  olde := potarray[-1,-1] + 0.5*(sqr(oldvx)+sqr(oldvy));
  e := 0.5*(sqr(vx)+sqr(vy));
  for i := 1 to nsun do
    if Sun[i].id <> id then
      e := e + Sun[i].potential(xx,yy);
  if planetplanet then
    for i := 1 to nplanet do
      if Planet[i].id <> id then
        e := e + Planet[i].potential(xx,yy);
  if ( e > 0 ) and ( olde < 0 ) then
    begin
      Form2.Memo1.Lines.Add('Planet '+InttoStr(id)+' hyperbolic orbit');
      hyp := true;
    end;

  (*
  if ( e <> olde ) then
    begin
      de := e-olde;
      vv := sqrt(sqr(vx)+sqr(vy));
      dv := -de/vv;
      vx := vx*(1+dv/vv);
      vy := vy*(1+dv/vv);
    end;
  *)

  (*Form2.Memo1.Lines.Add('x,y = '+FloatToStr(x/AU)+', '+FloatToStr(y/AU));*)
  oldpot := potarray[-1,-1];
 end;
end;

procedure TPlanet.draw;
var prect: TRect;
    i,j : integer;
begin
  oldxpix := xpix;
  oldypix := ypix;
  xpix := round(x*scale) + orix;
  ypix := round(y*scale) + oriy;
  bm.Canvas.Brush.Color := clBlack;
  bm.Canvas.Ellipse(oldxpix-radius,oldypix-radius,oldxpix+radius,oldypix+radius);
  if ( (round(abs(ancientxpix-xpix)) > 10) or (round(abs(ancientypix-ypix)) > 10) ) then
    begin
     (**
      bm.Canvas.Brush.Color := clRed;
      bm.Canvas.Ellipse(ancientxpix-1,ancientypix-1,ancientxpix+1,ancientypix+1);
      **)
      bm.Canvas.Pen.Color := clRed;
      (*bm.Canvas.Pen.Width := 2;*)
      (*bm.Canvas.Pen.Style := psSolid; *)
      bm.Canvas.MoveTo(ancientxpix,ancientypix);
      bm.Canvas.LineTo(xpix,ypix);
      ancientxpix := xpix;
      ancientypix := ypix;
    end;
  if ( id > 0 ) then
    bm.Canvas.Brush.Color := clAqua
  else
    bm.Canvas.Brush.Color := clYellow;
  bm.Canvas.Ellipse(xpix-radius,ypix-radius,xpix+radius,ypix+radius);
  bm.Canvas.Brush.Color := clBlack;
  bm.Canvas.Pen.Color := clBlack;
end;

procedure TForm2.Prepare;
begin
  firstpaint := true;
  zoomfactor := 1.0;
  stepmin := 1e5;
  bm := TBitmap.Create;
  bm.Height := Height;
  bm.Width := Width-100;
  orix := bm.Width div 2;
  oriy := bm.Height div 2;
  nsun := 0;
  nplanet := 0;
  elapsedtime := 0;
end;

procedure TForm2.Run;
begin

end;

procedure TForm2.AddSun(m,a,e:myreal);
var phi0,mtot,L,rr,vv,phi,px,py,vcx,vcy: myreal;
    i:integer;
(* m in solar masses, a in AU *)
begin
  nsun := nsun+1;
  Memo1.Lines.Add('In Addsun, nsun = '+IntToStr(nsun));
  Sun[nsun] := TPlanet.Create;
  with Sun[nsun] do
    begin
      id := -nsun;
      mass := m*Msun;
      radius := 5;
      hyp := false;
      if nsun = 1 then
        begin
          x := 0.0;
          y := 0.0;
          vx := 0.0;
          vy := 0.0;
        end
      else
        begin
          rr := -a*(1.0-e)*AU;
          phi := 6.2832*Random;
          Memo1.Lines.Add('phi = '+FloatToStr(phi));
          aphelion := abs(a*(1.0+e)*AU);
          x := rr*Cos(phi);
          y := rr*Sin(phi);
          mtot := 0;
          for i := 1 to nsun-1 do
            mtot := mtot + Sun[i].mass;
          L := sqrt(abs(rr*G*mtot*(1.0+e)));
          vv := L/rr;
          vx := -vv*Sin(phi);
          vy := vv*Cos(phi);
          Memo1.Lines.Add('vx,vy = '+FloatToStr(vx)+' '+FloatToStr(vy));
          (** balance momentum: **)
          mtot := 0;
          px := 0;
          py := 0;
          for i := 1 to nsun do
            begin
              mtot := mtot + Sun[i].mass;
              px := px + Sun[i].mass*Sun[i].vx;
              py := py + Sun[i].mass*Sun[i].vy;
            end;
          vcx := px/mtot;
          vcy := py/mtot;
          Memo1.Lines.Add('vcx,vcy = '+FloatToStr(vcx)+' '+FloatToStr(vcy));
          for i := 1 to nsun do
            begin
              Sun[i].vx := Sun[i].vx - vcx;
              Sun[i].vy := Sun[i].vy - vcy;
            end;
        end;
      Memo1.Lines.Add('End of Addsun');
    end;
end;

procedure TForm2.AddPlanet(m,a,e:myreal);
(* m in earth masses, a in AU *)
var phi0,mtot,L,rr,vv,phi: myreal;
    i:integer;
begin
  nplanet := nplanet + 1;
  Planet[nplanet] := TPlanet.Create;
  with Planet[nplanet] do
    begin
      id := nplanet;
      mass := m*Mearth;
      radius := 2;
      rr := -a*(1.0-e)*AU;
      phi := 6.2832*Random;
      Memo1.Lines.Add('phi = '+FloatToStr(phi));
      aphelion := abs(a*(1.0+e)*AU);
      x := rr*Cos(phi);
      y := rr*Sin(phi);
      hyp := false;
      mtot := 0;
      for i := 1 to nsun do
        mtot := mtot + Sun[i].mass;
      L := sqrt(abs(rr*G*mtot*(1.0+e)));
      vv := L/rr;
      vx := -vv*Sin(phi);
      vy := vv*Cos(phi);
      (*Memo1.Lines.Add('x,vy = '+FloatToStr(x)+', '+FloatToStr(vy));*)
    end;
end;



procedure TForm2.FormPaint(Sender: TObject);
var prect: TRect;
    i,j : integer;
    rmax,r,px,py,vcx,vcy,mtot : myreal;
    x0a,x0b,x1a,x1b,x2a,x2b : myreal;
    y0a,y0b,y1a,y1b,y2a,y2b : myreal;
    rr0,rr1,rr2,drmax,origtimestep : myreal;
    closeapproach : boolean;
begin
  if firstpaint then
    begin
      firstpaint := false;
      prect.Left := 0;
      prect.Top := 0;
      prect.Right := bm.Width;
      prect.Bottom := bm.Height;
      bm.Canvas.Brush.Color := clBlack;
      bm.Canvas.FillRect(prect);
      rmax := 0.1*AU;
      for i := 1 to nplanet do
        with Planet[i] do
          begin
            r := sqrt(sqr(x)+sqr(y));
            if aphelion > rmax then
              rmax := aphelion;
          end;
      scale := zoomfactor*bm.Height/(2*rmax);
      Label4.Caption := IntToStr(round((bm.Height/scale)/AU))+' AU';
      Memo1.Lines.Add('Scale = '+FloatToStr(scale));
      for i := 1 to nsun do
        with Sun[i] do
          begin
            xpix := round(x*scale) + orix;
            ypix := round(y*scale) + oriy;
      Memo1.Lines.Add('Sun:xypix = '+IntToStr(xpix)+', '+IntToStr(ypix));
            bm.Canvas.Brush.Color := clYellow;
            bm.Canvas.Ellipse(xpix-5,ypix-5,xpix+5,ypix+5);
            ancientxpix := xpix;
            ancientypix := ypix;
          end;
      for i := 1 to nplanet do
        with Planet[i] do
          begin
            xpix := round(x*scale) + orix;
            ypix := round(y*scale) + oriy;
            ancientxpix := xpix;
            ancientypix := ypix;
            (*
      Memo1.Lines.Add('x,y = '+FloatToStr(x)+', '+FloatToStr(y));
      Memo1.Lines.Add('xpix,ypix = '+IntToStr(xpix)+', '+IntToStr(ypix));
      *)
            bm.Canvas.Brush.Color := clAqua;
            bm.Canvas.Ellipse(xpix-2,ypix-2,xpix+2,ypix+2);
          end;
    end
  else
    begin
      (** Check for close approaches **)
      drmax := 1.1;
      origtimestep := timestep;
      repeat
        closeapproach := false;
        if stepdown and not fixedsun then
          for i := 1 to nsun-1 do
            for j := i+1 to nsun do
              begin
                rr0 := Sqr(Sun[i].x - Sun[j].x) + Sqr(Sun[i].y - Sun[j].y);
                with Sun[i] do
                  begin
                    x1a := x+0.5*vx*timestep;
                    y1a := y+0.5*vy*timestep;
                    x2a := x+vx*timestep;
                    y2a := y+vy*timestep;
                  end;
                with Sun[j] do
                  begin
                    x1b := x+0.5*vx*timestep;
                    y1b := y+0.5*vy*timestep;
                    x2b := x+vx*timestep;
                    y2b := y+vy*timestep;
                  end;
                rr1 := Sqr(x1a-x1b) + Sqr(y1a-y1b);
                rr2 := Sqr(x2a-x2b) + Sqr(y2a-y2b);
                if ( rr1 > drmax*rr0 ) then
                  closeapproach := true
                else if ( rr1 < rr0/drmax ) then
                  closeapproach := true
                else if ( rr2 > rr0*drmax ) then
                  closeapproach := true
                else if ( rr2 < rr0/drmax ) then
                  closeapproach := true
                else if ( rr2 > rr1*drmax ) then
                  closeapproach := true
                else if ( rr2 < rr1/drmax ) then
                  closeapproach := true;
              end;
        if closeapproach then
          begin
            (*Memo1.Lines.Add('Closeapproach!');*)
            timestep := 0.2*timestep;
            if ( timestep < 100.0 ) then
              closeapproach := false;
          end;
      until not closeapproach;
      (** Move stuff **)
      if not fixedsun then
        begin
          for i := 1 to nsun do
            begin
              Sun[i].move;
              Sun[i].draw;
            end;
        end;
      for i := 1 to nplanet do
        begin
          Planet[i].move;
          Planet[i].draw;
        end;
      timestep := origtimestep;
      (** balance momentum: **)
      if momentumcheck then
        begin
          mtot := 0;
          px := 0;
          py := 0;
          for i := 1 to nsun do
            begin
              mtot := mtot + Sun[i].mass;
              px := px + Sun[i].mass*Sun[i].vx;
              py := py + Sun[i].mass*Sun[i].vy;
            end;
          for i := 1 to nplanet do
            begin
              mtot := mtot + Planet[i].mass;
              px := px + Planet[i].mass*Planet[i].vx;
              py := py + Planet[i].mass*Planet[i].vy;
            end;
          vcx := px/mtot;
          vcy := py/mtot;
          (*Memo1.Lines.Add('vcx,vcy = '+FloatToStr(vcx)+' '+FloatToStr(vcy));*)
          while ( vcx*vcx+vcy*vcy > 10000.0 ) do
            begin
              vcx := 0.5*vcx;
              vcy := 0.5*vcy;
            end;
          for i := 1 to nsun do
            begin
              Sun[i].vx := Sun[i].vx - vcx;
              Sun[i].vy := Sun[i].vy - vcy;
            end;
          for i := 1 to nPlanet do
            begin
              Planet[i].vx := Planet[i].vx - vcx;
              Planet[i].vy := Planet[i].vy - vcy;
            end;
        end;
    end;
  Canvas.Draw(0,0,bm);
end;

procedure TForm2.RunButtonClick(Sender: TObject);
var i,n : integer;
    ntime : integer;
begin
  n := 20;
  for i := 1 to n do
    FormPaint(Sender);
  elapsedtime := elapsedtime + n*timestep;
  if ( elapsedtime < 3e7 ) then
    begin
      ntime := round(elapsedtime/86400.0);
      Timewindow.Text := IntToStr(ntime);
      Label2.Caption := '(days)';
    end
  else
    begin
      ntime := round(elapsedtime/(365.0*86400.0));
      Timewindow.Text := IntToStr(ntime);
      Label2.Caption := '(years)';
    end;
  FormPaint(Timewindow);
end;

procedure TForm2.QuitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  firstpaint := true;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  zoomfactor := zoomfactor*5.0;
  firstpaint := true;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  zoomfactor := zoomfactor/5.0;
  firstpaint := true;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  timestep := timestep*5;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  timestep := timestep/5;
end;

end.
