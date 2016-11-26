require 'csv'
class PoliticiansController < ApplicationController

  def index
    @politicians = Politician.all
  end

  def new
  end

  def create(params)
    @politician = Politician.new(params)
    @politician.save
  end

end
