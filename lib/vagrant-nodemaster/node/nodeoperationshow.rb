require 'vagrant-nodemaster/node/nodedbmanager'
require 'vagrant-nodemaster/requestcontroller'

module Vagrant
  module NodeMaster
  
		class NodeOperationShow < Vagrant.plugin(2, :command)

			def execute
					
				options = {}
				
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant node operation show <node-name> <operation-id>"						
				end
				
				argv = parse_options(opts)
				return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 2
		  		
		  		if (argv[1].to_i==0)
		  			@env.ui.error("Invalid operation ID")
		  		else


		  			
			  		result = RequestController.node_operation_queued(argv[0],argv[1])

			  			  		
		  			
			  		
			  		case result[0]
			  		when 100
			  		  @env.ui.info("The operation #{argv[1]} is \"IN PROGRESS\"")
			  		when 200
			  		  @env.ui.success("The operation #{argv[1]} succeeded.")
			  		else		  			
			  			rparams=JSON.parse(result[1],{:quirks_mode => true,:symbolize_names => true})	
			  			rparams=rparams[0]
			  			

			  		  @env.ui.error("The operation #{argv[1]} in Virtual Machine '#{rparams[:vmname]}' failed. The result is:\n#{rparams[:status]}")
			  		end
				  	
			  	end
					
					0
			end
  
  	end
  
  end
end
