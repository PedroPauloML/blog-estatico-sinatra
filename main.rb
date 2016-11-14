require 'sinatra'
require 'find'
set :bind, '0.0.0.0'

before '/*' do
  @posts = get_files('./views/posts/')
end

def get_files(path)
  files = []
  Find.find(path) do |f|
    if !File.directory?(f)
      files << File.basename(f, ".erb")
    end
  end
  return files
end

get '/' do
  erb :index
end

get '/post/new/?' do
  erb :form
end

post '/post/create/?' do
  arq = File.new("./views/posts/#{params[:title]}.erb", "w")
  @post = erb :"layout_post",
                layout: false,
                locals: { title: params[:title],
                          name: params[:name],
                          text: params[:text] }
  arq.write @post
  arq.close
  redirect '/'
end

get '/post/:post/?' do
  halt 404 unless File.exists?("./views/posts/#{params[:post]}.erb")
  erb :"posts/#{params[:post]}"
end

get '/post/:post/delete/?' do
  File.delete("./views/posts/#{params[:post]}.erb")
  redirect '/'
end