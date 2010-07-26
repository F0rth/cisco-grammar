require 'rubygems'
require 'parser'
require 'storage'


s = Storage.new('ios.tct')


z1 = Parser.new
z1.config = IO.readlines(ARGV[0])

@temp1 = Hash.new

## ACL

z1.token = "ip access-list extended"
z1.find_lines
z1.grammar = "ios_acl"
z1.load_grammar
z1.tokens_list.each_pair{|key,value|
	z1.token_instruction = value
	z1.find_token_instruction_subconf
	z1.token_instruction_subconf.each{|key,value|
		z1.use_grammar_on({key=>value})
		}
	}

z1.parsed_hashes.each_pair{|key, value|
	@temp1.update({'parent' => z1.parents_hash[key]})
	@temp1.update({'index' => key})
	value.each_pair{|key2, value2|
		@temp1.update({key2 => value2})
		}
	@temp1.update({'type' => 'acl'})
	@temp1.update({'time' => Time.now.to_i})
	@temp1.update({'file' => ARGV[0]})
	@temp1.update({'equipment' => 'cisco'})
	s.add(@temp1)
	}

z1.parsed_hashes.each_pair{|key, value|
	if value.empty?
		pp key.to_s + ' ' + z1.token_instruction_subconf[key]
	end
	}
