fileName = "input.txt"
conn = file(fileName,open="r")
lines = readLines(conn)

# 0 not visited, 1 visited
fields <- array(0, dim = c(1000, 1000))

head = c(500, 500)
tail = c(500, 500)
fields[tail[1], tail[2]] = 1

for (i in 1:length(lines)) {
  input_parts = unlist(strsplit(lines[i], " "))
  direction = input_parts[1]
  n_steps = strtoi(input_parts[2])

  for (j in 1:n_steps) {
    if (direction == "R") {
      head[2] = head[2] + 1
    } else if (direction == "L") {
      head[2] = head[2] - 1
    } else if (direction == "U") {
      head[1] = head[1] - 1
    } else if (direction == "D") {
      head[1] = head[1] + 1
    }
    diff = head - tail
    if (diff[1] == 2 || diff[1] == -2) {
      tail[1] = tail[1] + as.integer(diff[1] / 2)
      if (diff[2] == 1 || diff[2] == -1) {
        tail[2] = tail[2] + diff[2]
      }
    } else if (diff[2] == 2 || diff[2] == -2) {
      tail[2] = tail[2] + as.integer(diff[2] / 2)
      if (diff[1] == 1 || diff[1] == -1) {
        tail[1] = tail[1] + diff[1]
      }
    }
    fields[tail[1], tail[2]] = 1
  }
}
close(conn)
print("Solution:")
print(sum(fields))