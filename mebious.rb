require 'sinatra'
require_relative 'models/posts'
require_relative 'utils/Mebious'

$config = "./config.json"
$posts  = Posts.new($config)

get ('/') {
  @posts = $posts.last(10)
  
  erb :index
}

get ('/posts') {
  content_type :json
  $posts.last(10).to_a.to_json
}

get ('/posts/:n') {
  content_type :json
  
  n = params[:n].to_i
  if (n > 50 or n < 1)
    redirect '/posts'
  end

  $posts.last(n).to_a.to_json
}

post ('/posts') {
  ip = request.ip
  
  if !params.has_key? "text"
    redirect '/'    
  end

  if params["text"].empty?
    redirect '/'
  end

  $posts.add(params["text"], ip)
  redirect '/'
}
