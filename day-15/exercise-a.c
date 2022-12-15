#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#define CHARS_PER_LINE 256
#define NUMBER_OF_LINES 32
#define MAP_SIZE 60

unsigned int read_file(char lines[NUMBER_OF_LINES][CHARS_PER_LINE]) {
  FILE *fptr = NULL; 
  int i = 0;
  fptr = fopen("input.txt", "r");
  while(fgets(lines[i], CHARS_PER_LINE, fptr)) {
      lines[i][strlen(lines[i]) - 1] = '\0';
      i++;
  }
  int total = i;
  return total;
}

int extract_group_number(regmatch_t* groupArray, int group_index, char* source) {
  char* substr = malloc(256);
  char sourceCopy[strlen(source) + 1];
  strcpy(sourceCopy, source);
  sourceCopy[groupArray[group_index].rm_eo] = 0;
  strncpy(substr, sourceCopy+groupArray[group_index].rm_so, groupArray[group_index].rm_eo);
  return atoi(substr);
}

// Src 1: https://stackoverflow.com/a/1085120/4816930
// Src 2: https://stackoverflow.com/a/11864144/4816930
void parse_file(char lines[NUMBER_OF_LINES][CHARS_PER_LINE], int signals[NUMBER_OF_LINES][2], int beacons[NUMBER_OF_LINES][2]) {
  regex_t regex;
  int reti;
  char msgbuf[100];

  char * regexString = "^Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)$";
  size_t maxGroups = 5;

  regex_t regexCompiled;
  regmatch_t groupArray[maxGroups];

  /* Compile regular expression */
  reti = regcomp(&regex, regexString, REG_EXTENDED);
  if (reti) {
      fprintf(stderr, "Could not compile regex\n");
      exit(1);
  }

  for(int i = 0; i < NUMBER_OF_LINES; ++i) {
    /* Execute regular expression */
    reti = regexec(&regex, lines[i], maxGroups, groupArray, 0);
    if (!reti) {
      signals[i][0] = extract_group_number(groupArray, 1, lines[i]) + MAP_SIZE / 2;
      signals[i][1] = extract_group_number(groupArray, 2, lines[i]) + MAP_SIZE / 2;
      beacons[i][0] = extract_group_number(groupArray, 3, lines[i]) + MAP_SIZE / 2;
      beacons[i][1] = extract_group_number(groupArray, 4, lines[i]) + MAP_SIZE / 2;
    } else if (reti == REG_NOMATCH) {
      puts("No match");
      puts(lines[i]);
      exit(1);
    } else {
      regerror(reti, &regex, msgbuf, sizeof(msgbuf));
      fprintf(stderr, "Regex match failed: %s\n", msgbuf);
      exit(1);
    }
  }

  /* Free memory allocated to the pattern buffer by regcomp() */
  regfree(&regex);
}

void fill_map(char map[MAP_SIZE][MAP_SIZE]) {
  for(int i = 0; i < MAP_SIZE; ++i) {
    for(int j = 0; j < MAP_SIZE; ++j) {
      map[i][j] = '.';
    }
  }
}

void print_map(char map[MAP_SIZE][MAP_SIZE]) {
  for(int i = 0; i < MAP_SIZE; ++i) {
    int row = (i - MAP_SIZE/2) % 100;
    if (row < -9) {
      printf("%d ", row);
    } else if (row >=0 && row < 10) {
      printf("  %d ", row);
    } else {
      printf(" %d ", row);
    }
    for(int j = 0; j < MAP_SIZE; ++j) {
      printf("%c", map[j][i]);
    }
    printf("\n");
  }
  printf("\n");
}

int main(void) {
  char lines[NUMBER_OF_LINES][CHARS_PER_LINE];
  int signals[NUMBER_OF_LINES][2];
  int beacons[NUMBER_OF_LINES][2];
  // static char map[MAP_SIZE][MAP_SIZE];
  // puts("Fill map");
  // fill_map(map);
  int ranges[NUMBER_OF_LINES*2][2];
  int range_count = 0;
  int target_row = 10;

  puts("Read file");
  unsigned int n_lines = read_file(lines);

  puts("Parse file");
  parse_file(lines, signals, beacons);

  puts("Process signals");
  for(int i = 0; i < 1; ++i) { // NUMBER_OF_LINES
    int* signal = signals[i];
    int* beacon = beacons[i];
    printf("%d %d %d \n", i, signal[0], signal[1]);
    printf("%d %c %c \n", i, map[signal[0]][signal[1]], map[beacon[0]][beacon[1]]);
    puts("add signal and beacon");
    // map[signal[0]][signal[1]] = 'S';
    // map[beacon[0]][beacon[1]] = 'B';
    int diff = abs(signal[0]-beacon[0]) + abs(signal[1]-beacon[1]);
    printf("Diff is %d\n", diff);
    for(int k = -diff; k <= diff; ++k) {
      if (k == 20) {

      }
      for(int j = -diff; j <= diff; ++j) {
        if (abs(j)+abs(k) <= diff && map[signal[0]+j][signal[1]+k] == '.') {
          map[signal[0]+j][signal[1]+k] = '#';
        }
      }
    }
  }

  // print_map(map);

  int count_pos = 0;
  for(int i = 0; i < MAP_SIZE; ++i) {
    if (map[i][10+MAP_SIZE/2] == '#') {
      ++count_pos;
    }
  }
  
  printf("Solution: %d\n", count_pos);
  return 0;
}