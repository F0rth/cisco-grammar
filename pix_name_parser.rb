require "treetop"
require "pp"

#module IosInstructionParser


#dir = File.dirname(__FILE__)
Treetop.load "pix_name"
#module IOS
#	include IP
#end
#require dir + '/ios'


parser = Pix_nameParser.new
#input2 = IO.readlines(ARGV[0]).to_s
#puts input2
input = "name 62.23.8.146 ipLexbase\r\n"
#puts input == input2
result = parser.parse(input)
 #if parser.failure_reason
	puts parser.failure_reason
 #end

values = Hash.new
pp result.singleton_methods

result.singleton_methods.each {|method| 
	begin
	value = {method => result.send(method).text_value} 
	values.update(value)
	end
	}

p values

