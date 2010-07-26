require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator

### ACL CISCO ### 
s = Storage.new('ios.tct')

ios_acl = s.db.query { |q|
#			q.add_condition 'proto', :equals, 'icmp'
			q.order_by 'index'
			}
s.db.close

@interfaces = Hash.new
@interfaces.update({'IPV4POINT6_IN' => 'in quick on $IPV4POINT6'})
@interfaces.update({'IPV4POINT6_OUT' => 'out quick on $IPV4POINT6'})
@interfaces.update({'PUBLIC_CRU_OUT' => 'out quick on $PUBLIC_CRU'})
@interfaces.update({'PUBLIC_UR1_OUT' => 'out quick on $PUBLIC_UR1'})
@interfaces.update({'RENATER_IN' => 'in quick on $RENATER'})
@interfaces.update({'RENATER_OUT' => 'out quick on $RENATER'})
@interfaces.update({'VISIO_IN' => 'in quick on $VISIO'})
@interfaces.update({'VISIO_OUT' => 'out quick on $VISIO'})

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

@pf_conf = Array.new

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
	#pp pf
}


### FIN CISCO ACL ###


## PIX NAMES ###
pix_names = s.db.query { |q|
			q.add_condition 'type', :equals, 'name'
			q.order_by 'index'
			}


pix_names.each{|name|
	pf = '$' + name['alias'].gsub('-','_') + ' = ' + name['ip_address']
	pp pf
}

### PIX SERVICES ###

# on récupère la liste des services 
pix_services = s.db.query { |q|
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

pf = '$' + service_name.split(' ')[2].gsub('-','_') + " = '{"

service_children = s.db.query { |q|
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
pp pf
}

### PIX NETWORK ###

# on récupère la liste des type network
pix_networks = s.db.query { |q|
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

pf = '$' + network_name.split(' ')[2].gsub('-','_') + " = '{"

network_children = s.db.query { |q|
			q.add_condition 'type', :equals, 'network'
			q.add_condition 'parent', :equals, network_name
			q.order_by 'index'
			}

network_children.each{|child|
	pp child['network_object']
	pf += pix_addr_translate(child['network_object'].gsub('port-object ',''))
	if network_children.index(child) < (network_children.length)-1
		pf += ', '
	end
	}
	pf += "}'"
pp pf
}

### PIX ACL ###


