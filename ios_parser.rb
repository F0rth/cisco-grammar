require "rubygems"
require "treetop"
require "pp"


Treetop.load "ios_acl"
parser = Ios_aclParser.new
input = "deny   tcp any eq 2967 any"

result = parser.parse(input)
 if parser.failure_reason
	puts parser.failure_reason
 end

values = Hash.new
result.singleton_methods.each {|method| 
	begin
	value = {method => result.send(method).text_value} 
	values.update(value)
	end
	}

pp values
