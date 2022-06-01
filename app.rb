#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pry'

def db_init
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

before do
	db_init
	@db.execute 'create table if not exists "Posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,
																									"created_date"  DATE,
																									"content" TEXT,
																									"author" TEXT);
							'
	@db.execute 'create table if not exists "Comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,
	"created_date"  DATE,
	"content" TEXT,
	"post_id" INTEGER);
'						
end

configure do
	db_init
	@db
end

get '/' do
	@result = @db.execute ' select * from "Posts" order by id desc'
erb :index
end

get '/new_post' do 
	
	erb :new_post
end

post '/new_post' do
	@text = params[:content]
	@author = params[:author]
	if @text.length == 0 || @author.length == 0
		@error = "The one of fields is empty. Input your message or name"
	else
	@db.execute 'insert into "Posts" (content, created_date, author) values (?, datetime(), ?)', [@text, @author]
	redirect to '/'
	end
	return erb :new_post
end

get '/detales/:post_id' do
	result = @db.execute ' select * from "Posts" where id=?', [params[:post_id]]
	@row = result[0]
	@comments = @db.execute 'select * from "Comments" where post_id=?',[params[:post_id]]
	
erb :detales
end

post '/detales/:post_id' do
	content = params[:comment]
	post_id = params[:post_id]
	if content.length == 0
		@error = 'Erorrrrrrr'
	else
	@db.execute 'insert into "Comments"
							(content,
							created_date,
							post_id)
											values (?, datetime(), ?)', 
											[content, post_id]
	end	
	#здесь теряестя переменная @error
	redirect to "/detales/#{post_id}"
end