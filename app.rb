#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def db_init
	@db = SQLite3::Database.new 'blog.db'
end

before do
	db_init
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new_post' do 
	
	erb :new_post
end

get '/posts' do
	
	erb :posts
end

post '/new_post' do
	@text = params[:content]
	erb :new_post
end
