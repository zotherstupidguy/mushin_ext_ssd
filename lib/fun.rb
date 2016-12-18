require 'mushin'
require 'ssd'
require_relative 'SSD/version'


module SSD
  class Ext 
    using Mushin::Ext 

    def initialize app=nil, opts={}, params={}
      @app 	= app
      @opts 	= opts
      @params 	= params 
    end
    def call env 
      env ||= Hash.new 
      # write inbound code
      @app.call(env)
      # write outbound code
      if @opts[:cqrs] == :cqrs_query then
	env[:query_results] = SSD.read(@opts[:path], @params[:id])
      else 
	SSD.write @opts[:path], env[:id], env
      end
    end
  end

end
