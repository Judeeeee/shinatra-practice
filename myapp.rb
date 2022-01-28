# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'

include ERB::Util
@memos = {}

# top
get '/memos' do
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  erb :index
end

# new
get '/memos/new' do
  erb :new
end

post '/memos/new' do
  @id = SecureRandom.uuid
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  hash = { title: params[:memo_title], text: params[:memo_text] }
  @memos[@id] = hash

  File.open('json/memo.json', 'w') do |file|
    JSON.dump(@memos, file)
  end
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)

  redirect '/memos'
end

# show
get '/memos/:id' do
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  @memo_id = params[:id].to_s
  @title = @memos[params[:id].to_sym][:title]
  @text = @memos[params[:id].to_sym][:text]

  erb :show
end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  @memos.delete(@memo_id)

  File.open('json/memo.json', 'w') do |file|
    JSON.dump(@memos, file)
  end

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  @memo_id = params[:id].to_s
  @title = @memos[params[:id].to_sym][:title]
  @text = @memos[params[:id].to_sym][:text]

  erb :edit
end

# edit
post '/memos/:id/edit' do
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  erb :edit
end

# 更新
patch '/memos/:id/edit' do
  @memo_id = params[:id].to_s
  changed_hash = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  @memos[@memo_id] = changed_hash

  File.open('json/memo.json', 'w') do |file|
    JSON.dump(@memos, file)
  end

  erb :edit
  redirect '/memos'
end
