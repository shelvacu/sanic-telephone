require 'sinatra'
require 'sqlite3'
require 'json'
require 'base64'
require 'active_record'
require 'sinatra/namespace'
require './models.rb'

CHARS = [*('A'..'Z'),*('a'..'z'),*('0'..'9')]

enable :sessions

set :public_folder, '../client'
set :session_secret, 'super duper secret thing that I sure hope no one will guess except of course people who look in the github repository but whatevs'


get '/' do
  redirect to("/index.html")
end

post '/' do
  r = Room.create!(url: params[:room_name])
  redirect to("/#{r.url}/")
end

get '/:room_id' do
  redirect to(request.url + "/")
end

get '/:room_id/' do
  puts "YAY"
  send_file File.expand_path('main.html', settings.public_folder)
end  

namespace '/:room_id' do
  before do
    @room = Room.find_by(url: params[:room_id])
    puts "room is nil" if @room.nil?
    halt 404 if @room.nil?
    if session[:user_id].nil? or User.find(session[:user_id]).nil?
      @user = @room.users.create!(
        username: 10.times.map{CHARS.sample}.join(''),
        last_contact: Time.now,
        ip_address: request.ip
      )
      session[:user_id] = @user.id
    else
      @user = User.find(session[:user_id])
    end
  end
  
  get '/poll' do
    if @room.drawing_user.nil?
      @user.events.create!(data: {img: Base64.encode64(File.read('sanic.png'))}.to_json)
      @room.drawing_user = @user
      @room.save!
    end

    event = @user.events.order(:id).first
    if event.nil?
      next {success: true, newevent: false}.to_json
    else
      event.destroy!
      next {success: true, newevent: true, ended: false}.transform_keys(&:to_s).merge(JSON::parse(event.data)).to_json
    end
  end

  post '/done_img' do
    #make sure user is the one that is drawing
    halt 403 unless @room.drawing_user = @user
    request.body.rewind
    data = JSON::parse request.body.read
    Image.create!(
      room: @room,
      user: @user,
      description: data["description"],
      order: Image.order(:order).last.try(:order) || 1,
      image_data: data["img"]
    )
    if not @user.next_user.nil?
      new_drawer = @user.next_user
      @room.drawing_user = new_drawer
      new_drawer.events.create!(data: data.to_json)
      @room.save!
    else
      @room.users.each do |user|
        user.events.create!(data: {img: data['img'], ended: true}.to_json)
      end
    end
    "{success: true}"
  end
end
