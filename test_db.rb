require 'rubygems'
require 'storage'
require 'pp'
require 'translator'
include Translator



s_pix = Storage.new('pix.tct')

pix_names = s_pix.db.query { |q|
			q.add_condition 'index', :equals, '2024'
			q.order_by 'index'
			}

s_pix.db.close

pp pix_names
