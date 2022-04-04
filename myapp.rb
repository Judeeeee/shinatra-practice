# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'

include ERB::Util
memos = {}

class DataBaseHandles
  class << self
    def load_json
      @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
    end

    def open_json
      File.open('json/memo.json', 'w') do |file|
        JSON.dump(@memos, file)
      end
    end
  end
end

# top
get '/memos' do
  DataBaseHandles.load_json
  erb :index
end

# new
get '/memos/new' do
  erb :new
end

post '/memos/new' do
  @id = SecureRandom.uuid
  DataBaseHandles.load_json
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  DataBaseHandles.load_json[@id] = @memo
  DataBaseHandles.open_json
  DataBaseHandles.load_json

  redirect '/memos'
end

# show
get '/memos/:id' do
  DataBaseHandles.load_json
  @memo_id = params[:id].to_sym
  @title = DataBaseHandles.load_json[@memo_id][:title]
  @text = DataBaseHandles.load_json[@memo_id][:text]

  erb :show
end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  DataBaseHandles.load_json
  DataBaseHandles.load_json.delete(@memo_id)
  DataBaseHandles.open_json

  redirect '/memos'
end

get '/memos/:id/edit' do
  DataBaseHandles.load_json
  @memo_id = params[:id].to_sym
  @title = DataBaseHandles.load_json[@memo_id][:title]
  @text = DataBaseHandles.load_json[@memo_id][:text]

  erb :edit
end

# edit
post '/memos/:id/edit' do
  DataBaseHandles.load_json

  erb :edit
end

# 更新
patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  DataBaseHandles.load_json
  DataBaseHandles.load_json[@memo_id] = @memo
  DataBaseHandles.open_json

  erb :edit
  redirect '/memos'
end
