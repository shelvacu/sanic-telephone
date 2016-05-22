require 'sinatra'
require 'json'
require 'base64'

enable :sessions

$myid = rand(10000)
$id = rand(10000)

$waiting = [] #who is in line for drawing
$drawing = nil #who is drawing
$done = [] #who is done drawing waiting for end

$events = {}

set :public_folder, '../client'

before do
  if session[:myid].nil?
    session[:myid] = $myid
  else
    if session[:myid] != $myid
      session[:myid] = $myid
      reset = true
    end
  end
  if session[:id].nil? || reset
    session[:id] = ($id += 1)
    $waiting << session[:id]
  end
  @id = session[:id]
end  

get '/' do
  $waiting << @id
  redirect to '/index.html'
end

get '/poll' do
  $events[@id] ||= []
  if $drawing.nil?
    $events[@id] << {img: Base64.encode64(File.read('sanic.png'))}
    $drawing = @id
    $waiting.delete(@id)
  end
  event = $events[@id].shift
  puts event.inspect
  if event.nil?
    next {success: true, newevent: false}.to_json
  else
    next {success: true, newevent: true, ended: false}.merge(event).to_json
  end
end

post '/done_img' do
  request.body.rewind
  data = JSON::parse request.body.read
  puts "WAITING LENGTH IS #{$waiting.length}"
  if $waiting.length > 0
    new_drawer = $waiting.shift
    $drawing = new_drawer
    $done << @id
    $events[$drawing] << data
  else
    $done.each do |ip|
      $events[ip] << {img: data['img'], ended: true}
    end
  end
end
