require 'sinatra'

class HelloWorldApp < Sinatra::Base
  get '/:greeting/?:name?' do
      "#{params[:greeting]}, #{params[:name] ? params[:name] : 'world'}!"
  end
end