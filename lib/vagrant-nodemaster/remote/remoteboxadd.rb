require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class BoxAdd < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote box add <client-name> <box-name> <url>"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3
		
				
					
#				begin
				
					RequestController.box_add(argv[0],argv[1],argv[2])
#					@env.ui.info("Remote Client \"#{argv[0]}\": Box \"#{argv[1]}\" with provider \"#{argv[2]}\" removed")
#				rescue RestClient::ResourceNotFound => e          
#					@env.ui.error("Remote Client \"#{argv[0]}\": Box \"#{argv[1]}\" with provider \"#{argv[2]}\" could not be found")			
#				end
						
				0
			end
			
			
		end
  end
end
