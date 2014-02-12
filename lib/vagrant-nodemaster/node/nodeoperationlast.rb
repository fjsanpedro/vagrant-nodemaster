require 'vagrant-nodemaster/node/nodedbmanager'
require 'vagrant-nodemaster/requestcontroller'

module Vagrant
  module NodeMaster
  
		class NodeOperationLast < Vagrant.plugin(2, :command)

			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node operation last <node-name>"						
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		  		
		  		result = RequestController.node_operation_queued_last(argv[0])
		  		
		  		
		  		if (result.empty?)
		  		  @env.ui.info("Operation queue is empty");
		  		  
		  		else
  		      @env.ui.info("-------------------------------------------------------------------------------------")
            @env.ui.info("| RESULT CODE |          RESUL  T INFO                              |")       
            @env.ui.info("-------------------------------------------------------------------------------------")
            
            result.each do |operation|            
              @env.ui.info("|     #{operation[0]}     |#{operation[1].ljust(5)}")
              @env.ui.info("-------------------------------------------------------------------------------------")    
            end
		  		end	  		
		  		
          
            		  		
					
					0
			end
  
  	end
  
  end
end
