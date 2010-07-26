require 'rubygems'
require 'storage'
require 'pp'

s = Storage.new('ios.tct')

ios_acl = s.db.query { |q|
			q.add_condition 'proto', :equals, 'icmp'
			q.order_by 'index'
			}
s.db.close

pp ios_acl
