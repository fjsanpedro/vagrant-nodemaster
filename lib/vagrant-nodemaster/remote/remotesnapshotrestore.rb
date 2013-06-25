require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
  	
		class SnapshotRestore < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote snapshot restore <client-name> <vmname> <snapshot-uuid|snapshot-name]>"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3  
				
				begin
					snapshot = RequestController.vm_snapshot_restore(argv[0],argv[1],argv[2])			
				
					@env.ui.info("Remote Client \"#{argv[0]}\": Virtual Machine \"#{argv[1]}\" => Restoring snapshot \"#{argv[2]}\"", :prefix => false)
					#@env.ui.info("Snapshot \"#{snapshot[:name]}\" with UUID #{snapshot[:id]} succesfully created.")
				rescue RestClient::ResourceNotFound => e          
					@env.ui.error("Remote Client \"#{@argv[0]}\": Virtual Machine \"#{argv[1]}\" => Snapshot \"#{argv[2]}\" could not be found")
				end
				0
			end
			
			
		end
  end
end
