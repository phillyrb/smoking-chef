require 'rubygems'
require 'sqlite3'
require 'fileutils'

SQL = [ 
  %q[create table heartbeat (ip varchar primary key, gem varchar, running boolean)]
]

FileUtils.rm_f 'heartbeat.db'
db = SQLite3::Database.new 'heartbeat.db'

SQL.each do |sql|
  db.execute(sql)
end

db.close
