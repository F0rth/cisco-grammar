require 'rubygems'
require 'parser'
require 'storage'



s = Storage.new('pix.tct')

z1 = Parser.new
z1.config = IO.readlines(ARGV[0])

z2 = Parser.new
z2.config = IO.readlines(ARGV[0])

z3 = Parser.new
z3.config = IO.readlines(ARGV[0])

z4 = Parser.new
z4.config = IO.readlines(ARGV[0])

@temp1 = Hash.new
@temp2 = Hash.new
@temp3 = Hash.new
@temp4 = Hash.new


## ACL
z1.token = "access-list"
z1.find_lines
z1.grammar = "pix_acl"
z1.load_grammar
z1.use_grammar_on(z1.tokens_list)



z1.parsed_hashes.each_pair{|key, value|
	@temp1.update({"index" => key})
	value.each_pair{|key2, value2|
		@temp1.update({key2 => value2})
		}
	@temp1.update({'type' => 'acl'})
	@temp1.update({'time' => Time.now.to_i})
	@temp1.update({'file' => ARGV[0]})
	@temp1.update({'equipment' => 'pix'})
	s.add(@temp1)
	}


z1.parsed_hashes.each_pair{|key, value|
	if value.empty? and not z1.tokens_list[key].include? "remark"
		pp key.to_s + ' ' + z1.tokens_list[key]
	end
}


## Service



z2.token = "object-group service"
z2.find_lines
z2.grammar = "pix_object_group_service"
z2.load_grammar
z2.tokens_list.each_pair{|key,value|
	z2.token_instruction = value
	z2.find_token_instruction_subconf
	z2.token_instruction_subconf.each{|key,value|
		z2.use_grammar_on({key=>value})
		}
	}

z2.parsed_hashes.each_pair{|key, value|
	@temp2.update({"parent" => value})
	@temp2.update({"index" => key})
	value.each_pair{|key2, value2|
		@temp2.update({key2 => value2})
		}
	@temp2.update({'type' => 'service'})
	@temp2.update({'time' => Time.now.to_i})
	@temp2.update({'file' => ARGV[0]})
	@temp2.update({'equipment' => 'pix'})
	s.add(@temp2)
	}

z2.parsed_hashes.each_pair{|key, value|
	if value.empty? and not z2.token_instruction_subconf[key].include? "description"
		pp key.to_s + ' ' + z2.token_instruction_subconf[key]
	end
	}

## Network





z3.token = "object-group netwwork"
z3.find_lines
z3.grammar = "pix_object_group_network"
z3.load_grammar
z3.tokens_list.each_pair{|key,value|
	z3.token_instruction = value
	z3.find_token_instruction_subconf
	z3.token_instruction_subconf.each{|key,value|
		z3.use_grammar_on({key=>value})
		}
	}

z3.parsed_hashes.each_pair{|key, value|
	@temp3.update({"parent" => value})
	@temp3.update({"index" => key})
	value.each_pair{|key2, value2|
		@temp3.update({key2 => value2})
		}
	@temp3.update({'type' => 'network'})
	@temp3.update({'time' => Time.now.to_i})
	@temp3.update({'file' => ARGV[0]})
	@temp3.update({'equipment' => 'pix'})
	s.add(@temp3)
	}

z3.parsed_hashes.each_pair{|key, value|
	if value.empty? and not z3.token_instruction_subconf[key].include? "names"
		pp key.to_s + ' ' + z3.token_instruction_subconf[key]
	end
	}

## Name

z4.token = "name"
z4.find_lines
z4.grammar = "pix_name"
z4.load_grammar
z4.use_grammar_on(z4.tokens_list)



z4.parsed_hashes.each_pair{|key, value|
	@temp4.update({"index" => key})
	value.each_pair{|key2, value2|
		@temp4.update({key2 => value2})
		}
	@temp4.update({'type' => 'name'})
	@temp4.update({'time' => Time.now.to_i})
	@temp4.update({'file' => ARGV[0]})
	@temp4.update({'equipment' => 'pix'})
	s.add(@temp4)
	}


z4.parsed_hashes.each_pair{|key, value|
	if value.empty? 
		pp key.to_s + ' ' + z4.tokens_list[key] and not z4.token_instruction_subconf[key].include? "names"
	end
}

## Fin

s.db.close
