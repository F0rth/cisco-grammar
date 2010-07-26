require 'tools'
module Translator
	
	include Tools
	
	#@rxp =  Regexp.new('\b(?:\d{1,3}\.){3}\d{1,3}\b')
	
	@icmp_table = Hash.new
	@icmp_table.update({'echo-reply' =>'icmp-type echorep'})
	@icmp_table.update({'echo' =>'icmp-type echoreq'})
	@icmp_table.update({'time-exceeded' =>'icmp-type timex'})
	@icmp_table.update({'packet-too-big' =>'icmp-type redir code needfrag'})
	@icmp_table.update({'traceroute' =>'icmp-type trace'})
	@icmp_table.update({'unreachable' =>'icmp-type echorep code net-unr'})
	
	
	def pix_addr_translate(a_string)	
		splited_string = a_string.split(' ')
		clean_string = a_string.gsub('host','').strip.chomp
		if a_string == 'any'
			return 'any'
		#contient "object-group"
		elsif a_string.include?('object-group')
			return '$' + a_string.gsub('object-group', '').strip.chomp
		elsif a_string.include?('host') 
			if clean_string.is_ipv4?
				# contient une ip numérique
				return clean_string
			else
				# contient un alias
				return '$' + clean_string
			end
		
		# contient un réseau
		elsif splited_string[0].is_ipv4?
			return addr_to_cidr(a_string)
		else
			return '$' + splited_string[0].strip + '/' + netmask_to_cidr(splited_string[1]).to_s
		end
	end
	
	def ios_addr_translate(a_string)
		
		if a_string == 'any'
			return 'any'
		elsif a_string.include?('host')
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
		elsif splited_string[0].include?('gt')
			return splited_string[1] + ':' + '65535'
		end
	end
	
	def pix_port_translate(a_string)
		splited_string = a_string.split(' ')
		if splited_string[0].include?('object-group')
			return '$' + a_string.gsub('object-group', '').strip.chomp.gsub('-','_')
		elsif splited_string[0].include?('group-object')
			return '$' + a_string.gsub('group-object', '').strip.chomp.gsub('-','_')
		elsif splited_string[0].include?('range')
			return splited_string[1] + ':' + splited_string[2]
		elsif splited_string[0].include?('eq')
			return splited_string[1]
		elsif splited_string[0].include?('gt')
			return splited_string[1] + ':' + '65535'
		end
	end	
	
	def icmp_translate(a_string)
		return @icmp_table[a_string]	
	end
end
