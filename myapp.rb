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
    def load
      @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
    end

    def store
      File.open('json/memo.json', 'w') do |file|
        JSON.dump(@memos, file)
      end
    end
  end
end

# top
get '/memos' do
  DataBaseHandles.load
  erb :index
end

# new
get '/memos/new' do
  erb :new
end

post '/memos' do
  @id = SecureRandom.uuid
  DataBaseHandles.load
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  DataBaseHandles.load[@id] = @memo
  DataBaseHandles.store
  DataBaseHandles.load

  redirect '/memos'
end

# show
get '/memos/:id' do
  DataBaseHandles.load
  @memo_id = params[:id].to_sym
  @title = DataBaseHandles.load[@memo_id][:title]
  @text = DataBaseHandles.load[@memo_id][:text]

  erb :show
end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  DataBaseHandles.load
  DataBaseHandles.load.delete(@memo_id)
  DataBaseHandles.store

  redirect '/memos'
end

get '/memos/:id/edit' do
  DataBaseHandles.load
  @memo_id = params[:id].to_sym
  @title = DataBaseHandles.load[@memo_id][:title]
  @text = DataBaseHandles.load[@memo_id][:text]

  erb :edit
end

# edit
post '/memos/:id/edit' do
  DataBaseHandles.load

  erb :edit
end

# 更新
patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  DataBaseHandles.load
  DataBaseHandles.load[@memo_id] = @memo
  DataBaseHandles.store

  erb :edit
  redirect '/memos'
end
