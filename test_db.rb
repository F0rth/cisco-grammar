require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator



s_pix = Storage.new('pix.tct')

pix_names = s_pix.db.query { |q|
			q.add_condition 'destination_port', :strinc, 'log'
			q.order_by 'index'
			}


pp pix_names


pix_names = s_pix.db.query { |q|
			q.add_condition 'index', :equals, '2011'
			q.order_by 'index'
			}


pp pix_names


s_pix.db.close

s_ios = Storage.new('ios.tct')

ios_test = s_ios.db.query { |q|
			q.add_condition 'destination_port', :strinc, 'log'
			q.order_by 'index'
			}

pp ios_test

ios_test = s_ios.db.query { |q|
			q.add_condition 'index', :equals, '832'
			q.order_by 'index'
			}	
			
pp ios_test			


ios_test = s_ios.db.query { |q|
			q.add_condition 'log', :strinc, 'log'
			q.order_by 'index'
			}	
			
pp ios_test	


s_ios.db.close




