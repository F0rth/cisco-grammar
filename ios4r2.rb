require 'strscan'
require 'yaml'
require 'pp'
require 'rubygems'
require 'treetop'

class Parser

	attr_accessor :config, :token, :tokens_list, :parsed_hashes
	
	
	def initialize
	@config = IO.readlines(ARGV[0])
	@tokens_list = Array.new
	@parsed_hashes = Array.new
	
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
z.token = "ip route"
z.find_lines
pp z.tokens_list
#z.parse_lines
#pp z.parsed_hashes
