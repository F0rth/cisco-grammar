require 'ipaddr'
require 'rpatricia'

class Router

	attr_accessor :interfaces, :routing_table, :decision_tree
	
	def initialize
		@decision_tree = Patricia.new
		
		@interfaces.each {|interface|
			add_interface(interface)
			}
			
		
	end
	
	def add_interface(interface)
		@decision_tree.add(interface.ip_address, interface.name)
	end
	
#	def load_routing_table(routing_table)
#		pt = Patricia.new
#		routing_table.each{|route|
#			pt.add(route.
		
		
	end
	
	def process_packet(packet)
		if node = @decision_tree.search_best(packet.ip_dst)
		else {
			pt = Patricia.new
				routing_table.each{|route|
					pt.add(route.ip_src, route.ip_dst)
					
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
