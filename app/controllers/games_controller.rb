require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = compare?(@word, @letters)
    @english_word = valid_word?(@word)
  end

  private

  def compare?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_word?(word)
    url = open("https://wagon-dictionary.herokuapp.com/#{word}")
    word_hash = JSON.parse(url.read.to_s)
    word_hash['found']
  end
end
