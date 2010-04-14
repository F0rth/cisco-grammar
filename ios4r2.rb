require 'strscan'
require 'yaml'
require 'pp'
require 'rubygems'
require 'treetop'

class Parser

	attr_accessor :config, :token, :tokens_list, :parsed_hashes, :token_instruction, :token_instruction_subconf, :index, :grammar
	@parser
	
	def initialize
	@config = IO.readlines(ARGV[0])
	@tokens_list = Array.new
	@parsed_hashes = Array.new
	@token_instruction_subconf = Array.new
	
	end
	
	def find_lines
		token_regexp = Regexp.new(@token)
		@config.each_index {|index|
			scan = StringScanner.new(@config[index])
			if scan.scan(token_regexp) == @token 
				@tokens_list << @config[index]
			end
		}
	end
	
	def find_token_instruction_subconf
			token_instruction_regexp = Regexp.new(@token_instruction)
			index = 1
			until index ==  @config.length do
			scan = StringScanner.new(@config[index])
				if scan.scan(token_instruction_regexp) == @token_instruction
					pointer = index
					until index == @config.length do					
						pointer +=1
							token_regexp = Regexp.new(@token)
							scan2 = StringScanner.new(@config[pointer])
							until scan2.scan(token_regexp) == @token do
							@token_instruction_subconf << @config[pointer]
							pointer += 1
							scan2 = StringScanner.new(@config[pointer])
							end
							break
					end
					index = pointer
				else
				index += 1
				end
			end
	end
					
	
	def load_grammar
		dir = File.dirname(__FILE__)
		Treetop.load dir  + "/" + grammar
		parsername = grammar.capitalize + "Parser"
		@parser = Object.module_eval("::#{parsername}").new
	end
	
	def use_grammar_on(an_array)
		an_array.each {|line|
		result = @parser.parse(line)
		values = Hash.new
		result.singleton_methods.each {|method| 
			begin
				value = {method => result.send(method).text_value} 
				values.update(value)
			end
		}
		@parsed_hashes << values
		}
	
	end
	
	def find_grammar
		if @token.include? " " or  @token.include? "-"
			# limitations de TreeTop
			@grammar = @token.gsub(/ /,'_').gsub(/-/,'_')
		else
			@grammar = @token
		end
	end
		

end

z = Parser.new
z.token = "ip access-list extended"
z.find_lines
z.token_instruction = z.tokens_list[2]
p z.token_instruction
z.find_token_instruction_subconf
pp z.token_instruction_subconf
#z.find_grammar
#z.load_grammar
#z.use_grammar_on(z.tokens_list[2])
z.grammar = "ios_acl"
z.load_grammar
p z.token_instruction_subconf[1]
z.use_grammar_on(z.token_instruction_subconf[1]) 
pp z.parsed_hashes


