require 'rubygems'
require 'parser'
require 'storage'



#s = Storage.new('pix.tct')

z = Parser.new
z.token = "access-list"
z.find_lines
#pp z.tokens_list[1701]
#z.tokens_list.each{|token|
#z.token_instruction = token
#z.token_instruction = z.tokens_list[1]
#p z.token_instruction
#z.find_token_instruction_subconf
#pp z.token_instruction_subconf
#z.find_grammar
z.grammar = "pix_acl"
z.load_grammar
z.use_grammar_on(z.tokens_list)
#z.use_grammar_on({1899 => z.tokens_list[1899]})
#z.grammar = "pix_acl"
#z.load_grammar
#z.token_instruction = z.tokens_list[4]
#p z.token_instruction_subconf
#z.use_grammar_on(z.token_instruction_subconf) 
#z.grammar_fail
#pp z.parsed_hashes
z.parsed_hashes.each_pair{|key, value|
#	if value.empty? and !z.tokens_list[key].include? "remark"
	if value.empty? 
		pp key.to_s + ' ' + z.tokens_list[key]
	end
}



#@temp1 = Hash.new

#z.parsed_hashes.each_pair{|key, value|
#	@temp1.update({"index" => key})
#	value.each_pair{|key2, value2|
#		@temp1.update({key2 => value2})
#		}
#		@temp1.update({'parent' => z.token_instruction})
#		@temp1.update({'type' => 'acl'})
#		@temp1.update({'time' => Time.now.to_i})
#		@temp1.update({'file' => ARGV[0]})
#	s.add(@temp1)
#	}



#}
#  pp s.db.query { |q|
#   q.add_condition 'type', :equals, 'acl'
#    q.order_by 'destination_ip'
#}
#s.db.close


