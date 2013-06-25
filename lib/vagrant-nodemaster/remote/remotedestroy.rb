require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
	module NodeMaster
		class DestroyVM < Vagrant.plugin(2, :command)
			def execute
				options = {}
				options[:force] = false
				
				opts = OptionParser.new do |opts|
				
					opts.banner = "Usage: vagrant remote destroy <client-name> [vm_name] [--force] [-h]"
					opts.separator ""
					opts.on("-f", "--force", "Destroy without confirmation") do |f|
						options[:force] = f
					end
				
				end
				
				argv = parse_options(opts)         
				return if !argv
						
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 || argv.length > 2)
				
#				begin
				
				if (!options[:force])				
					
					message = "all virtual machines"
					
					if (argv.length>1)					
						message = "virtual machine \"#{argv[1]}\""
					end
					
					choice = @env.ui.ask("Do you really want to destroy #{message} [N/Y]? ")
					
					if (!choice || choice.upcase != "Y" )									
						return 0				
					end
				end		
				
					
				#Destroy machines 
				machines=RequestController.vm_destroy(argv[0],argv[1])
				
				@env.ui.info("Remote Client: #{argv[0]}", :prefix => false)
				machines.each do |machine|
					@env.ui.info(" * Virtual Machine '#{machine}' destroyed", :prefix => false) 
				end
				
				@env.ui.info(" ")
				
#				rescue RestClient::RequestFailed => e
#					@env.ui.error("Remote Client \"#{argv[0]}\": Request Failed")
#				rescue RestClient::ResourceNotFound => e          
#					@env.ui.error("Remote Client \"#{argv[0]}\": Virtual Machine \"#{argv[1]}\" could not be found")
#				rescue RestClient::ExceptionWithResponse=> e          
#					@env.ui.error(e.response)
#				rescue Exception => e
#					@env.ui.error(e.message)
#				end
				
			end
		end
	end
end
