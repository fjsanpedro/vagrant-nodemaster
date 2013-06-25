require 'vagrant-nodemaster/client/clientdbmanager'

module Vagrant
  module NodeMaster
  
		class ClientAdd < Vagrant.plugin(2, :command)

			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant client add <client-name> <client address> <client port> --hostname"
						opts.on("--hostname", "Address in dns format") do |d|
							options[:dns] = d
						end
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3
		  		
		  		dbmanager=DB::ClientDBManager.new
		  		
		  		dbmanager.add_client(argv[0],argv[1],argv[2].to_i,options[:dns])
					
					0
			end
  
  	end
  
  end
end
