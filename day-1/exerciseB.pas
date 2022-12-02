PROGRAM ExerciseA;
// https://stackoverflow.com/questions/26553801/pascal-closefile-not-found
// Requires Delphi compilation mode with -Sd

USES Crt, SysUtils;

CONST
  INPUT_FNAME = 'input.txt';

VAR
  tfIn: TextFile;
  inputLine: string;
  currentCalories: integer = 0;
  currentIndex: integer = 0;
  maxCaloriesPerIndex: array[0..2] of integer = (0, 0, 0);
  // 0 most, 1 second most, 2 third most
  maxIndices: array[0..2] of integer = (0, 0, 0);

PROCEDURE checkElf(index: integer; calories: integer);
BEGIN
  if calories > maxCaloriesPerIndex[0] then begin
    // shift ranking
    maxCaloriesPerIndex[2] := maxCaloriesPerIndex[1];
    maxCaloriesPerIndex[1] := maxCaloriesPerIndex[0];
    maxCaloriesPerIndex[0] := calories;
    maxIndices[2] := maxIndices[1];
    maxIndices[1] := maxIndices[0];
    maxIndices[0] := index;
  end else if calories > maxCaloriesPerIndex[1] then begin
    // shift ranking
    maxCaloriesPerIndex[2] := maxCaloriesPerIndex[1];
    maxCaloriesPerIndex[1] := calories;
    maxIndices[2] := maxIndices[1];
    maxIndices[1] := index;
  end else if calories > maxCaloriesPerIndex[2] then begin
    // shift ranking
    maxCaloriesPerIndex[2] := calories;
    maxIndices[2] := index;
  end
END;

PROCEDURE ReadAndFindMax;
BEGIN
  // ClrScr;
  WriteLn ('Reading input file and finding elf with the most calories');

  AssignFile(tfIn, INPUT_FNAME);

  try
    reset(tfIn);

    while not eof(tfIn) do begin
      readln(tfIn, inputLine);
      if Length(inputLine) = 0 Then Begin
         checkElf(currentIndex, currentCalories);
         currentCalories := 0;
         currentIndex := currentIndex + 1;
      End Else Begin
         currentCalories := currentCalories + StrToInt(inputLine);
      End
    end;

    // Assuming that the file doesn't end with an empty line
    checkElf(currentIndex, currentCalories);

    // Done so close the file
    CloseFile(tfIn);
    WriteLn(Format('Elf #%d carries %d calories',[maxIndices[0], maxCaloriesPerIndex[0]]));
    WriteLn(Format('Elf #%d carries %d calories',[maxIndices[1], maxCaloriesPerIndex[1]]));
    WriteLn(Format('Elf #%d carries %d calories',[maxIndices[2], maxCaloriesPerIndex[2]]));
    WriteLn(Format('Total calories: %d',[maxCaloriesPerIndex[0] + maxCaloriesPerIndex[1] + maxCaloriesPerIndex[2]]));

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