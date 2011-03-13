require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'json'

$db = SQLite3::Database.new 'heartbeat.db'

at_exit { $db.close }

get '/' do
  @rows = $db.execute("select ip, gem, running from heartbeat").map do |row| 
    { :ip => row[0], :gem => row[1], :running => row[2] }
  end

  erb :index
end

get '/heartbeat' do
  if $db.execute("select * from heartbeat where ip = ?", request.ip).empty?
    $db.execute(
      "insert into heartbeat (ip, gem, boolean) values (?, ?)", 
      request.ip, 
      params[:next], 
      params.has_key?(:running) ? params[:running] : true
    )
  else
    $db.execute(
      "update heartbeat set gem = ? where ip = ?", 
      params[:next], 
      request.ip, 
      params.has_key?(:running) ? params[:running] : true
    )
  end

  return [ request.ip, params[:next], params[:running] ].to_json
end
