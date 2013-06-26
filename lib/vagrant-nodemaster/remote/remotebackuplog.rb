require 'optparse'
require 'vagrant-nodemaster/requestcontroller'


module Vagrant
  module NodeMaster
  	
		class BackupLog < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				
				#FIXME add date params
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote backup log <node-name> [vmname] [-h]"
#					opts.separator ""
#          opts.on("-b", "--background", "Take backup in background") do |b|
#                  options[:background] = b
#          end

				end
				
				
				argv = parse_options(opts)          
									
				return if !argv 
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 1 || argv.length > 2		

				
				begin
					log_entries=RequestController.node_backup_log(@env.ui,argv[0],argv[1])
					
					
					
					if !log_entries.empty?
						@env.ui.info("--------------------------------------------------------------------------------")
						@env.ui.info("|        DATE       |          VM NAME       |              STATUS             |")
						@env.ui.info("--------------------------------------------------------------------------------")
						
						log_entries.each do |date,vm,status|						
							@env.ui.info("|#{date}|#{vm.rjust(13).ljust(23)} |#{status.rjust(20).ljust(33)}|")
							@env.ui.info("--------------------------------------------------------------------------------")		
						end
					end
				rescue RestClient::ResourceNotFound => e
					@env.ui.error("Remote Client \"#{argv[0]}\": No Records found ", :new_line => false)
					if (argv[1])
						@env.ui.error("for Virtual Machine \"#{argv[1]}\"")
					else	
						@env.ui.error("for this node.")
					end 
				end
				
				
						
				0
			end
			
			
		end
  end
end
