require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

post '/memos' do
    id = SecureRandom.uuid
    @title = "#{params['title']}"
    @content = "#{params['content']}"
    make_data(id, @title, @content)
    redirect '/memos'
end

get '/memos' do
    @memos = []
    Dir.glob("*", base:"memos").sort_by{|f| File.mtime("memos/#{f}")}.each do |id|
        @memos << use_data(id)
    end
    @memos
    erb :index
end

get '/memos/new' do
    erb :new
end

get '/memos/:id/edit' do |id|
    hash = use_data(id)
    @id = "#{id}"
    @title = hash[:title]
    @content = hash[:content]
    erb :edit
end

get '/memos/:id' do |id|
    hash = use_data(id)
    @id = "#{id}"
    @title = hash[:title]
    @content = hash[:content]
    erb :memo
end

delete  '/memos/:id' do |id|
    File.delete("memos/#{id}")
    redirect '/memos'
end

patch '/memos/:id' do |id|
    @title = "#{params['title']}"
    @content = "#{params['content']}"
    make_data(id, @title, @content)
    redirect '/memos'
end

def make_data(id, title, content)
    memo_date = {id: id, title: title, content: content}
    to_contener(memo_date, id)
end

def to_contener(memo_date, id)
    File.open("memos/#{id}","w") do |f|
        f.puts(memo_date)
    end
end

def use_data(id)
    (eval File.read("memos/#{id}"))
end

# def puts_memos_list
#     Dir.glob("*", base:"memos")
#     end


