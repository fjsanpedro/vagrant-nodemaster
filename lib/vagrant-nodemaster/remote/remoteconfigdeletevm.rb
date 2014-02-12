require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
	module NodeMaster
		class DeleteVM < Vagrant.plugin(2, :command)
			
			def execute
				options = {}
				options[:remove] = false
				
				opts = OptionParser.new do |opts|
				
					opts.banner = "Usage: vagrant remote config deletevm <node-name> <vm_name> [--remove]"
					opts.separator ""
					opts.on("-r", "--remove", "Deletes all information of the VM in the remote node") do |r|
						options[:remove] = r
					end
				
				end
				
				
				
				argv = parse_options(opts)
				      
				return if !argv
						
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length != 2)
				
				#Destroy machines 
				result=RequestController.vm_delete(argv[0],argv[1],options[:remove])
				
				@env.ui.success("Operation successfully performed") if result
				
			end
		end
	end
end
