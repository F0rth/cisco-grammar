require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator

file = File.new('pf_de_test.conf', 'w')
s_ios = Storage.new('ios.tct')
s_pix = Storage.new('pix.tct')

t1 = PixTranslator.new
t2 = CiscoTranslator.new




s_ios.db.close
s_pix.db.close
file.close


@interfaces = Hash.new
### CISCO
@interfaces.update({'IPV4POINT6_IN' => 'in quick on $IPV4POINT6'})
@interfaces.update({'IPV4POINT6_OUT' => 'out quick on $IPV4POINT6'})
@interfaces.update({'PUBLIC_CRU_OUT' => 'out quick on $PUBLIC_CRU'})
@interfaces.update({'PUBLIC_UR1_OUT' => 'out quick on $PUBLIC_UR1'})
@interfaces.update({'RENATER_IN' => 'in quick on $RENATER'})
@interfaces.update({'RENATER_OUT' => 'out quick on $RENATER'})
@interfaces.update({'VISIO_IN' => 'in quick on $VISIO'})
@interfaces.update({'VISIO_OUT' => 'out quick on $VISIO'})
### PIX
@interfaces.update({"DMZ-PIX_access_in" => "in quick on $DMZ-PIX"})
@interfaces.update({"FO-PIX_access_in" => "in quick on $FO-PIX"})
@interfaces.update({"captacl" => "quick on $CAPTACL"})
@interfaces.update({"http-mss-list1" => "quick on $HTTP-MSS-LIST1"})
@interfaces.update({"inside_access_in" => "in quick on $INTERNE"})
@interfaces.update({"outside_acl_in" => "out quick on $INTERNE"})


@action = Hash.new
@action.update({'permit' => 'pass'})
@action.update({'deny' => 'block'})

@icmp_table = Hash.new
@icmp_table.update({'echo-reply' =>'icmp-type echorep'})
@icmp_table.update({'echo' =>'icmp-type echoreq'})
@icmp_table.update({'time-exceeded' =>'icmp-type timex'})
@icmp_table.update({'packet-too-big' =>'icmp-type redir code needfrag'})
@icmp_table.update({'traceroute' =>'icmp-type trace'})
@icmp_table.update({'unreachable' =>'icmp-type echorep code net-unr'})


#@prototype.update({'tcp' =>
#@prototype.update({'udp' 
#@prototype.update({'esp'
#@prototype.update({'ip'
#@prototype.update({'icmp'
##@prototype.update({'igmp'
#@prototype.update({'any'





class PixTranslator
attr_accessor :s_pix, :pf_output

def names
## PIX NAMES ###
pix_names = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'name'
			q.order_by 'index'
			}


pix_names.each{|name|
	pf = name['alias'].gsub('-','_').chomp + ' = ' + name['ip_address'].chomp
	@file.puts pf
}

end

def services

### PIX SERVICES ###

# on récupère la liste des services 
pix_services = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'service'
			q.order_by 'index'
			}

@services_array = Array.new
 pix_services.each{|service|
@services_array += service.select{|k, v|
	k == 'parent'
	}
}
@services_array.flatten!.delete("parent")

## traitements

@services_array.uniq.each{|service_name|

pf = service_name.split(' ')[2].gsub('-','_') + " = '{"

service_children = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'service'
			q.add_condition 'parent', :equals, service_name
			q.order_by 'index'
			}
service_children.each{|child|
	pf += pix_port_translate(child['service_object'].gsub('port-object ',''))
	if service_children.index(child) < (service_children.length)-1
		pf += ', '
	end
	}
	pf += "}'"
@file.puts pf
}

end

def networks

### PIX NETWORKS ###

# on récupère la liste des type network
pix_networks = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'network'
			q.order_by 'index'
			}

@networks_array = Array.new
 pix_networks.each{|network|
@networks_array += network.select{|k, v|
	k == 'parent'
	}
}
@networks_array.flatten!.delete("parent")

## traitements

@networks_array.uniq.each{|network_name|

pf = network_name.split(' ')[2].gsub('-','_') + " = '{"

network_children = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'network'
			q.add_condition 'parent', :equals, network_name
			q.order_by 'index'
			}

network_children.each{|child|
	#pp child['network_object']
	pf += pix_addr_translate(child['network_object'].gsub('port-object ',''))
	if network_children.index(child) < (network_children.length)-1
		pf += ', '
	end
	}
	pf += "}'"
@file.puts pf
}

end


def acl

### PIX ACL ###
pix_acl = @s_pix.db.query { |q|
			q.add_condition 'type', :equals, 'acl'
			q.order_by 'index'
			}
			
pix_acl.each{|acl|
	
	pf = @action[acl['action']] + ' ' + @interfaces[acl['acl_name']]
	
	if acl['proto'] != 'ip'
		pf += ' ' + 'proto'  + ' ' + acl['proto']
	end
	
	pf += ' ' + 'from' + ' ' + pix_addr_translate(acl['source_ip'])
	
	if acl['source_port'] != ""
		pf += ' ' + 'port' +  ' ' + pix_port_translate(acl['source_port'])
	end
	
	pf += ' ' + 'to' + ' ' + pix_addr_translate(acl['destination_ip'])
	

	
	
	if acl['destination_port'] == "ack"
		pf += ' ' + 'port' + ' ' + 'ack'
	
	elsif acl['proto'] == "icmp" and acl['destination_port'] != ""
		pf +=  ' ' + @icmp_table[acl['destination_port']]
	elsif  acl['destination_port'] != "" and acl['destination_port'] != "log"
		pf += ' ' + 'port' + ' ' + pix_port_translate(acl['destination_port'])
	end
	
	# debug de la traduction
	#pp acl
	@file.puts pf
}
end

end

class CiscoTranslator

def acl

### ACL CISCO ### 
ios_acl = @s_ios.db.query { |q|
			q.order_by 'index'
			}

ios_acl.each{|acl|
	
	pf = @action[acl['action']] + ' ' + @interfaces[acl['parent'].split(' ')[3]]
	
	if acl['proto'] != 'ip'
		pf += ' ' + 'proto'  + ' ' + acl['proto']
	end
	
	pf += ' ' + 'from' + ' ' + ios_addr_translate(acl['source_ip'])
	
	if acl['source_port'] != ""
		pf += ' ' + 'port' +  ' ' + ios_port_translate(acl['source_port'])
	end
	
	pf += ' ' + 'to' + ' ' + ios_addr_translate(acl['destination_ip'])
	

	
	
	if acl['destination_port'] == "ack"
		pf += ' ' + 'port' + ' ' + 'ack'
	
	elsif acl['proto'] == "icmp" and acl['destination_port'] != ""
		pf +=  ' ' + @icmp_table[acl['destination_port']]
	elsif  acl['destination_port'] != "" and acl['destination_port'] != "log"
		pf += ' ' + 'port' + ' ' + ios_port_translate(acl['destination_port'])
	end
	
	# debug de la traduction
	#pp acl
	@file.puts pf
}


### FIN CISCO ACL ###

end
end



