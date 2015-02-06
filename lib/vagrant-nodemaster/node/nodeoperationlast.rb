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
            		@env.ui.info("| RESULT CODE |   VIRTUAL MACHINE    |               RESULT INFO               |")       
            		@env.ui.info("-------------------------------------------------------------------------------------")
            
		            result.each do |operation|            
		              code= operation[0]		              
		              rparams=JSON.parse(operation[1],{:quirks_mode => true,:symbolize_names => true})			              
		              vm = rparams[0].has_key?(:vmname) ? rparams[0][:vmname]: "--"		              		              
		              result = rparams[0][:status]		              
		              @env.ui.info("|     #{code}     |         #{vm.ljust(5)}        |   #{result.ljust(5)}  ")
		              @env.ui.info("-------------------------------------------------------------------------------------")    
		            end
		  		end	  		
		  		
          
            		  		
					
					0
			end
  
  	end
  
  end
end
