program solarsystem;

uses
  Forms,
  solinit in 'solinit.pas' {Form1},
  solspace in 'solspace.pas' {Form2},
  Solbuild in 'Solbuild.pas' {Form3};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
