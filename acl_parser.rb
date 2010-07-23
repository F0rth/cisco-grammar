require "rubygems"
require "treetop"
require "pp"

#module IosInstructionParser


#dir = File.dirname(__FILE__)
Treetop.load "ios_acl"
#module IOS
#	include IP
#end
#require dir + '/ios'


parser = Ios_aclParser.new
#input2 = IO.readlines(ARGV[0]).to_s
#puts input2
input = " deny   tcp 165.193.0.0 0.0.255.255 host 195.220.94.169 eq www\r\n"
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
