require 'ipaddr'
require 'matrix'

module Tools
	def begin_with_a_space(a_string)
		s = StringScanner.new(a_string)
		return s.getch == " "
	end

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

	def netmask
		ipv4_regexp = Regexp.new(/\b(?:\d{1,3}\.){3}\d{1,3}\b/)
		ipv4_match = ipv4_regexp.match(self.inspect)
		netmask_match = ipv4_regexp.match(ipv4_match.post_match)
		netmask_match[0]
	end
	
	def to_cidr
		self.to_s + '/' + self.netmask
	end
	
	
end

module StringExtensions
	def intersec?(arg)
		values  =	Matrix[	[nil, 'ip', 'tcp', 'udp'],
							['ip', 'ip', 'tcp', 'udp'],
							['tcp', 'tcp', 'tcp', nil],
							['udp', 'udp', nil, 'udp']
							]
		values.intersec?(self,arg)
	end
end
				 
		
	
module 	MatrixExtentions
	def intersec?(arg1, arg2)
		i = self.row(0).to_a.index(arg1)
		j = self.colomn(0).to_a.index(arg2)
		self[i,j]	
	end
end

end


Integer.send(:include, Tools::IntegerExtensions)
Array.send(:include, Tools::ArrayExtensions)
Range.send(:include, Tools::RangeExtensions)
IPAddr.send(:include, Tools::IPAddrExtensions)
String.send(:include, Tools::StringExtensions)
Matrix.send(:include, Tools::MatrixExtentions)
