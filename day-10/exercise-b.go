package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
		"strconv"
)


func main() {

    f, _ := os.Open("input.txt")
    defer f.Close()
    scanner := bufio.NewScanner(f)

		register := 1
		cycle := 0

		increaseCycle:= func() {
			pixel_pos := cycle % 40
			if (cycle != 0 && pixel_pos == 0) {
				print("\n")
			}
			if (pixel_pos >= register - 1 && pixel_pos <= register + 1) {
				print("#")
			} else {
				print(".")
			}

			cycle = cycle + 1
		}

    for scanner.Scan() {
				line := scanner.Text()
				// if(cycle > 210 && cycle < 225) {
				// 	fmt.Printf("c: %d, r: %d, line: %s\n", cycle, register, line)
				// }
				if (line == "noop") {
					increaseCycle()
				} else if (line[:5] == "addx ") {
					addValue, _ := strconv.Atoi(line[5:])
					increaseCycle()
					increaseCycle()
					register = register + addValue
				}
    }

		fmt.Printf("\nFinal | cycle: %d, register: %d\n", cycle, register)
	
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
}