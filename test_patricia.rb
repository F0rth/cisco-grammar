  require 'rpatricia'
  pt = Patricia.new
  pt.add("192.168.1.0/24")
  pt.add("127.0.0.0/8", "user_data")
  node = pt.search_best("127.0.0.1")
  puts node.data
  puts node.prefix
  puts node.network
  puts node.prefixlen
  pt.remove("127.0.0.0/8")
  puts pt.num_nodes
  pt.show_nodes
  pt.clear
