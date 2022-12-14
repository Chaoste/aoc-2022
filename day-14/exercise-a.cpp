// Your First C++ Program

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

// Src: https://stackoverflow.com/a/46931770/4816930
vector<string> split (string s, string delimiter) {
    size_t pos_start = 0, pos_end, delim_len = delimiter.length();
    string token;
    vector<string> res;

    while ((pos_end = s.find (delimiter, pos_start)) != string::npos) {
        token = s.substr (pos_start, pos_end - pos_start);
        pos_start = pos_end + delim_len;
        res.push_back (token);
    }

    res.push_back (s.substr (pos_start));
    return res;
}

void print_map(string map[200][200]) {
  for(int y = 0; y < 200; y++) {
    for(int x = 0; x < 200; x++) {
      cout << map[y][x];
    }
    cout << endl;
  }
}

void fill_map(string map[200][200]) {
  string line;
  for(int y = 0; y < 200; y++){
      for(int x = 0; x < 200; x++){
          map[y][x] = ".";
      }
  }

  ifstream input_file ("input.txt");
  if (input_file.is_open()) {
    while ( getline (input_file,line) ) {
      vector<string> positions = split(line, " -> ");
      for( unsigned int i = 0; i < positions.size() - 1; i = i + 1 ) {
        string pos1 = positions[i];
        string pos2 = positions[i+1];

        // cout << "from " << pos1 << " to " << pos2 << endl;

        vector<string> coords1 = split(pos1, ",");
        vector<string> coords2 = split(pos2, ",");

        int x1 = stoi(coords1[0]) - 400;
        int y1 = stoi(coords1[1]);
        int x2 = stoi(coords2[0]) - 400;
        int y2 = stoi(coords2[1]);

        for( unsigned int x = min(x1, x2); x <= max(x1, x2); x = x + 1 ) {
          for( unsigned int y = min(y1, y2); y <= max(y1, y2); y = y + 1 ) {
            map[y][x] = '#';
          }
        }
      }
    }
    input_file.close();
  }
  else cout << "Unable to open file";
}

bool drop_sand(string map[200][200]) {
  int sand[2] = {100, 0}; // 100|0 = 500|0
  // For debugging
  // map[sand[1]][sand[0]] = '+';
  while (map[sand[1]][sand[0]] == ".") {
    if (sand[1]+1 > 199) {
      // Sand drop fell into the void
      return false;
    } else if (map[sand[1]+1][sand[0]] == ".") {
      sand[1] = sand[1] + 1;
    } else if (map[sand[1]+1][sand[0]-1] == ".") {
      sand[1] = sand[1] + 1;
      sand[0] = sand[0] - 1;
    } else if (map[sand[1]+1][sand[0]+1] == ".") {
      sand[1] = sand[1] + 1;
      sand[0] = sand[0] + 1;
    } else {
      map[sand[1]][sand[0]] = 'o';
    }
  }
  return true;
}

int main (int argc, char **_argv) {
  // Coords: 0|0 = 400|0 ; 199|199 = 599|199
  string map[200][200];
  fill_map(map);
  int i = 0;
  while (drop_sand(map)) {
    i = i + 1;
  }
  if (argc > 1) {
    // Accept any additional parameter to print
    print_map(map);
  }
  cout << "Sand drops: " << i << "\n";
  return 0;
}