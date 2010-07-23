class Ticket
 attr_reader :venue, :date
 attr_accessor :price
 def initialize(venue, date)
   @venue = venue
   @date = date
 end
def Ticket.most_expensive(*tickets)
 tickets.max_by(&:price)
end
end

