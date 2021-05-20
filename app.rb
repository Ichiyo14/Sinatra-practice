# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'
require 'erb'
require 'pg'

CONN = PG::Connection.open(dbname: 'memo_app')

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

post '/memos' do
  id = SecureRandom.uuid
  @title = params['title'].to_s
  @content = params['content'].to_s
  make_data(id, @title, @content)
  redirect '/memos'
end

get '/memos' do
  @memos = CONN.exec('SELECT * FROM memos').map { |memo_data| memo_data }.reverse
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do |id|
  hash = use_data(id)
  @id = h(id.to_s)
  @title = h(hash[0]['title'])
  @content = h(hash[0]['content'])
  erb :edit
end

get '/memos/:id' do |id|
  hash = use_data(id)
  @id = h(id.to_s)
  @title = h(hash[0]['title'])
  @content = h(hash[0]['content'])
  erb :memo
end

delete '/memos/:id' do |id|
  delete_data(id)
  redirect '/memos'
end

patch '/memos/:id' do |id|
  @title = params['title'].to_s
  @content = params['content'].to_s
  patch_data(id, @title, @content)
  redirect '/memos'
end

def make_data(id, title, content)
  CONN.exec('INSERT INTO memos VALUES($1, $2, $3);', [id, title, content])
end

def use_data(id)
  CONN.exec('SELECT * FROM memos WHERE id=$1;', [id])
end

def patch_data(id, title, content)
  CONN.exec('UPDATE memos SET title = $2 , content = $3 WHERE id = $1;', [id, title, content])
end

def delete_data(id)
  CONN.exec('DELETE FROM memos WHERE id = $1;', [id])
end
