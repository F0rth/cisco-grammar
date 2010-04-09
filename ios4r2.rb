require 'strscan'
require 'yaml'
require 'pp'
require 'rubygems'
require 'treetop'

class Parser

	attr_accessor :config, :token, :tokens_list, :parsed_hashes, :token_instruction, :token_instruction_subconf
	
	
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
					
	
	def parse_lines
		dir = File.dirname(__FILE__)
		
		if @token.include? " "
			grammar = @token.gsub(/ /,'_')
		else
			grammar = @token
		end

		Treetop.load dir + "/parser/" + grammar
		parsername = grammar.capitalize + "Parser"
		parser = Object.module_eval("::#{parsername}").new

		@tokens_list.each {|line|
		result = parser.parse(line)

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

end

z = Parser.new
z.token = "ip access-list extended"
z.find_lines
pp z.tokens_list
z.token_instruction = z.tokens_list[2]
p z.token_instruction
z.find_token_instruction_subconf
pp z.token_instruction_subconf
z.parse_lines
pp z.parsed_hashes
