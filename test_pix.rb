require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator

s = Storage.new('pix.tct')

## PIX NAMES ###
#pix_names = s.db.query { |q|
#			q.add_condition 'type', :equals, 'name'
#			q.order_by 'index'
#			}


#pix_names.each{|name|
#	pf = '$' + name['alias'].gsub('-','_') + ' = ' + name['ip_address']
#	pp pf
#}

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





			
s.db.close
