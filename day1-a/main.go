package main

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
  "slices"
  "math"
)

func main() {
  args := os.Args[1:]

  input_filename := args[0];
  file_handle, err := os.Open(input_filename)
  if err != nil {
    fmt.Println(err)
    return
  }

  reader := bufio.NewReader(file_handle)
  scanner := bufio.NewScanner(reader)

  var left []int
  var right []int

  for scanner.Scan() {
    numbers := strings.Fields(scanner.Text());

    number_left, err := strconv.Atoi(numbers[0])
    if err != nil {
      fmt.Println(err)
      return
    }
    left = append(left, number_left)

    number_right, err := strconv.Atoi(numbers[1])
    if err != nil {
      fmt.Println(err)
      return
    }
    right = append(right, number_right)
  }

  slices.Sort(left)
  slices.Sort(right)

  sum_diff := 0
  for i := 0; i < len(left); i++ {
    sum_diff += int(math.Abs(float64(right[i] - left[i])))
  }
  fmt.Println("sum diff is:", sum_diff)

  return
}

