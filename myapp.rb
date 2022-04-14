# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require 'byebug'
require 'pg'

include ERB::Util

# PostgreSQLの操作
  def create(idd,titlee,textt)
    @conn = PG.connect( dbname: 'shinatra_memoapp' )
    @conn.exec( "insert into memodata values ('#{idd}','#{titlee}','#{textt}')" )
  end

  def find(idd)
    @conn = PG.connect( dbname: 'shinatra_memoapp' )
    @conn.exec("SELECT * FROM memodata WHERE id='#{idd}'")
  end

  def update(idd,titlee,textt)
    @conn = PG.connect( dbname: 'shinatra_memoapp' )
    @conn.exec("UPDATE memodata set title='#{titlee}', sentence='#{textt}' where id='#{idd}'")
  end

  def delete(idd)
    @conn = PG.connect( dbname: 'shinatra_memoapp' )
    @conn.exec("DELETE FROM memodata where id='#{idd}'")
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
  @title = params[:memo_title].to_s
  @text = params[:memo_text].to_s
  @id = SecureRandom.uuid.to_s
  create(@id,@title,@text)
  redirect '/memos'
end


get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = find(@memo_id)
  @title = @memo[0]["title"]
  @text = @memo[0]["sentence"]

  erb :show
end


delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  delete(@memo_id)

  redirect '/memos'
end


get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memo = find(@memo_id)
  @title = @memo[0]["title"]
  @text = @memo[0]["sentence"]

  erb :edit
end


patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @title = params[:memo_title].to_s
  @text = params[:memo_text].to_s
  update(@memo_id,@title,@text)

  erb :edit
  redirect '/memos'
end
