require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
  	#FIXME Mejorar tema de pintado, añadir opciones para una salida
  	#más reducidad y otra más extensa
		class SnapshotList < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote snapshot list <node-name> [vmname]"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 1 && argv.length > 2
					
				snapshots = RequestController.get_remote_snapshots(argv[0],argv[1])			
				
				@env.ui.info("Remote Client \"#{argv[0]}\":", :prefix => false)
				snapshots.each do |vmname,snapshots|
						
						if (!snapshots || snapshots.empty?)
							@env.ui.info("\nMachine \"#{vmname}\" #{NO_SNAPSHOT_MESSAGE}", :prefix => false)
						else							
							@env.ui.info("\n--------------------------------------------------------------")
							@env.ui.info("Machine \"#{vmname}\" Snapshots: ", :prefix => false)
							@env.ui.info("--------------------------------------------------------------")
							print_snapshots(snapshots)
							@env.ui.info("\n")
						end
				end
						
				0
			end
			private
			NO_SNAPSHOT_MESSAGE = "does not have any snapshots"
			
			def print_snapshots(snapshots,level=1)
				return if snapshots.empty?
				
				snapshots.each { |snapshot|					
					space = "  " * level
					space = space + "* " if (snapshot[:current_state])					
															
					@env.ui.info("#{space}Date: #{snapshot[:timestamp].ljust(3)}")
					@env.ui.info("#{space}Name: #{snapshot[:name]}") 
					@env.ui.info("#{space}UUID: #{snapshot[:uuid]}")
					@env.ui.info("#{space}Description: #{snapshot[:description]}")
					@env.ui.info("#{space}-----------------------------------------------------")
					print_snapshots(snapshot[:snapshots],level+1)												
				}
			end
			
		end
  end
end
