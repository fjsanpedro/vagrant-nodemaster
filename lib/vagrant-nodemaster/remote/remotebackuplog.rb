require 'optparse'
require 'vagrant-nodemaster/requestcontroller'


module Vagrant
  module NodeMaster
  	
		class BackupLog < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				
				
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote backup log [node-name] [vmname] [TODO FECHAS] [-h]"
#					opts.separator ""
#          opts.on("-b", "--background", "Take backup in background") do |b|
#                  options[:background] = b
#          end

				end
				
				
				argv = parse_options(opts)          
									
				return if !argv 
#				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 1 || argv.length > 3		


				log_entries=RequestController.node_backup_log(argv[0],argv[1])				
				
				
						
				0
			end
			
			
		end
  end
end
