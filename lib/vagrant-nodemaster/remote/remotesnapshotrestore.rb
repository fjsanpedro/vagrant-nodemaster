require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
  	
		class SnapshotRestore < Vagrant.plugin(2, :command)
			def execute
				options = {}
	      options[:async] = true
	     
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote snapshot restore <node-name> <vmname> <snapshot-uuid|snapshot-name] [--synchronous]>"
					opts.separator ""
					opts.on("-s", "--synchronous", "Wait until the operation finishes") do |f|
		              options[:async] = false
		           	end
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3  
				
				
				snapshot = RequestController.vm_snapshot_restore(argv[0],argv[1],argv[2],options[:async])			
				
				if options[:async] == false
					@env.ui.info("Remote Client \"#{argv[0]}\": Virtual Machine \"#{argv[1]}\" => Restoring snapshot \"#{argv[2]}\"", :prefix => false)					
		        else
		          @env.ui.info("Remote Client \"#{argv[0]}\": The operation ID is \"#{snapshot.gsub!(/\D/, "")}\"")
		        end 
				
				
				
				0
			end
			
			
		end
  end
end
