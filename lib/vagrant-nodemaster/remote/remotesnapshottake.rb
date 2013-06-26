require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
  	
		class SnapshotTake < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote snapshot take <node-name> <vmname> <name> [description]"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 3 || argv.length > 4 
					
				snapshot = RequestController.vm_snapshot_take(argv[0],argv[1],argv[2],argv[3])			
				
				@env.ui.info("Remote Client: #{argv[0]}", :prefix => false)
				@env.ui.info("Snapshot \"#{snapshot[:name]}\" with UUID #{snapshot[:id]} succesfully created.")
						
				0
			end
			
			
		end
  end
end
