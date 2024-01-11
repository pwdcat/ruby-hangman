filename = 'google-10000-english-no-swears.txt'

# Turns Text into Hash{word, word's length}
dictionary = {}
File.open(filename, 'r') do |file|
  file.each_line do |word|
    dictionary[word.chomp] = word.chomp.length
  end
end

dictionary.keep_if { |_word, length| length.between?(5, 12) }

# Pick random word
word = dictionary.keys.sample

guessArray = Array.new(dictionary[word], '_')

def getInput
  loop do
    puts 'Enter a letter: '
    input = gets.chomp
    return input if input.length == 1

    puts 'Invalid Input'
  end
end

lives = 6

while lives.positive?
  p lives
  p guessArray.join(' ')
  answer = getInput
  if word.include?(answer)
    guessArray.map!.with_index do |_text, index|
      word[index] == answer ? word[index] : guessArray[index]
    end
  else
    lives -= 1
  end
end
