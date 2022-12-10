fileName = "input.txt"
conn = file(fileName,open="r")
lines = readLines(conn)

n_max = length(lines)

# 0 not visited, 1 visited
fields = array(0, dim = c(n_max * 2, n_max * 2))

rope = array(c(n_max, n_max), dim = c(10, 2))
fields[rope[10,1], rope[10,2]] = 1

for (i in 1:length(lines)) {
  input_parts = unlist(strsplit(lines[i], " "))
  direction = input_parts[1]
  n_steps = strtoi(input_parts[2])

  for (j in 1:n_steps) {
    if (direction == "R") {
      rope[1, 2] = rope[1, 2] + 1
    } else if (direction == "L") {
      rope[1, 2] = rope[1, 2] - 1
    } else if (direction == "U") {
      rope[1, 1] = rope[1, 1] - 1
    } else if (direction == "D") {
      rope[1, 1] = rope[1, 1] + 1
    }
    for (k in 2:10) {
      ahead = rope[k-1,]
      current = rope[k,]
      diff = ahead - current
      if (abs(diff[1]) == 2 && abs(diff[2]) == 2) {
        rope[k,1] = rope[k,1] + sign(diff[1])
        rope[k,2] = rope[k,2] + sign(diff[2])
      } else if (abs(diff[1]) == 2) {
        rope[k,1] = rope[k,1] + sign(diff[1])
        rope[k,2] = rope[k-1,2]
      } else if (abs(diff[2]) == 2) {
        rope[k,2] = rope[k,2] + sign(diff[2])
        rope[k,1] = rope[k-1,1]
      }
    }
    fields[rope[10,1], rope[10,2]] = 1
  }
}
close(conn)

print("Solution:")
print(sum(fields))