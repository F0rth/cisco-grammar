require "rubygems"
require "rufus/tokyo"
 
t = Rufus::Tokyo::Table.new('table.tdb')
 
# populate table with arbitrary data (no schema!)
t['pk0'] = { 'name' => 'alfred', 'age' => '22', 'sex' => 'male' }
t['pk1'] = { 'name' => 'bob', 'age' => '18' }
t['pk2'] = { 'name' => 'charly', 'age' => '45', 'nickname' => 'charlie' }
t['pk3'] = { 'name' => 'doug', 'age' => '77' }
t['pk4'] = { 'name' => 'ephrem', 'age' => '32' }
 
# query table for age >= 32
p t.query { |q|
  q.add_condition 'age', :numge, '32'
  q.order_by 'age'
}
 
# => [ {"name"=>"ephrem", :pk=>"pk4", "age"=>"32"},
#      {"name"=>"charly", :pk=>"pk2", "nickname"=>"charlie", "age"=>"45"},
#      {"name"=>"doug", :pk=>"pk3", "age"=>"77"} ]
 
t.close

