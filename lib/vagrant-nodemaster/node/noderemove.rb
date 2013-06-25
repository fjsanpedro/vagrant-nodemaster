require 'vagrant-nodemaster/client/clientdbmanager'

module Vagrant
  module NodeMaster
  
		class ClientRemove < Vagrant.plugin(2, :command)
#			def initialize(sub_args, env,db)
#					super(sub_args,env)					
#					@db=db
#			end
			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant client remove [client-name] --clean"
						opts.on("-c","--clean", "Remove all clients from list") do |c|
							options[:clean] = c
						end
					end
					
					argv = parse_options(opts)
					
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 && !options[:clean]) || (argv.length >1)
		  		
		  		dbmanager=DB::ClientDBManager.new
		  		
		  		if (options[:clean])
		  			dbmanager.remove_clients
		  		elsif
		  			dbmanager.remove_client(argv[0])
		  		end
					
					0
			end
  
  	end
  
  
  
  end
end
