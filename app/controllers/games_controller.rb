class GamesController < ApplicationController

  require 'open-uri'
  require 'json'

  MESSAGE = {
  MSG0: "OK",
  MSG1: "Sorry but <%= @word %> can't be build out of  <%= @letters %>",
  MSG2: "Sorry but <%= @word %> is not an english word...",
  MSG3: "<strong>Congratulation!</strong> <%= @word %> is a valid English word!"
  }

  def new
    @letters = generate_grid(10)
  end

  def score
    @word = params[:answer]
    @letters = params[:letters]
    @message = check_letters(@word, @letters.split(" "))
    @message = test_word(@word) if @message == MESSAGE[:MSG0]
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    letter_list = ('A'..'Z').to_a
    tirage = []
    (1..grid_size).each { tirage << letter_list.sample }
    tirage
  end

  def check_letters(attempt, letter_list)
    message = "Sorry but #{attempt} can't be build out of #{letter_list.join(',')}"
    retour = MESSAGE[:MSG0]
    attempt.chars.each do |letter|
      index = letter_list.find_index(letter.upcase)
      if index
        letter_list.delete_at(index)
      else
        retour = message
      end
    end
    retour
  end

  def test_word(attempt)
    url = "https://dictionary.lewagon.com/#{attempt.downcase}"
    answer_serialized = URI.open(url).read
    answer = JSON.parse(answer_serialized)
    answer['found'] ? "<strong>Congratulation!</strong> #{attempt} is a valid English word!" : "Sorry but #{attempt} is not an english word..."
  end

end
