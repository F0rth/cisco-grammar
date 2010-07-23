# encoding: ISO8859-15

require 'yaml'
require 'pp'
require 'strscan'

class Token
	

		@input_ios		# IOS config	
		@token_name		# single instruction found in token.yaml
		@token_regexp	# single instruction turned into a regexp
		@token_array	# 
		@conf_array		# IOS file into an array
		@instruction	# single instruction 
		@instructions_list	# list of a instructions found in @conf_array
		@output_array	# global output
		@instruction_regexp	# an instruction turned into a regexp
	
	def initialize
		@input_ios = ARGV[0]
		@token_name = String.new
		@token_array = Array.new
		@conf_array = Array.new
		@conf_array = IO.readlines(@input_ios, :encoding => 'ISO8859-15')
		@instructions_list = Array.new
		
	end

	def find_sub_instructions
	tableau = Array.new
	
	@token_regexp = Regexp.new(@token_name)
	
	@conf_array.each_index {|index| 
		@instruction_regexp = Regexp.new(@conf_array[index])
		scan = StringScanner.new(@conf_array[index])	
		if scan.scan(@instruction_regexp) == @token_name
			tableau = @conf_array[index].chomp.lstrip.to_a
			index +=1
			scan = StringScanner.new(@conf_array[index])
			until scan.scan(@token_regexp) == @token_name		
				tableau = tableau + @conf_array[index].chomp.lstrip.to_a
				index +=1
				scan = StringScanner.new(@conf_array[index])
			end
		end
		
		@output_array = @token_name.to_a + tableau
		}
	end 	


	def find_instructions_list
		file = File.open('token.yaml', 'rb')
		wanted_instructions = YAML.load(file)
		
		wanted_instructions.each_index { |wanted_index|
		tableau= Array.new
			wanted_instruction_regexp = Regexp.new(wanted_instructions[wanted_index].chomp.lstrip)
			@conf_array.each_index {|index|
			scan = StringScanner.new(@conf_array[index])
					#p @conf_array[index]
					#p wanted_instruction_regexp
					#p wanted_instructions[wanted_index]
				if scan.scan(wanted_instruction_regexp) == wanted_instructions[wanted_index].chomp.lstrip
				tableau = tableau + @conf_array[index].chomp.lstrip.lines.to_a
				index +=1
				scan = StringScanner.new(@conf_array[index])
				#p tableau
				p index
				end

			}
		@instructions_list = @instructions_list + wanted_instructions[wanted_index].lines.to_a +  tableau
		
		##pp @instructions_list
		
		}
	#pp @instructions_list.to_yaml
	File.open( 'sortie.yaml', 'w' ) do |out|
 YAML.dump(@instructions_list.to_yaml, out)
end
	end

	def total
	@instructions_list.each { |instruction|
	find_sub_instructions
	}
	#p @output_array
	end
	
end



test = Token.new
test.find_instructions_list 

#test.total


		

