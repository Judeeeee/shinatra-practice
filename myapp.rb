# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require 'byebug'
require 'pg'

#postgreSQLで出力テスト
conn = PG.connect( dbname: 'shinatra_memoapp' )
# @memos = conn.exec( "SELECT * FROM memodata" ) #これ自体がハッシュなので、@memos[0]とかで取り出せそう

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
# 他に必要なもの
  # メモリスト(トップページで一覧表示させるため)
  # @memolist


# top
get '/memos' do
  @memos = load()
  @memo_id_array = @memos.keys
  @array_size = @memo_id_array.size

  erb :index
end

  # top
  get '/memos' do #ここわからんかも
    memos = conn.exec( "SELECT * FROM memodata" )
    # 展開してhash作り直せば良い？
      # 一旦無視 @memolist = @memo.map{ |memo| "<a href=/memos/#{memo[0]}>#{html_escape(memo[1][:title])}</a>" }.join("<br>")
    erb :index
  end

post '/memos' do
  @memos = load()
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  @memos[SecureRandom.uuid] = @memo
  store(@memos)

  post '/memos' do
    PostgreSQL.create
    redirect '/memos'
  end

# show
get '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memo = @memos[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]

  # 削除
  delete '/memos/:id' do
    @memo_id = params[:id].to_sym　#URLからID取得して検索かけてる
    PostgreSQL.delete
    redirect '/memos'
  end

# 削除
delete '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memos.delete(@memo_id)
  store(@memos)

  # edit
  post '/memos/:id/edit' do
    PostgreSQL.find_id #ここはわからん
    erb :edit
  end

get '/memos/:id/edit' do
  @memo_id = params[:id].to_sym
  @memos = load()
  @memo = @memos[@memo_id]
  @title = @memo[:title]
  @text = @memo[:text]


# edit
post '/memos/:id/edit' do
  load()


# 更新
patch '/memos/:id' do
  @memo_id = params[:id].to_sym
  @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
  @memos = load()
  @memos[@memo_id] = @memo
  store(@memos)

# include ERB::Util
# memos = {}
#
# class DataBaseHandles
#   class << self
#     def load
#       @memos = JSON.parse(File.read('json/memo.json'), symbolize_names: true)
#     end
#
#     def store
#       File.open('json/memo.json', 'w') do |file|
#         JSON.dump(@memos, file)
#       end
#     end
#
#     def add(memo)
#       @id = SecureRandom.uuid
#       @memos[@id] = memo
#     end
#   end
# end
#
# # top
# get '/memos' do
#   DataBaseHandles.load
#   @memolist = DataBaseHandles.load.map{ |memo| "<a href=/memos/#{memo[0]}>#{html_escape(memo[1][:title])}</a>" }.join("<br>")
#   erb :index
# end
#
# # new
# get '/memos/new' do
#   erb :new
# end
#
# post '/memos' do
#   @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
#   DataBaseHandles.add(@memo)
#   DataBaseHandles.store
#
#   redirect '/memos'
# end
#
# # show
# get '/memos/:id' do
#   @memo_id = params[:id].to_sym
#   @memo = DataBaseHandles.load[@memo_id]
#   @title = @memo[:title]
#   @text = @memo[:text]
#
#   erb :show
# end
#
# # 削除
# delete '/memos/:id' do
#   @memo_id = params[:id].to_sym
#   DataBaseHandles.load.delete(@memo_id)
#   DataBaseHandles.store
#
#   redirect '/memos'
# end
#
# get '/memos/:id/edit' do
#   @memo_id = params[:id].to_sym
#   @memo = DataBaseHandles.load[@memo_id]
#   @title = @memo[:title]
#   @text = @memo[:text]
#
#   erb :edit
# end
#
# # edit
# post '/memos/:id/edit' do
#   DataBaseHandles.load
#
#   erb :edit
# end
#
# # 更新
# patch '/memos/:id' do
#   @memo_id = params[:id].to_sym
#   @memo = { title: params[:memo_title].to_s, text: params[:memo_text].to_s }
#   DataBaseHandles.load[@memo_id] = @memo
#   DataBaseHandles.store
#
#   erb :edit
#   redirect '/memos'
# end
