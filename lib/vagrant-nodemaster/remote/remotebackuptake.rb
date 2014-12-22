require 'optparse'
require 'vagrant-nodemaster/requestcontroller'


module Vagrant
  module NodeMaster
  	
		class BackupTake < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				options[:background]=false
				options[:download] = nil
				
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote backup take [node-name] [vmname] [--download target_directory][--background] [-h]"
					opts.separator ""
				opts.on("-b", "--background", "Take backup in background") do |b|
				  options[:background] = b
				end
				opts.on("--download target_directory", String,"Download backup to target directory") do |d|          				          				
				  options[:download] = d
				end

				end
				
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length > 2 		

				
				
				
				ui=nil
				ui = @env.ui if options[:background]==false
				
				p = fork { RequestController.node_backup_take(ui,options[:download],argv[0],argv[1]) } 
				
				Process.waitpid(p) if options[:background]==false
						
				0
			end
			
			
		end
  end
end
