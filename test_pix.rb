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








			
s.db.close
