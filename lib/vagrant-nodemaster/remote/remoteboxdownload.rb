require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class BoxDownload < Vagrant.plugin(2, :command)
			def execute
				options = {}
        		options[:async] = false
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote box downloads <node-name>"
					opts.separator ""          
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		
				
				res = RequestController.box_downloads(argv[0])
				
				
				#@env.ui.info("Remote Client \"#{argv[0]}\": Box \"#{argv[1]}\" added") if options[:async]==false
				@env.ui.info("----------------------------------------------------------------------------------------------")
	            @env.ui.info("|     BOX NAME    |   BOX URL                                | PROGRESS | TIME REMAINING     |")       
	            @env.ui.info("----------------------------------------------------------------------------------------------")
            
	            res.each do |operation|            
	              @env.ui.info("|     #{operation[:box_name].rjust(5)}     |    #{operation[:box_url]}     | #{operation[:box_progress]}      |#{operation[:box_remaining]}")
	              @env.ui.info("--------------------------------------------------------------------------------------------")    
	            end
 
				#@env.ui.info("Remote Client \"#{argv[0]}\": The operation ID is \"#{res.gsub!(/\D/, "")}\"") if options[:async]==true

						
				0
			end
			
			
		end
  end
end
