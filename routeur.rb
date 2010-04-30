
class Router

	attr_accessor :interfaces, :routing_table

end

class Interface
	attr_accessor :name, :ip_address, :acl
end


class Acl
	attr_accessor :action, :protocol, :ip_src, :prt_src, :ip_dst, :prt_dst
end

class RoutingTable
	attr_accessor :routes

end

class Route
	attr_accessor :ip_src, :ip_dst
end

class IpAdress
	attr_acessor :version, :address, :netmask
end
