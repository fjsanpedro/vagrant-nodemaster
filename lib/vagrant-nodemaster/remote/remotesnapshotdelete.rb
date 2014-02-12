require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
  	
		class SnapshotDelete < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote snapshot delete <node-name> <vmname> <uuid>"
				end
				
				
				argv = parse_options(opts)
        
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 3 
         					
				RequestController.vm_snapshot_delete(argv[0],argv[1],argv[2])
   				
        
				@env.ui.success("Remote Client: #{argv[0]}: Snapshot with UUID #{argv[2]} succesfully deleted.", :prefix => false)
				# @env.ui.success("Snapshot with UUID #{argv[2]} succesfully deleted.")
						
				0
			end
			
			
		end
  end
end
