require "open-uri"

class GamesController < ApplicationController
    VOWELS = %w(A E I O U Y)
    START_TIME = Time.now

    def new
        @letters = Array.new(5) { VOWELS.sample }
        @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
        @letters.shuffle!
    end
    
    def score
        @time = Time.now - START_TIME
        @letters = params[:letters].split
        @word = (params[:guess] || "").upcase
        @check_word = check_word(@word)
        @correct_letters = correct_letters(@word, @letters)
        @score = calculate_score(@word,@time)
    end

    private

    def correct_letters(word, letters)
        word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
    end

    def check_word(guess)
        response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
        json = JSON.parse(response.read)
        json['found']
    end

    def calculate_score(attempt, time_taken)
        time_taken > 60.0 ? 0 : (attempt.size * (1.0 - (time_taken / 60.0)))
        if !@check_word || !@correct_letters
            0
        end
    end
end
