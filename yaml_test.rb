require 'yaml'
require 'pp'
require 'strscan'

file = File.open('token.yaml')
yaml_obj = YAML.load(file)

yaml_obj.each { |instruction| p instruction}


a = IO.readlines("cs7204-gw-confg")


tableau_token = 


# trouver les tokens





tableau = Array.new


a.each_index {|index| 
	scan = StringScanner.new(a[index])
	if scan.scan(/interface Ethernet3\/4/) == "interface Ethernet3/4"
		 p tableau
		 tableau = a[index].chomp.lstrip.to_a
		 p tableau
		 #p a[index]
		 index +=1
		 scan = StringScanner.new(a[index])
		 until scan.scan(/interface/) == "interface"		
		  tableau = tableau + a[index].chomp.lstrip.to_a
		#p index		
		#p a[index]
		  index +=1
		  scan = StringScanner.new(a[index])
		  
		 end
	 end   	
	

	# if  line.include? "interface" then
	#	p line
	#end */
}

 File.open( 'sortie.yaml', 'w' ) do |out|
 YAML.dump(tableau.to_yaml, out)
 end
