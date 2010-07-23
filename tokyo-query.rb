require 'storage'


s = Storage.new('ios.tct')

  pp s.db.query { |q|
   q.add_condition 'type', :equals, 'acl'
    q.order_by 'destination_ip'
}
s.db.close
