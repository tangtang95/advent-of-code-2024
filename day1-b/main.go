package main

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
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

  countMapRight := make(map[int]int)

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
    val, present := countMapRight[number_right]
    if present {
      countMapRight[number_right] = val + 1
    } else {
      countMapRight[number_right] = 1
    }
  }

  sum_sim := 0
  for _, v := range left {
    val, present := countMapRight[v]
    if present {
      sum_sim += v * val
    }
  }

  fmt.Println("sum sim is:", sum_sim)

  return
}

