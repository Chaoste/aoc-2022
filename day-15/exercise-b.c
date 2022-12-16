#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <sys/time.h>

#define CHARS_PER_LINE 256
#define NUMBER_OF_LINES 32 // 14, 32
#define BOUNDARY 4000000 // 20, 4000000

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
      signals[i][0] = extract_group_number(groupArray, 1, lines[i]);
      signals[i][1] = extract_group_number(groupArray, 2, lines[i]);
      beacons[i][0] = extract_group_number(groupArray, 3, lines[i]);
      beacons[i][1] = extract_group_number(groupArray, 4, lines[i]);
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

// Src: https://www.codesansar.com/c-programming-examples/sort-array-ascending-order-user-defined-function.htm
void sort_by_start(int ranges[NUMBER_OF_LINES][2], int n) {
 int i, j, temp0, temp1;
 for(i = 0 ; i < n-1; i++) {
  for(j = i+1; j < n; j++) {
   if(ranges[i][0] > ranges[j][0]) {
    temp0 = ranges[i][0];
    temp1 = ranges[i][1];
    ranges[i][0] = ranges[j][0];
    ranges[i][1] = ranges[j][1];
    ranges[j][0] = temp0;
    ranges[j][1] = temp1;
   }
  }
 }
}

int contains_number(int array[NUMBER_OF_LINES*2], int n, int value) {
  int isElementPresent = 0;
  for (int i = 0; i < n; i++) {
    if (array[i] == value) {
      isElementPresent = 1;
      break;
    }
  }
  return isElementPresent;
}

long long timeInMilliseconds(void) {
    struct timeval tv;

    gettimeofday(&tv,NULL);
    return (((long long)tv.tv_sec)*1000)+(tv.tv_usec/1000);
}


int main(void) {
  char lines[NUMBER_OF_LINES][CHARS_PER_LINE];
  int signals[NUMBER_OF_LINES][2];
  int beacons[NUMBER_OF_LINES][2];
  int target_row = -1;
  int target_col = -1;
  long long lastTimestamp = timeInMilliseconds();
  
  unsigned int n_lines = read_file(lines);
  parse_file(lines, signals, beacons);

  for (int row = 0; row < BOUNDARY && target_row == -1; row++) {
    int ranges[NUMBER_OF_LINES][2];
    int range_count = 0;

    for(int i = 0; i < NUMBER_OF_LINES; ++i) {
      int* signal = signals[i];
      int* beacon = beacons[i];
      int diff = abs(signal[0]-beacon[0]) + abs(signal[1]-beacon[1]);
      int k = row - signal[1];
      if (k >= -diff && k <= diff) {
        // The target row is within the range
        int offset = diff - abs(k);
        int range_start = signal[0] - offset;
        int range_end = signal[0] + offset + 1;
        // printf("start=%d end=%d\n", range_start, range_end);
        ranges[range_count][0] = range_start;
        ranges[range_count][1] = range_end;
        range_count++;
      }
    }

    // Idea from https://www.geeksforgeeks.org/merging-intervals/
    sort_by_start(ranges, range_count);
    int final_ranges[NUMBER_OF_LINES*2][2];
    int final_range_count = 1;
    // Add the first range (with the lowest start index)
    final_ranges[0][0] = ranges[0][0];
    final_ranges[0][1] = ranges[0][1];
    for(int i = 1; i < range_count; ++i) {
      int* range = ranges[i];
      int* previous_range = final_ranges[final_range_count-1];
      if (previous_range[1] < range[0]) {
        // Not overlapping, add the new range
        final_ranges[final_range_count][0] = range[0];
        final_ranges[final_range_count][1] = range[1];
        final_range_count++;
      } else {
        // Extend the existing range if the new end is greater
        if (range[1] > final_ranges[final_range_count-1][1]) {
          final_ranges[final_range_count-1][1] = range[1];
        }
      }
    }
    
    int blocked_fields = 0;
    for(int i = 0; i < final_range_count; ++i) {
      int* range = final_ranges[i];
      // printf("Range for row %d: %d - %d\n", row, range[0], range[1]);
      int range_size = range[1] - range[0];
      blocked_fields = blocked_fields + range_size;
      // if (range[0] )
      if (range[0] > 0 || range[1] < BOUNDARY) {
        target_row = row;
        if (range[0] > 0) {
          target_col = range[0] - 1;
        } else {
          target_col = range[1];
        }
        printf("FOUND IT! %d, %d\n", target_row, target_col);
        break;
      }
    }
  }

  printf("Run time in ms: %lld \n", timeInMilliseconds() - lastTimestamp);
  lastTimestamp = timeInMilliseconds();

  long long tuning_frequency = ((long)target_col) * 4000000 + ((long)target_row);
  printf("Solution: %d | %d ---> %lld\n", target_row, target_col, tuning_frequency);
  return 0;
}