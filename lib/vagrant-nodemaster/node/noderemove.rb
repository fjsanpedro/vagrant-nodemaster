require 'vagrant-nodemaster/node/nodedbmanager'

module Vagrant
  module NodeMaster
  
		class NodeRemove < Vagrant.plugin(2, :command)
#			def initialize(sub_args, env,db)
#					super(sub_args,env)					
#					@db=db
#			end
			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node remove [node-name] --clean"
						opts.on("-c","--clean", "Remove all nodes from list") do |c|
							options[:clean] = c
						end
					end
					
					argv = parse_options(opts)
					
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 && !options[:clean]) || (argv.length >1)
		  		
		  		#dbmanager=DB::NodeDBManager.new
		  		
		  		if (options[:clean])
		  			DB::NodeDBManager.remove_nodes
		  		elsif
		  			DB::NodeDBManager.remove_node(argv[0])
		  		end
					
					0
			end
  
  	end
  
  
  
  end
end
