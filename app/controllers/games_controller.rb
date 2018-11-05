require 'open-uri'
require 'json'


class GamesController < ApplicationController

  def new
    @letters = []
    @grid = Array.new(10)
    @grid.each do |_|
      letter = Array('A'..'Z')
      @letters << letter[rand(letter.length)]
    end
    @start_time = Time.now
    @letters
  end

  def score
    @end = Time.now
    @start = Time.parse(params[:time])
    @word = params["word"]
    @letters = params[:letters]
    result_specs = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    @result = JSON.parse(result_specs)
    attemp_array = @word.upcase.split("")
    puts attemp_array
    if @result["found"] == true && attemp_array.all? { |n| attemp_array.count(n) <= @letters.count(n) }
      @score = { score: (@word.length * 10 - (@end - @start)), time: (@end - @start), message: "well done" }
    elsif @result["found"] != true
      @score = { score: 0.to_i, time: (@end - @start), message: "not an english word" }
    elsif attemp_array.all? { |n| attemp_array.count(n) <= @grid.count(n) } == false
      @score = { score: 0.to_i, time: (@end - @start), message: "not in the grid" }
    end

  end

end
