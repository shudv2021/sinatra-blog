#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def db_init
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

before do
	db_init
	@db.execute 'create table if not exists "Posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,
																									"created_date"  DATE,
																									"content" TEXT);
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
	if @text.length == 0
		@error = "The field is empty. Input your message"
	else
	@db.execute 'insert into "Posts" (content, created_date) values (?, datetime())', [@text]
	redirect to '/'
	end
	return erb :new_post
end

get '/detales/:post_id' do
	result = @db.execute ' select * from "Posts" where id=?', [params[:post_id]]
	@row = result[0]
erb :detales
end

post '/detales/:post_id' do
	content = params[:comment]
	post_id = params[:post_id]
	
	@db.execute 'insert into "Comments"
							(content,
							created_date,
							post_id)
											values (?, datetime(), ?)', 
											[content, post_id]

	@comments = "something"
	redirect to "/detales/#{post_id}"
end