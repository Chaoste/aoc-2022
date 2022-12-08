#!/usr/bin/perl
use warnings;
use strict;

my $filename = './input.txt';
my @trees;
my $row_idx = 0;
my $col_idx = 0;

open(my $fh, '<', $filename) or die $!;

while (my $row = <$fh>) {
  $col_idx = 0;
  chomp $row;
  for my $tree_height (split //, $row) {
    $trees[$row_idx][$col_idx] = $tree_height + 0;
    $col_idx++;
  }
  $row_idx++;
}

close($fh);

my $n_rows = $row_idx;
my $n_cols = $col_idx;

my $max_scenic_score = 0;

for my $i (1..$n_rows-2) {
  for my $j (1..$n_cols-2) {
    my $this_tree_height = $trees[$i][$j];
    # Check left
    my $left_visible_trees = 0;
    for (my $k=$j-1; $k >= 0; $k--) {
      $left_visible_trees++;
      my $other_tree_height = $trees[$i][$k];
      if ($other_tree_height >= $this_tree_height) {
        last;
      }
    }
    # Check right
    my $right_visible_trees = 0;
    for my $k ($j+1..$n_cols-1) {
      my $other_tree_height = $trees[$i][$k];
      $right_visible_trees++;
      if ($other_tree_height >= $this_tree_height) {
        last;
      }
    }
    # Check top
    my $top_visible_trees = 0;
    for (my $k=$i-1; $k >= 0; $k--) {
      my $other_tree_height = $trees[$k][$j];
      $top_visible_trees++;
      if ($other_tree_height >= $this_tree_height) {
        last;
      }
    }
    # Check bottom
    my $bottom_visible_trees = 0;
    for my $k ($i+1..$n_rows-1) {
      my $other_tree_height = $trees[$k][$j];
      $bottom_visible_trees++;
      if ($other_tree_height >= $this_tree_height) {
        last;
      }
    }
    # Compare scenic score with max
    my $scenic_score = $left_visible_trees * $right_visible_trees * $top_visible_trees * $bottom_visible_trees;
    if ($scenic_score > $max_scenic_score) {
      $max_scenic_score = $scenic_score;
    }
  }
}

print "Max scenic score -> ";
print($max_scenic_score);
print "\n";


