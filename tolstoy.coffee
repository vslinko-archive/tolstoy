## Substring iterator
#
#### Example:
#
# ```coffee
# it = new SubstringIterator "abba"
# it.forEach (substring) ->
#   console.log substring
# ```
#
#### Output:
#
# ```
# abba
# abb
# bba
# ab
# bb
# ba
# a
# b
# b
# a
# ```
#
class SubstringIterator
  constructor: (@string) ->
    @length = @string.length
    @occurrences = 1

  forEach: (callback) ->
    while @length > 0
      for pos in [0...@occurrences]
        res = callback @string.substr pos, @length
        return if res is false
      @length -= 1
      @occurrences += 1


## LCS for multiple strings
#
#### Example:
#
# ```coffee
# console.log mlcs [
#   "abacaba"
#   "mycabarchive"
#   "acabistrue"
# ]
# ```
#
#### Output:
#
# ```
# cab
# ```
#
mlcs = (strings) ->
  return false if strings.length < 2

  strings.sort (a, b) ->
    a.length > b.length

  firstString = strings.shift()
  result = false

  substrings = new SubstringIterator firstString
  substrings.forEach (substring) ->
    for string in strings
      return if string.indexOf(substring) == -1
    result = substring
    return false

  result


## STDIN line reader
#
inputReader = (callback) ->
  buffer = ""

  process.stdin.resume()
  process.stdin.on "data", (data) ->
    chunk = buffer + data.toString()

    if chunk.indexOf("\n") >= 0
      frames = chunk.split "\n"
      chunk = frames.pop()

      for frame in frames
        callback frame

    buffer = chunk

## Main function
#
do main = ->
  length = null
  strings = []

  inputReader (line) ->
    # expect length in first line
    unless length
      length = Number(line)

      unless length
        process.stderr.write "Invalid input\n"
        process.exit 1

      return

    # save next lines in array
    strings.push line

    # calculate mlcs if `length` lines provided
    if strings.length == length
      process.stdin.pause()

      result = mlcs strings
      return process.exit(2) unless result

      process.stdout.write result
      process.stdout.write "\n"
