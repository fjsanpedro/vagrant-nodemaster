require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
	module NodeMaster
		class ConfigUpload < Vagrant.plugin(2, :command)
			
			def execute
				
				
				opts = OptionParser.new do |opts|
				
					opts.banner = "Usage: vagrant remote config upload <node-name> <config_file>"
					opts.separator ""				
				
				end
				
				
				
				argv = parse_options(opts)
				       
				return if !argv
						
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length != 2)
				
				#Add machines 
				result=RequestController.node_config_upload(argv[0],argv[1])				
				
 			  @env.ui.success("Operation successfully performed") if result
				
				
			end
		end
	end
end
