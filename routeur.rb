require 'ipaddr'
require 'ipaddr_extensions'
require 'rpatricia'

class Router

	attr_accessor :interfaces, :routing_table, :decision_tree
	
	def initialize(interfaces, routing_table)
		@interfaces = interfaces
		@routing_table = routing_table
		@decision_tree = Patricia.new


		# directly connected routes
		@interfaces.each {|interface|
			add_interface(interface)
			}
		# static routing table
		load_routing_table
	end

	def add_interface(interface)
		interface.ip_addresses.each {|adress|
			add_table([adress, interface.name])
		}
	end
	
	def add_table(table)
		@decision_tree.add(table.first, table.last)
	end
	
	def load_routing_table
		@routing_table.each{|route|
				add_table([route.ip_src, route.ip_dst])
		}		
	end
	
	def process_packet(packet)
		# tant que l'on a une adresse ip en sortie, on cherche l'interface
		node = @decision_tree.search_best(packet.next_hop)
		begin
			while node.data.to_ip.is_a? IPAddr
				packet.next_hop = node.data
				node = @decision_tree.search_best(packet.next_hop)
				#process_packet(packet)
			end
		rescue
			packet.if_out = node.data
		end
		
	end
end

class Interface
	attr_accessor :name, :ip_addresses, :acl
end


class Acl
	attr_accessor :action, :predicat
end

class RoutingTable
	attr_accessor :routes
end

class Route
	attr_accessor :ip_src, :ip_dst
end

class Packet
	attr_accessor :predicat, :next_hop, :if_in, :if_out
	
	def initialize(predicat)
		@predicat = predicat
		if @next_hop.nil?
			@next_hop = @predicat.ip_dst
		end
	end
end

class Predicat
	attr_accessor :protocol, :ip_src, :prt_dst, :ip_dst, :prt_src
end


predi = Predicat.new
predi.ip_src = "192.168.1.5/32"
predi.ip_dst = "192.168.6.61/32"

pac = Packet.new(predi)

eth0 = Interface.new
eth1 = Interface.new

eth0.name = "eth0"
eth0.ip_addresses = ["192.168.6.254/24", "192.168.0.7/24"]

eth1.name = "eth1"
eth1.ip_addresses = ["192.168.6.4/24"]



route1 = Route.new
route2 = Route.new

route1.ip_src = "192.168.40.0/24"
route1.ip_dst = "192.168.6.28"

route2.ip_src = "192.168.9.0/24"
route2.ip_dst = "192.168.0.34"

rou = Router.new([eth0, eth1], [route2, route1])


# rou.decision_tree.show_nodes

rou.process_packet(pac)

p pac.if_out
p pac.next_hop
p rou.routing_table
p rou.decision_tree.show_nodes


