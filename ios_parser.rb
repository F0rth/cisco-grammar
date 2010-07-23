require "rubygems"
require "treetop"


#module IosInstructionParser


dir = File.dirname(__FILE__)
Treetop.load dir + "/parser/ios"
#module IOS
#	include IP
#end
#require dir + '/ios'


parser = IosParser.new
input2 = IO.readlines(ARGV[0]).to_s
#puts input2
#input = "ip route 195.220.94.0 255.255.255.0 195.220.94.33         ! aaaa"
#puts input == input2
result = parser.parse(input2)
 if parser.failure_reason
	puts parser.failure_reason
 end

values = Hash.new
#result.singleton_methods.each {|method| puts  "#{method}: #{result.send(method).text_value}"}

result.singleton_methods.each {|method| 
	begin
	value = {method => result.send(method).text_value} 
	values.update(value)
	end
	}

p values
