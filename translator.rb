require 'tools'
module PFTranslator
	
	include Tools
	
	#@rxp =  Regexp.new('\b(?:\d{1,3}\.){3}\d{1,3}\b')
	
	def pix_addr_translate(a_string)
		# contient "object-group"
		if a_string.include('object_group')
			return '$' + a_string.gsub('object-group', '').strip.chomp
		
		
		elsif a.string.include('host')
			clean_string = a_string.gsub('host','').strip.chomp
			if clean_string.is_ip?
				# contient une ip num�rique
				return clean_string
			else
				# contient un alias
				return '$' + clean_string
			end
		
		# contient un r�seau
		splited_string = a_string.split(' ')
		elsif splited_string[0].is_ip?
			return addr_to_cidr(a_string)
		else
			return '$' + splited_string[0].strip + netmask_to_cidr[1]
		end
	end
	
	def ios_addr_translate(a_string)
		if a_string.include?('host')
			return a_string.gsub('host','').strip.chomp
		else
			return netaddr_to_cidr(a_string)
		end
	end
	
	def ios_port_translate(a_string)
		splited_string = a_string.split(' ')
		
		if splited_string[0].include?('range')
			return splited_string[1] + ':' + splited_string[2]
		elsif splited_string[0].include?('eq')
			return splited_string[1]
		elsif splited_string[0].include('gt')
			return splited_string[1] + ':' + '65535'
		end
	end
	
	def pix_port_translate(a_string)
		splited_string = a_string.split(' ')
		if splited_string[0].include?('object_group')
			return '$' + a_string.gsub('object-group', '').strip.chomp
		elsif splited_string[0].include?('range')
			return splited_string[1] + ':' + splited_string[2]
		elsif splited_string[0].include?('eq')
			return splited_string[1]
		elsif splited_string[0].include('gt')
			return splited_string[1] + ':' + '65535'
		end
	end	
			
								
			
			
		
			
end
