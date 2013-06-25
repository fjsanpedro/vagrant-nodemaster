require 'vagrant-nodemaster/client/clientdbmanager'

module Vagrant
  module NodeMaster
  
		class ClientList < Vagrant.plugin(2, :command)
#			def initialize(sub_args, env,db)
#					super(sub_args,env)					
#					@db=db
#			end
			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant client list"
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 0
		  		
		  		dbmanager=DB::ClientDBManager.new
		  		
#		  		@env.ui.info("Client List:", :prefix => false)
		  		@env.ui.info("#{"CLIENT".ljust(25)} ADDRESS (PORT) ",:prefix => false)
					dbmanager.get_clients.each do |name,address,port|
#						puts "NOMBRES: #{name} ADDRESS: #{address} PORT: #{port}"
						@env.ui.info("#{name.ljust(25)} #{address}(#{port})", :prefix => false) 
					end
					@env.ui.info(" ", :prefix => false)
					0
			end
  
  	end
  
  
  
  end
end
