#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHARS_PER_LINE 256
#define NUMBER_OF_LINES 16

unsigned int read_file(char lines[NUMBER_OF_LINES][CHARS_PER_LINE]) {
  FILE *fptr = NULL; 
  int i = 0;
  fptr = fopen("input.txt", "r");
  while(fgets(lines[i], CHARS_PER_LINE, fptr)) {
      lines[i][strlen(lines[i]) - 1] = '\0';
      i++;
  }
  int total = i;
  for(i = 0; i < total; ++i) {
      // printf("%s\n", lines[i]);
  }
  return total;
}

unsigned int read_file_line_by_line() {
  FILE * fp;
  char * line = NULL;
  size_t buffer_size = 0;
  unsigned int line_count = 0;
  ssize_t line_length;

  fp = fopen("input.txt", "r");
  if (fp == NULL)
      exit(EXIT_FAILURE);
  while ((line_length = getline(&line, &buffer_size, fp)) != -1) {
      // printf("%s", line);
      line_count = line_count + 1;
  }
  fclose(fp);
  if (line) {
    free(line);
  }
  return line_count;
}


int main(void) {
  char lines[NUMBER_OF_LINES][CHARS_PER_LINE];
  unsigned int n_lines = read_file(lines);
  // unsigned int n_lines = read_file_line_by_line();
  
  printf("Solution: ?\n");
  return 0;
}