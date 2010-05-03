require 'ipaddr'
require 'rpatricia'

class Router

	attr_accessor :interfaces, :routing_table, :decision_tree
	
	def initialize(interfaces, routing_table)
		@interfaces = interface
		@routing_table = routing_table
		@decision_tree = Patricia.new
		
		@interfaces.each {|interface|
			add_interface(interface)
			}
		load_routing_table
	end
	
	def add_outgoing_interface(ip_src, interface_name)
		@decision_tree.add(ip_src, interface_name)
	end
	
	def add_interface(interface)
		add_outgoing_interface(interface.ip_address, interface.name)
	end
	
	def load_routing_table(routing_table)
		routing_table.each{|route|
		interface_name = process_packet(route.ip_dst)
		add_outgoing_interface(route.ip_src, interface_name)
		}
		
	end
	
	def process_packet(packet)
		if node = @decision_tree.search_best(packet.ip_dst)
		return node.data
	end
end

class Interface
	attr_accessor :name, :ip_address, :acl
end


class Acl
	attr_accessor :action, :packet
end

class RoutingTable
	attr_accessor :routes
end

class Route
	attr_accessor :ip_src, :ip_dst
end

class Packet
	attr_accessor :protocol, :ip_src, :prt_dst, :ip_dst, :prt_src
end
