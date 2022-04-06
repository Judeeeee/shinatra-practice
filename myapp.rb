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

    def add(memo)
      @id = SecureRandom.uuid
      @memos[@id] = memo
    end
  end
end

# top
get '/memos' do
  DataBaseHandles.load
  @memolist = DataBaseHandles.load.map{ |memo| "<a href=/memos/#{memo[0]}>#{html_escape(memo[1][:title])}</a>" }.join("<br>")
  erb :index
end

# new
get '/memos/new' do
  erb :new
end

post '/memos' do
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  DataBaseHandles.add(@memo)
  DataBaseHandles.store

  redirect '/memos'
end

# show
get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = DataBaseHandles.load[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]

  erb :show
end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  DataBaseHandles.load.delete(@memo_id)
  DataBaseHandles.store

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memo = DataBaseHandles.load[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]

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
  DataBaseHandles.load[@memo_id] = @memo
  DataBaseHandles.store

  erb :edit
  redirect '/memos'
end
