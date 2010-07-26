require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator

s = Storage.new('pix.tct')



pix_acl = s.db.query { |q|
			q.add_condition 'type', :equals, 'acl'
			q.order_by 'index'
			}


@interfaces = Hash.new
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
	#pp pf
}


			
s.db.close
