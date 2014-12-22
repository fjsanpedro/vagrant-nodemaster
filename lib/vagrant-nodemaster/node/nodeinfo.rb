require 'vagrant-nodemaster/node/nodedbmanager'
require 'vagrant-nodemaster/requestcontroller'

module Vagrant
  module NodeMaster
  
		class NodeInfo < Vagrant.plugin(2, :command)

			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node info <node-name>"
						
					end
					
					argv = parse_options(opts)
					

					return if !argv
		  			raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		  		
		  		
		  		
		  			begin
						result=RequestController.node_info(argv[0])
						#@env.ui.info(result)
						@env.ui.info("Node '#{argv[0]}' Information:")
						@env.ui.info("#{"Operating System:".ljust(25)} #{result[:lsbdistdescription]}")
						@env.ui.info("#{"Processor Count:".ljust(25)} #{result[:physicalprocessorcount]}")
						@env.ui.info("#{"Architecture:".ljust(25)} #{result[:architecture]}")						
						@env.ui.info("#{"Core Count:".ljust(25)} #{result[:processorcount]}")
						
						for i in 0..(result[:processorcount].to_i-1)
						   puts "processor #{i} => "+result[("processor"+i.to_s).to_sym]
						end						

						@env.ui.info("#{"CPU Average:".ljust(25)} #{result[:cpuaverage][0]}% (1 Minute)  #{result[:cpuaverage][1]}% (5 Minutes)  #{result[:cpuaverage][2]}% (15 Minutes)")
						@env.ui.info("#{"Memory Size:".ljust(25)} #{result[:memorysize]} GB (#{result[:memoryfree]} GB Free)")
						@env.ui.info("#{"Disk Used:".ljust(25)}#{result[:diskusage]} GB")

						interfaces = result[:interfaces].split(",")
						
						interfaces.each do |i|
							interface=("ipaddress_"+i).to_sym
							puts "Interface #{i} => "+result[interface] if result[interface]
						end
						
					end
					
					0
			end
  
  	end
  
  end
end
