class HomeController < ApplicationController

  def index

    @politicians = Politician.order(:last_name)

    @states = Hash.new
    @politicians.each do |p|
      if @states.key?(FULL_STATES[p.state])
        @states[FULL_STATES[p.state]].push(p)
      else
        @states[FULL_STATES[p.state]] = [p]
      end

      number = p.phone.gsub(/[^0-9]/, '')
      a, b, c = number[0..2], number[3..5], number[6..-1]
      p.phone = [a, b, c].join('-')
    end
    #TODO sort states
    #@states = @states.sort
  end
end
