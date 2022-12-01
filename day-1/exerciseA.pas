PROGRAM ExerciseA;
// https://stackoverflow.com/questions/26553801/pascal-closefile-not-found
// Requires Delphi compilation mode with -Sd

USES Crt, SysUtils;

CONST
  INPUT_FNAME = 'input.txt';

VAR
  tfIn: TextFile;
  inputLine: string;
  currentCalories: integer;
  currentIndex: integer;
  maxCalories: integer;
  maxIndex: integer;

PROCEDURE ReadAndFindMax;
BEGIN
  // ClrScr;
  WriteLn ('Reading input file and finding elf with the most calories');

  currentCalories := 0;
  currentIndex := 0;
  maxCalories := 0;
  maxIndex := 0;

  AssignFile(tfIn, INPUT_FNAME);

  try
    reset(tfIn);

    while not eof(tfIn) do begin
      readln(tfIn, inputLine);
      if Length(inputLine) = 0 Then Begin
         if currentCalories > maxCalories Then Begin
            maxCalories := currentCalories;
            maxIndex := currentIndex;
         End;
         currentCalories := 0;
         currentIndex := currentIndex + 1;
      End Else Begin
         currentCalories := currentCalories + StrToInt(inputLine);
      End
    end;

    // Done so close the file
    CloseFile(tfIn);
    WriteLn(Format('Elf #%d carries %d calories',[maxIndex, maxCalories]));

  except
    on E: EInOutError do
     writeln('File handling error occurred. Details: ', E.Message);
    On E : EConvertError do
     Writeln ('Invalid number encountered');
  end;
END;

begin
   ReadAndFindMax;
end.