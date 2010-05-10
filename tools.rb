require 'ipaddr'

module Tools
# http://groups.google.com/group/comp.lang.ruby/browse_thread/thread/a8e4e2e860db9c45
# transforme un entier en tableau de bits
module IntegerExtensions
	def to_ba(size=8) 
		a=[]
		(size-1).downto(0) do |i| 
		a<<self[i] 
		end 
		a 
	end 
end 

# transforme un tableau de bits en entier

module ArrayExtensions
	def to_i(radix=2)
		self.to_s.to_i(radix)
	end
end

# retourne false si l'intersection est vide sinon retoune le resultat sous forme de tableau
module RangeExtensions
	def intersec?(range)
		result = self.to_a & range.to_a
		result == [] ? false : result
	end
end

# retourne false si l'intersection est vide sinon retoune le resultat sous forme d'objet IPAddr

module IPAddrExtensions
	def intersec?(arg)
		if self.include? arg
			self.~
			arg
		elsif arg.include? self
			arg.~
			self
		else
			false
		end
	end
end

end


Integer.send(:include, Tools::IntegerExtensions)
Array.send(:include, Tools::ArrayExtensions)
Range.send(:include, Tools::RangeExtensions)
IPAddr.send(:include, Tools::IPAddrExtensions)
