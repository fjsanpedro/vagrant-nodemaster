require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
	module NodeMaster
		class HaltVM < Vagrant.plugin(2, :command)
			def execute
				options = {}
				options[:force] = false
				options[:async] = true

				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote halt <node-name> [vm_name] [--force] [--synchronous] [-h]"
					opts.separator ""
					opts.on("-f", "--force", "Force shut down") do |f|
						options[:force] = f
					end
					opts.on("-s", "--synchronous", "Wait until the operation finishes") do |f|
            options[:async] = false
          end
				end


				argv = parse_options(opts)         
				return if !argv

				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 || argv.length > 2)

#				begin          		          		

					machines=RequestController.vm_halt(argv[0],argv[1],options[:force],options[:async])

          if options[:async] == false   
  					machines.each do |machine|
  					 @env.ui.success("Remote Client \"#{argv[0]}\": Virtual Machine \"#{machine["vmname"]}\" halted")
  					end          				
					else
					  @env.ui.info("Remote Client \"#{argv[0]}\": The operation ID is \"#{machines.gsub!(/\D/, "")}\"")
					end
  					  


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
