program bin2pas;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;


procedure BinToPas(const FileName, outfile: string);
var N         : integer; 
    ByteRead  : byte; 
    BufStr    : string;
    BufAob    : array[0..3] of byte; 
    PassCount, 
    EndSize   : integer; 
    FluxIn, 
    FluxOut   : TStream;
const 
  BTC : array[0..$F] of byte = ($30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$41,$42,$43,$44,$45,$46); 
  EOB : array[boolean] of byte = ($2C,$29); 
begin 
  if not FileExists(FileName) then 
    Exit;

  FluxIn  := TFileStream.Create(FileName, fmOpenRead); 
  try 
    if FluxIn.Size < (1024*1024) then 
    begin 
      FluxOut := TFileStream.Create(outfile, fmCreate);
      try
        BufStr := 'Const'+#13#10+
                  '  { '+FileName+' }'+#13#10+
                  '  BinaryData : array[0..'+inttostr(FluxIn.Size-1)+'] of byte = ('+#13#10#09#09; 
        FluxOut.WriteBuffer(BufStr[1],Length(BufStr)); 

        PassCount := 0; 
        EndSize   := FluxIn.Size-1;

        for N := 0 to EndSize do
        begin
          FluxIn.ReadBuffer(ByteRead,1);
          BufAob[0] := $24; // $ 
          BufAob[1] := BTC[ByteRead shr 4]; 
          BufAob[2] := BTC[ByteRead and $F]; 
          BufAob[3] := EOB[N = EndSize]; // , ou ) 
          FluxOut.WriteBuffer(BufAob,4); 

          PassCount := PassCount + 1; 
          if (PassCount = 16) and (N < EndSize) then
          begin 
            PassCount := 0; 
            BufStr := #13#10#09#09; 
            FluxOut.WriteBuffer(BufStr[1], Length(BufStr)); 
          end; 
        end; 

        BufStr := ';'+#13#10; 
        FluxOut.WriteBuffer(BufStr[1],3); 
      finally 
        FluxOut.Free; 
      end; 
    end; 
  finally 
    FluxIn.Free; 
  end; 
end; 

var
  outfile : string;
  i: Integer;
begin
  i := ParamCount;
  if i <= 0 then begin
    Writeln('bin2pas: Convert binary file to pascal source');
    Writeln('');
    Writeln('\tUsage:  bin2pas inputfile [outfile]');
    Exit;
  end;

  if i > 1 then outfile := ParamStr(2)
  else outfile := ParamStr(1) + '.pas';

  BinToPas(ParamStr(1), outfile);
end.
