# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'

post '/memos' do
  id = SecureRandom.uuid
  @title = params['title'].to_s
  @content = params['content'].to_s
  make_data(id, @title, @content)
  redirect '/memos'
end

get '/memos' do
  @memos = []
  Dir.glob('*', base: 'memos').sort_by { |f| File.mtime("memos/#{f}") }.each do |id|
    @memos << use_data(id)
  end
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do |id|
  hash = use_data(id)
  @id = id.to_s
  @title = hash[:title]
  @content = hash[:content]
  erb :edit
end

get '/memos/:id' do |id|
  hash = use_data(id)
  @id = id.to_s
  @title = hash[:title]
  @content = hash[:content]
  erb :memo
end

delete '/memos/:id' do |id|
  File.delete("memos/#{id}")
  redirect '/memos'
end

patch '/memos/:id' do |id|
  @title = params['title'].to_s
  @content = params['content'].to_s
  make_data(id, @title, @content)
  redirect '/memos'
end

def make_data(id, title, content)
  memo_data = { id: id, title: title, content: content }
  json_memo_data = JSON.dump(memo_data)
  to_file(json_memo_data, id)
end

def to_file(memo_data, id)
  File.open("memos/#{id}", 'w') do |f|
    f.puts(memo_data)
  end
end

def use_data(id)
  p a = File.read("memos/#{id}")
  JSON.parse(a, symbolize_names: true)
end

# def puts_memos_list
#     Dir.glob("*", base:"memos")
#     end
