unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,MMSystem, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    PaintBoxSgnl: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
     procedure Button2Click(Sender: TObject);
    procedure changeToneClick(Sender: TObject);

    procedure mm_wom_Open (var Msg: TMessage);  message mm_wom_open;
    procedure mm_wom_Done (var Msg: TMessage);  message mm_wom_done;
    procedure mm_wom_Close (var Msg: TMessage);  message mm_wom_close;

    procedure PlayBuffer(bb: array of byte);
    procedure startGenerate;
    procedure stopGenerate;
   procedure DrawSgnl(graphBuf: array of integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
var
   waveOut: hWaveOut;
   outHdr: array [0..1] of TWaveHdr;
   header: TWaveFormatEx;
   pKey: boolean;
   pBuf: array [0..1] of tHandle;
   pBuffer: array [0..1] of pointer;
   fPlay: boolean;
   Opened: boolean;

procedure TForm1.changeToneClick(Sender: TObject);
begin

   if pkey = false then pkey:=true;
   startGenerate;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

if pKey = false then begin

   startGenerate;

   pKey:=true;
end else begin

   stopGenerate;

   pKey:=false;
end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

if pKey = true then begin

   stopGenerate;

   pKey:=false;
end;

end;

procedure TForm1.PlayBuffer(bb: array of byte);
var
   i, err: integer;
begin

 with header do begin
   wFormatTag := WAVE_FORMAT_PCM;
   nChannels := 1;
   nSamplesPerSec := 44100;
   wBitsPerSample := 8;
   nBlockAlign := nChannels * (wBitsPerSample div 8);
   nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
   cbSize := 0;
 end;

   err:=WaveOutOpen(addr(waveOut), 0, @header,
  Handle, 0, CALLBACK_WINDOW);
    if Err <> 0 then Exit;

for i:=0 to 1 do begin
 pBuf[i] := GlobalAlloc(GMEM_MOVEABLE and GMEM_SHARE, length(bb));
pBuffer[i]:=GlobalLock(pBuf[i]);

  with outHdr[i] do begin
   lpData := pbuffer[i];
   dwBufferLength := length(bb);
    dwUser := 0;
    dwFlags := 0;
   dwLoops := 0;
 end;

   err:=WaveOutPrepareHeader(waveOut, @outHdr[i], sizeof(outHdr));
    if Err <> 0 then Exit;

   copyMemory(pBuffer[i], @bb, length(bb));

   err:=WaveOutWrite(waveOut, @outHdr[i], sizeof(outHdr));
    if Err <> 0 then Exit;
end;

end;

procedure TForm1.mm_wom_open (var Msg: tMessage);
begin
// 'Open'
   Opened:=True;
end;

procedure TForm1.mm_wom_done (var Msg: tMessage);
begin
// 'Done'

   if fPlay = false then begin
     waveOutWrite(waveOut, @outHdr[0], sizeof(outHdr));
   fPlay:=true;
   end else begin
   waveOutWrite(waveOut, @outHdr[1], sizeof(outHdr));
   fPlay:=false;
   end;

end;

procedure Tform1.mm_wom_close (var Msg: tMessage);
begin
// 'Close'
   Opened:=False;
end;

procedure tform1.startGenerate;
var
   i: integer;
   buffer: array [0..44099] of byte;
   tmpBuf: array of integer;
   mult: double;
   mag: double;
begin

   Label1.caption:='Volume: '+inttostr(trackbar1.position)+'%';
   Label2.caption:='Frequency: '+inttostr(trackbar2.position*200)+' hz';

   for i:=0 to length(buffer) - 1 do begin
   mult := i / length(buffer);

   mag := (127 * trackbar1.position * 0.01) * Sin(2 * Pi * mult * trackbar2.position * 200);

   mag := mag + 127;
   buffer[i] := round(mag);
   end;

   setLength(tmpbuf, 128);
   for i:=0 to 127 do begin
   tmpBuf[i]:=round((buffer[i]-127)*256);
   end;

   DrawSgnl(tmpBuf);

   if Opened = false then begin
   playBuffer(buffer);
   end else begin
   for i:=0 to 1do 

   copyMemory(pBuffer[i], @buffer, length(buffer));

   end;

end;

procedure tform1.stopGenerate;
var
   i: integer;
begin

   WaveOutReset(WaveOut);
   WaveOutClose(WaveOut);

   for i:=0 to 1 do begin
   GlobalUnlock(pBuf[i]);
   GlobalFree(pBuf[i]);
   end;

   fPlay:=false;

end;

procedure TForm1.DrawSgnl(graphBuf: array of integer);
var
   i, tmpX, tmpY: integer;
begin
   PaintBoxSgnl.Refresh;

  with PaintBoxSgnl.Canvas do begin
   pen.style := psSolid;
   pen.Color := clRed;
   brush.style := bsSolid;
   brush.color:=clBlue;
   Rectangle(0,0,PaintBoxSgnl.Width,PaintBoxSgnl.Height);
  end;

   PaintBoxSgnl.Canvas.MoveTo(0, PaintBoxSgnl.Height div 2);
 for i:=0 to length(graphbuf) - 1 do
  begin
   tmpX := Round(i*PaintBoxSgnl.Width/length(graphBuf));
   tmpY := PaintBoxSgnl.Height div 2 - Round(graphBuf[i]*PaintBoxSgnl.Height/2/32767);
   PaintBoxSgnl.Canvas.LineTo(tmpX, tmpY);
  end;
end;

end.