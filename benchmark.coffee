spawn = require("child_process").spawn


generateString = (stringLength) ->
  string = []

  for i in [0...stringLength]
    string.push String.fromCharCode(Math.round(Math.random() * 25) + 97)

  string.join ""


do main = ->
  stringLength = 10000
  iterations = 1
  iteration = 1
  times = []

  process.stdout.write "\n"
  process.stdout.write "String length: #{stringLength}\n"
  process.stdout.write "Iterations: #{iterations}\n"
  process.stdout.write "\n"

  done = ->
    averageTime = 0
    averageTime += time for time in times
    averageTime /= iterations

    process.stdout.write "\n"
    process.stdout.write "Average: #{averageTime}ms\n"


  do test = ->
    process.stdout.write "Test ##{iteration}"

    tolstoyInput = "10\n"

    for i in [0...10]
      tolstoyInput += generateString stringLength
      tolstoyInput += "\n"

    tolstoy = spawn "coffee", ["tolstoy.coffee"]

    tolstoy.on "close", (code) ->
      time = new Date - start
      process.stdout.write " #{time}ms\n"

      times.push time
      iteration += 1

      if iteration > iterations
        done()
      else
        test()

    start = new Date
    tolstoy.stdin.write tolstoyInput
