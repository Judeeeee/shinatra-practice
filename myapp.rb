# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require 'byebug'
require 'pg'

include ERB::Util

def postgresql(sql)
  conn = PG.connect( dbname: 'shinatra_memoapp' )
  memos_data = conn.exec(sql)
  conn.finish
  memos_data
end

def select
  sql = "SELECT * FROM memodata"
  postgresql(sql)
end

def create(id)
  title = params[:memo_title]
  text = params[:memo_text]
  sql = "INSERT INTO memodata values ('#{id}', '#{title}', '#{text}')"
  postgresql(sql)
end

def find(id)
  sql = "SELECT * FROM memodata WHERE id = '#{id}'"
  memo = postgresql(sql)
  memo[0]
end

def update
  title = params[:memo_title]
  text = params[:memo_text]
  id = params[:id]
  sql = "UPDATE memodata SET title = '#{title}', sentence = '#{text}' WHERE id = '#{id}'"
  postgresql(sql)
end

def delete
  id = params[:id].to_sym
  sql = "DELETE FROM memodata WHERE id = '#{id}'"
  postgresql(sql)
end


get '/memos' do
  @conn = PG.connect( dbname: 'shinatra_memoapp' )
  @memo_list = @conn.exec("SELECT * FROM memodata")
  #memo全てのハッシュを配列に格納
    @memos = []
    for memo in @memo_list
      @memos.push(memo)
    end

  @array_size = @memos.size

    @memo_id_array = []
    @array_size.times{|n|
      @memo_id_array[n] = @memos[n]["id"]
    }


    @memo_title_array = []
    @array_size.times{|n|
      @memo_title_array[n] = @memos[n]["title"]
    }
  erb :index
end


get '/memos/new' do
  erb :new
end

post '/memos' do
  id = SecureRandom.uuid.to_s
  create(id)
  redirect '/memos'
end


get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = find(@memo_id)
  erb :show
end


delete '/memos/:id' do
  delete
  redirect '/memos'
end


get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memo = find(@memo_id)
  erb :edit
end


patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = find(@memo_id)
  update
  erb :edit
  redirect '/memos'
end
