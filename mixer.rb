#!/usr/bin/env ruby -KU

require "rubygems"
require "oklahoma_mixer"

OklahomaMixer.open("data.tch") do |db|
  if db.size.zero?
    puts "Loading the database.  Rerun to read back the data."
    db[:one] = 1
    db[:two] = 2
    db.update(:three => 3, :four => 4)
    db["users:1"] = "James"
    db["users:2"] = "Ruby"
  else
    puts "Reading data."
    %w[ db[:one]
        db["users:2"]
        -
        db.keys
        db.keys(:prefix\ =>\ "users:")
        db.keys(:limit\ =>\ 2)
        db.values
        -
        db.values_at(:one,\ :two) ].each do |command|
      puts(command == "-" ? "" : "#{command} = %p" % [eval(command)])
    end
  end
end
