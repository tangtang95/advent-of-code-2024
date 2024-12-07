package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	args := os.Args[1:]

	input_filename := args[0]
	file_handle, err := os.Open(input_filename)
	if err != nil {
		fmt.Println(err)
		return
	}

	reader := bufio.NewReader(file_handle)
	scanner := bufio.NewScanner(reader)

  safeReportCount := 0
	for scanner.Scan() {
    isSafeReport := true
    isIncreasing := false
    splittedLevel := strings.Split(scanner.Text(), " ")
    for i := 0; i < len(splittedLevel) - 1; i ++ {
			firstNumber, err := strconv.Atoi(splittedLevel[i])
			if err != nil {
				fmt.Println(err)
				return
			}

			secondNumber, err := strconv.Atoi(splittedLevel[i + 1])
			if err != nil {
				fmt.Println(err)
				return
			}

      if (i == 0) {
        if firstNumber < secondNumber {
          isIncreasing = true
        } else {
          isIncreasing = false
        }
      }

      if isIncreasing && (secondNumber <= firstNumber || secondNumber - firstNumber > 3) {
        isSafeReport = false
        break
      }

      if !isIncreasing && (secondNumber >= firstNumber || firstNumber - secondNumber > 3) {
        isSafeReport = false
        break
      }

		}

    if isSafeReport {
      safeReportCount ++
    }

	}

	fmt.Println("number of safe reports:", safeReportCount)

	return
}
