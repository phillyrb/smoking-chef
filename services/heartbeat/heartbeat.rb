require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'json'

$db = SQLite3::Database.new 'heartbeat.db'

at_exit { $db.close }

get '/' do

  @rows = $db.execute("select ip, gem from heartbeat").map { |row| { :ip => row[0], :gem => row[1] } }

  erb :index
end

get '/heartbeat' do
  if $db.execute("select * from heartbeat where ip = ?", request.ip).empty?
    $db.execute("insert into heartbeat (ip, gem) values (?, ?)", request.ip, params[:next])
  else
    $db.execute("update heartbeat set gem = ? where ip = ?", params[:next], request.ip)
  end

  return [ request.ip, params[:next] ].to_json
end
