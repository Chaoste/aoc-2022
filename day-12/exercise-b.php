<?php

$handle = fopen("./input.txt", "r");
if (!$handle) {
  die("File not found");
}

$DEBUG = false;

function debug($str)
{
  global $DEBUG;
  if ($DEBUG == false) return;
  echo $str;
}

$map = array();
$direction = array();
$start = [0, 0];

while (($line = fgets($handle)) !== false) {
  $row = str_split($line);
  $result = array_map('ord', array_slice($row, 0, -1));
  $map[] = $result;
  if (($start_index = strpos($line, 'E')) !== false) {
    $start[0] = sizeof($map) - 1;
    $start[1] = $start_index;
  }
}

fclose($handle);

// Initialise
$distances = array();
$predecessors = array();
$visited = array();
$queue = array($start);
$INFINITE = 1000000;
for ($i = 0; $i < count($map); $i++) {
  for ($j = 0; $j < count($map[0]); $j++) {
    $distances[$i][$j] = $INFINITE;
    $predecessors[$i][$j] = null;
    $visited[$i][$j] = false;
  }
}
$distances[$start[0]][$start[1]] = 0;
$predecessors[$start[0]][$start[1]] = 'START';

function getNextVertex()
{
  global $distances, $queue;
  $next = array_shift($queue);
  if (!isset($next)) {
    die("Queue empty");
  }
  return [$distances[$next[0]][$next[1]], $next];
}

function print_route($show_direction = false)
{
  global $map, $direction, $start, $end;
  echo "\n";
  for ($i = 0; $i < count($map); $i++) {
    for ($j = 0; $j < count($map[0]); $j++) {
      if ($i == $start[0] && $j == $start[1]) {
        echo "S";
      } else if ($i == $end[0] && $j == $end[1]) {
        echo "E";
      } else if (!isset($direction[$i][$j])) {
        echo ".";
      } else if ($show_direction) {
        echo $direction[$i][$j];
      } else {
        echo chr($map[$i][$j]);
      }
    }
    echo "\n";
  }
  echo "\n";
}

$i = 0;

// Find shortest path for all vertices
while ($path === null) {
  $i++;
  [$dist, $pos] = getNextVertex();
  if ($pos === -1) die("No following vertex found!");

  debug("#" . $i . " Dist:" . $dist . " | Pos:" . $pos[0] . "," . $pos[1] . "\n");
  if ($map[$pos[0]][$pos[1]] == ord("a")) {
    $end = $pos;
    // Reached end, stop at any 'a'
    break;
  }
  $visited[$pos[0]][$pos[1]] = true;
  // Update neighbours
  $neighbours = [
    [$pos[0] - 1, $pos[1]],
    [$pos[0], $pos[1] - 1],
    [$pos[0] + 1, $pos[1]],
    [$pos[0], $pos[1] + 1],
  ];
  foreach ($neighbours as [$row, $col]) {
    if ($row < 0 || $row >= count($map)) continue;
    if ($col < 0 || $col >= count($map[0])) continue;
    if ($map[$row][$col] == ord("S") && $map[$pos[0]][$pos[1]] > ord("b")) continue; // S=a
    if ($map[$pos[0]][$pos[1]] == ord("E") && $map[$row][$col] < ord("y")) continue; // E=z
    if ($map[$pos[0]][$pos[1]] != ord("S") && $map[$row][$col] < $map[$pos[0]][$pos[1]] - 1) continue;
    if ($predecessors[$row][$col] != null) continue;
    debug(">" . $row . " | " . $col . "  " . $map[$pos[0]][$pos[1]] . " ~ " . $map[$row][$col] . " // " . ($distances[$pos[0]][$pos[1]] + 1) . ' < ' . $distances[$row][$col] . "\n");
    $alternative_dist = $distances[$pos[0]][$pos[1]] + 1;
    if ($alternative_dist < $distances[$row][$col]) {
      $distances[$row][$col] = $alternative_dist;
      $predecessors[$row][$col] = $pos;
      array_push($queue, [$row, $col]);
    }
  }
}

$path = array();
$previous_pivot = $end;
$pivot = $predecessors[$end[0]][$end[1]];
while (isset($pivot) && $pivot != 'START') {
  $direction[$pivot[0]][$pivot[1]] = '';
  if ($previous_pivot[0] > $pivot[0]) {
    $direction[$pivot[0]][$pivot[1]] = 'v';
  } else if ($previous_pivot[0] < $pivot[0]) {
    $direction[$pivot[0]][$pivot[1]] = '^';
  } else if ($previous_pivot[1] < $pivot[1]) {
    $direction[$pivot[0]][$pivot[1]] = '<';
  } else if ($previous_pivot[1] > $pivot[1]) {
    $direction[$pivot[0]][$pivot[1]] = '>';
  }
  array_unshift($path, $pivot);
  $previous_pivot = $pivot;
  $pivot = $predecessors[$pivot[0]][$pivot[1]];
}

print_route(true);
print_route(false);


debug($path[count($path) - 1]);
debug($path[count($path) - 2]);
debug($path[count($path) - 3]);
debug($path[count($path) - 4]);
var_dump(count($path));

echo "\n";
