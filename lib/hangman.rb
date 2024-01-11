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

p word
