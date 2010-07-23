require 'strscan'
require 'pp'
require 'yaml'
class Adapter
   def initialize( row )
	   @row = row
   end
   def method_missing( sym, *args )
	   name = sym.to_s.sub(/=$/, '')
	   super unless @row.key?( name )
	   if /=$/ =~ sym.to_s
		   return @row[ name ] = args[0]
	   else
		   return @row[ name ]
	   end
   end
end

ad = Adapter::new( 'firstname' => 'Roger',
				   'lastname' => 'Pollack',
				   'nick' => '(unknown)' )
#p "%s, %s: %s" % [ ad.lastname, ad.firstname, ad.nick ]

a = IO.readlines("cs7204-gw-confg")


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
