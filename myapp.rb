# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require 'byebug'
require 'pg'

include ERB::Util
conn = PG.connect(dbname: 'shinatra_memoapp')
conn.exec('CREATE TABLE IF NOT EXISTS memodata (id UUID PRIMARY KEY, title TEXT , sentence TEXT)')

get '/memos' do
  @memos = conn.exec('SELECT * FROM memodata')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  id = SecureRandom.uuid
  title = params[:memo_title]
  text = params[:memo_text]
  conn.exec_params('INSERT INTO memodata (id, title, sentence) VALUES ($1, $2, $3)', [id, title, text])

  redirect '/memos'
end

get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = conn.exec_params('SELECT * FROM memodata WHERE id = $1', [@memo_id])

  erb :show
end

delete '/memos/:id' do
  memo_id = params[:id].to_sym
  conn.exec_params('DELETE FROM memodata WHERE id = $1', [memo_id])
  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memo = conn.exec_params('SELECT * FROM memodata WHERE id = $1', [@memo_id])
  erb :edit
end

patch '/memos/:id' do
  memo_id = params[:id].to_sym
  @memo = conn.exec_params('SELECT * FROM memodata WHERE id = $1', [memo_id])
  title = params[:memo_title]
  text = params[:memo_text]
  id = params[:id]
  conn.exec_params('UPDATE memodata SET title = $1, sentence = $2 WHERE id = $3', [title, text, id])
  erb :edit
  redirect '/memos'
end
