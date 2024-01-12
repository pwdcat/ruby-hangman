require 'yaml'

filename = 'google-10000-english-no-swears.txt'

# Game Class for saving and loading
class Game
  attr_accessor :lives, :word, :guessArray, :charactersUsed

  def initialize(lives, word, guessarray, charactersused)
    @lives = lives
    @word = word
    @guessArray = guessarray
    @charactersUsed = charactersused
  end

  def save_file
    gameData = {
      lives: @lives,
      word: @word,
      guessArray: @guessArray,
      charactersUsed: @charactersUsed
    }

    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('saves/save.yml', 'w') { |file| file.write(gameData.to_yaml) }
    puts 'Game saved'
  end

  def load_file
    loadGame = YAML.load(File.read('saves/save.yml'))

    puts 'Game loaded'

    @lives = loadGame[:lives]
    @word = loadGame[:word]
    @guessArray = loadGame[:guessArray]
    @charactersUsed = loadGame[:charactersUsed]
  end
end

# Turns Text into Hash{word, word's length}
dictionary = {}
File.open(filename, 'r') do |file|
  file.each_line do |word|
    dictionary[word.chomp] = word.chomp.length
  end
end

dictionary.keep_if { |_word, length| length.between?(5, 12) }

def getInput(used, game)
  loop do
    print 'Enter a letter: '
    input = gets.chomp.downcase
    if input == 'save'
      game.save_file
      next
    end
    return input if input.match?(/^[a-z]$/) && !used.include?(input)

    if used.include?(input)
      puts 'Character Used'
    else
      puts 'Invalid Input'
    end
  end
end

userInput = ''

puts 'New Game or Load Game?'
loop do
  print 'Please enter your choice ("new" or "load"): '
  userInput = gets.chomp.downcase

  break if %w[new load].include?(userInput)

  puts 'Invalid input. Please try again.'
end

game = Game.new(6, word = dictionary.keys.sample, guessArray = Array.new(dictionary[word], '_'), [])
game.load_file if userInput == 'load'

lives = game.lives
guessArray = game.guessArray
charactersUsed = game.charactersUsed
word = game.word

# Main Function
while lives.positive?
  puts '
Do you want to save your game? Type "save":
  '
  puts "Lives: #{lives}    Characters Used: #{charactersUsed}"
  puts guessArray.join(' ')
  answer = getInput(charactersUsed, game).downcase
  if word.include?(answer)
    charactersUsed.push(answer)
    guessArray.map!.with_index do |_text, index|
      word[index] == answer ? word[index] : guessArray[index]
    end
  else
    lives -= 1
  end
  next unless word == guessArray.join

  p "You Won! The word was #{word}"
  exit
end

p "You Lose, the word was #{word}"
