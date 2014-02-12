require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
	module NodeMaster
		class AddVM < Vagrant.plugin(2, :command)
			
			def execute
				options = {}
				options[:rename] = false
				
				opts = OptionParser.new do |opts|
				
					opts.banner = "Usage: vagrant remote config addvm <node-name> <vm_config_file> [--rename]"
					opts.separator ""
					opts.on("-r", "--rename", "Rename VM automatically if another VM with the same name exists") do |r|
						options[:rename] = r
					end
				
				end
				
				
				
				argv = parse_options(opts)
				      
				return if !argv
						
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length != 2)
				
				#Add machines 
				result=RequestController.vm_add(argv[0],argv[1],options[:rename])				
				
 			  @env.ui.success("Operation successfully performed") if result
 			  
 			  	
				# @env.ui.info("Remote Client: #{argv[0]}", :prefix => false)
				# machines.each do |machine|
					# @env.ui.info(" * Virtual Machine '#{machine}' destroyed", :prefix => false) 
				# end
# 				
				# @env.ui.info(" ")
				
				
			end
		end
	end
end
