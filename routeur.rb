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
		@decision_tree.add(interface.ip_address, interface.name)
	end
	
	def add_route(route)
		@decision_tree.add(route.ip_src, route.ip_dst)
	end
	
	def load_routing_table
		@routing_table.each{|route|
				add_route(route)
		}		
	end
	
	def process_packet(packet)
		# tant que l'on a une adresse ip en sortie, on cherche l'interface
		node = @routing_table.add(packet.ip_dst)
		begin
			while node.data.to_ip.is_a? IPAddr
				packet.predicat.ip_dst = node.data
				process_packet(packet) 
		rescue
			packet.next_hop = node.prefix
			return node
		end
		
	end
end

class Interface
	attr_accessor :name, :ip_address, :acl
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
	attr_accessor :predicat, :next_hop
end

class Predicat
	attr_accessor :protocol, :ip_src, :prt_dst, :ip_dst, :prt_src
end
