require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class StatusVM < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote status <node-name> [vm_name]"
				end
				
				argv = parse_options(opts)
				return if !argv  
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 || argv.length > 2)
				
#				begin
					machine_status=RequestController.vm_status(argv[0],argv[1])
	
					@env.ui.info("Remote Client: #{argv[0]}", :prefix => false)
	
					machine_status.each do |machine|
						@env.ui.info(" * #{machine["name"].ljust(25)}   #{machine["status"]} (#{machine["provider"]})", :prefix => false) 
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
				
				
				0
			end
		end
  end
end
