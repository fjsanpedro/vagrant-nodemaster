require 'vagrant-nodemaster/node/nodedbmanager'

module Vagrant
  module NodeMaster
  
		class NodeAdd < Vagrant.plugin(2, :command)

			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node add <node-name> <node-address> <node-port> --hostname"
						opts.on("--hostname", "Address in dns format") do |d|
							options[:dns] = d
						end
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3
		  		
		  		dbmanager=DB::NodeDBManager.new
		  		
		  		dbmanager.add_node(argv[0],argv[1],argv[2].to_i,options[:dns])
					
					0
			end
  
  	end
  
  end
end
