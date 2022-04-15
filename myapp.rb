# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require 'byebug'

include ERB::Util
memos = {}

def load
  JSON.parse(File.read('json/memo.json'), symbolize_names: true)
end

def store(memodata)
  File.open('json/memo.json', 'w') do |file|
   JSON.dump(memodata, file)
  end
end


# top
get '/memos' do
  @memos = load()
  @memo_id_array = @memos.keys
  @array_size = @memo_id_array.size

  erb :index
end

# new
get '/memos/new' do
  erb :new
end

post '/memos' do
  @memos = load()
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  @memos[SecureRandom.uuid] = @memo
  store(@memos)

  redirect '/memos'
end

# show
get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memo = @memos[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]

  erb :show
end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memos.delete(@memo_id)
  store(@memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memo = @memos[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]

  erb :edit
end

# edit
post '/memos/:id/edit' do
  load()

  erb :edit
end

# 更新
patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  @memos = load()
  @memos[@memo_id] = @memo
  store(@memos)

  erb :edit
  redirect '/memos'
end
