# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'date'

# 現在の時刻をメモのIDに用いる
@memos = {}

helpers do
  def xss_solution(text)
    Rack::Utils.escape_html(text)
  end
end

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
  dt = DateTime.now.to_s
  @id = dt.gsub(/[^\d]/, '').to_i
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  hash = { title: xss_solution(params[:memo_title]), text: xss_solution(params[:memo_text]) }
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
  changed_hash = { title: xss_solution(params[:memo_title].to_s), text: xss_solution(params[:memo_text].to_s) }
  @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
  @memos[@memo_id] = changed_hash

  File.open('json/memo.json', 'w') do |file|
    JSON.dump(@memos, file)
  end

  erb :edit
  redirect '/memos'
end
