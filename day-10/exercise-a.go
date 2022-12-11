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
		measurements := 0

		increaseCycle:= func() {
			cycle = cycle + 1
			if ((cycle + 20) % 40 == 0) {
				signal_strength := cycle * register
				measurements = measurements + signal_strength
				fmt.Printf("cycle: %d, register: %d, signal strength: %d\n", cycle, register, signal_strength)
			}
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

		fmt.Printf("Final | cycle: %d, register: %d, signal strengths: %d\n", cycle, register, measurements)
	
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
}