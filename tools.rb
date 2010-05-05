module bits_helper
# http://groups.google.com/group/comp.lang.ruby/browse_thread/thread/a8e4e2e860db9c45
# transforme un entier en tableau de bits
class Integer 
	def to_ba(size=8) 
    	a=[] 
		(size-1).downto(0) do |i| 
		a<<self[i] 
		end 
		a 
	end 
end 

# transforme un tableau de bits en entier

class Array
	def to_i(radix=2)
		self.to_s.to_i(radix)
	end
end
	
