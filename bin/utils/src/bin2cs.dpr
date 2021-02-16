program bin2cs;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;


procedure BinToCS(const FileName, outfile: string);
var N         : integer; 
    ByteRead  : byte; 
    BufStr    : string;
    BufAob    : array[0..4] of byte;
    PassCount, 
    EndSize   : integer; 
    FluxIn, 
    FluxOut   : TStream;
const 
  BTC : array[0..$F] of byte = ($30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$41,$42,$43,$44,$45,$46);
  EOB : array[boolean] of byte = ($2C,$7D); //, }
begin
  if not FileExists(FileName) then 
    Exit;

  FluxIn  := TFileStream.Create(FileName, fmOpenRead); 
  try 
    if FluxIn.Size < (1024*1024) then 
    begin 
      FluxOut := TFileStream.Create(outfile, fmCreate);
      try
        BufStr := '/* '+ FileName + ' (' + IntToStr(FluxIn.Size) + ' bytes) */'+#13#10+
                  'public readonly byte[] BinaryData = {'+#13#10#09#09;
        FluxOut.WriteBuffer(BufStr[1],Length(BufStr)); 

        PassCount := 0; 
        EndSize   := FluxIn.Size-1;

        for N := 0 to EndSize do
        begin
          FluxIn.ReadBuffer(ByteRead,1);
          BufAob[0] := Ord('0');
          BufAob[1] := Ord('x');
          BufAob[2] := BTC[ByteRead shr 4];
          BufAob[3] := BTC[ByteRead and $F];
          BufAob[4] := EOB[N = EndSize];
          FluxOut.WriteBuffer(BufAob,SizeOf (BufAob)); 

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
    Writeln('bin2cs: Convert binary file to C# source');
    Writeln('');
    Writeln('\tUsage:  bin2cs inputfile [outfile]');
    Exit;
  end;

  if i > 1 then outfile := ParamStr(2)
  else outfile := ParamStr(1) + '.cs';

  BinToCS(ParamStr(1), outfile);
end.
