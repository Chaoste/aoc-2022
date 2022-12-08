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
my $n_visible_edge_trees = 2 * $n_rows + 2 * $n_cols - 4;

my $n_visible_inner_trees = 0;

for my $i (1..$n_rows-2) {
  for my $j (1..$n_cols-2) {
    my $this_tree_height = $trees[$i][$j];
    my $is_visible = 0;
    # Check left
    my $is_left_visible = 1;
    for my $k (0..$j-1) {
      my $other_tree_height = $trees[$i][$k];
      if ($other_tree_height >= $this_tree_height) {
        $is_left_visible = 0;
        last;
      }
    }
    $is_visible = $is_left_visible;
    # Check right
    my $is_right_visible = 1;
    if (!$is_visible) {
      for my $k ($j+1..$n_cols-1) {
        my $other_tree_height = $trees[$i][$k];
        if ($other_tree_height >= $this_tree_height) {
          $is_right_visible = 0;
          last;
        }
      }
      $is_visible = $is_right_visible;
    }
    # Check top
    my $is_top_visible = 1;
    if (!$is_visible) {
      for my $k (0..$i-1) {
        my $other_tree_height = $trees[$k][$j];
        if ($other_tree_height >= $this_tree_height) {
          $is_top_visible = 0;
          last;
        }
      }
      $is_visible = $is_top_visible;
    }
    # Check bottom
    my $is_bottom_visible = 1;
    if (!$is_visible) {
      for my $k ($i+1..$n_rows-1) {
        my $other_tree_height = $trees[$k][$j];
        if ($other_tree_height >= $this_tree_height) {
          $is_bottom_visible = 0;
          last;
        }
      }
      $is_visible = $is_bottom_visible;
    }
    # Add
    if ($is_visible) {
      $n_visible_inner_trees++;
    }
  }
}

print "Visible trees -> ";
print($n_visible_edge_trees + $n_visible_inner_trees);
print "\n";


