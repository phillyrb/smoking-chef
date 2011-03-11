require 'rubygems'
require 'sqlite3'

SQL = [ 
  %q[create table heartbeat (ip varchar primary key, gem varchar)]
]

db = SQLite3::Database.new 'heartbeat.db'

SQL.each do |sql|
  db.execute(sql)
end

db.close
