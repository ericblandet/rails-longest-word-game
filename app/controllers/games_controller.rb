require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    word = params[:word]
    grid = params[:grid].split
    if included?(word.upcase, grid)
      if english_word?(word)
        @message = "Congratulations #{word} is a valid english Word"
      else
        @message = "Sorry but #{word} is not an english word"
      end
    else
      @message = "Sorry but #{word} can't be built out of #{grid.join(", ")}"
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
