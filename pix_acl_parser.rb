require "treetop"
require "polyglot"
require "pp"

#module IosInstructionParser


#dir = File.dirname(__FILE__)
Treetop.load "pix_acl"
#module IOS
#	include IP
#end
#require dir + '/ios'


parser = Pix_aclParser.new
#input2 = IO.readlines(ARGV[0]).to_s
#puts input2
input = "access-list outside_acl_in extended permit tcp object-group M-DYNIX object-group M-HIP \n"
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


