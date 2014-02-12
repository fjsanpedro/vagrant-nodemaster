require 'optparse'
require 'vagrant-nodemaster/requestcontroller'


module Vagrant
  module NodeMaster
  	
		class ConfigShow < Vagrant.plugin(2, :command)
			def execute
				options = {}	
								
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote config show <node-name> [-h]"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv 
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
									
				config_file=RequestController.node_config_show(argv[0])
				@env.ui.info(config_file)
										
				0
			end
			
			
		end
  end
end
