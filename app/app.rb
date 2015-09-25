require 'sinatra/base'
require 'sinatra/flash'
require_relative '../data_mapper_setup'
require 'byebug'

class BookmarkManager < Sinatra::Base
  set :views, proc{File.join(root, '..' , 'views')}

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links/new' do
    link = Link.new(url: params[:url], title: params[:title])

    input = params[:tags].split(' ')
    input.each do |item|
      tag = Tag.create(name: item)
      link.tags << tag
    end
    link.save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new'
  end

  get '/tags/:name' do
    tag = Tag.all(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.new(email: params[:email],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:notice] = 'Password and confirmation password do not match'
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      User.get(session[:user_id])
    end
  end

end
