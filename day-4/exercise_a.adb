with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Fixed, Ada.Strings.Unbounded, ada.Strings.Unbounded.Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Fixed, Ada.Strings.Unbounded, ada.Strings.Unbounded.Text_IO;

procedure exercise_a is
    --  Variable declarations
    File : file_type;
    nameOK : boolean := false;
    input_line : unbounded_string;
    partA : unbounded_string;
    partB : unbounded_string;
    delimiter_pos : integer;
    rangeA_low : integer;
    rangeA_high : integer;
    rangeB_low : integer;
    rangeB_high : integer;
    full_overlaps : integer := 0 ;

    procedure split(
        TheString : in String; Pos : in Integer;
        Part1 : out String; Part2 : out String) is 
    begin
        Move(TheString(TheString'First .. Pos - 1), Part1);
        Move(TheString(Pos .. TheString'Last), Part2);
    end split;

begin
    Open (File => file,
         Mode => In_File,
         Name => "input.txt");
    While not End_Of_File (file) Loop
        input_line := Get_Line (file);

        delimiter_pos := Index (input_line, ",");
        partA := To_Unbounded_String(Slice(input_line, 1, delimiter_pos-1));
        partB := To_Unbounded_String(Slice(input_line, delimiter_pos+1, Length(input_line)));

        delimiter_pos := Index (partA, "-");
        rangeA_low := Integer'Value(Slice(partA, 1, delimiter_pos-1));
        rangeA_high := Integer'Value(Slice(partA, delimiter_pos+1, Length(partA)));

        delimiter_pos := Index (partB, "-");
        rangeB_low := Integer'Value(Slice(partB, 1, delimiter_pos-1));
        rangeB_high := Integer'Value(Slice(partB, delimiter_pos+1, Length(partB)));

        if rangeA_low <= rangeB_low and rangeA_high >= rangeB_high then
            full_overlaps := full_overlaps + 1;
        elsif rangeB_low <= rangeA_low and rangeB_high >= rangeA_high then
            full_overlaps := full_overlaps + 1;
        end if;
    end loop;
    Put_Line ("Number of overlapping ranges:" & Integer'Image(full_overlaps));
end exercise_a;