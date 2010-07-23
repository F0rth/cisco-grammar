require 'rufus/tokyo'
class Storage
	
	attr_accessor :db
	
	def initialize(db_file)
		if File::exist?(db_file)
			@db = Rufus::Tokyo::Table.open(db_file)
		else
			@db = Rufus::Tokyo::Table.new(db_file)
		end
	end
	
	def add(hash_data)
		# genuid génère un identiant unique
		@db[@db.genuid] = hash_data
	end
		
end
