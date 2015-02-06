require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class InfoVM < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote info <node-name> <vm_name>"
				end
				
				argv = parse_options(opts)
				return if !argv  
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length != 2)
				

				vmstatus=RequestController.vm_info(argv[0],argv[1])

				@env.ui.info("Remote Client: #{argv[0]}", :prefix => false)

				

				         				

				@env.ui.info(" #{"Operating System:".ljust(25)} #{vmstatus["ostype"].ljust(25)}", :prefix => false) 
				@env.ui.info(" #{"Num. CPUS:".ljust(25)} #{vmstatus["cpus"]}", :prefix => false) 
				@env.ui.info(" #{"CPU Limit:".ljust(25)} #{vmstatus["cpuexecutioncap"]}%", :prefix => false) 					
				@env.ui.info(" #{"PAE:".ljust(25)} #{vmstatus["pae"]}", :prefix => false) 
				@env.ui.info(" #{"3D acceleration:".ljust(25)} #{vmstatus["accelerate3d"]}", :prefix => false) 
				@env.ui.info(" #{"2D acceleration:".ljust(25)} #{vmstatus["accelerate2dvideo"]}", :prefix => false) 
				@env.ui.info(" #{"Memory:".ljust(25)} #{vmstatus["memory"]} MB", :prefix => false) 
				@env.ui.info(" #{"Boot Order:".ljust(25)} #{vmstatus["boot1"]}, #{vmstatus["boot2"]}, #{vmstatus["boot3"]}, #{vmstatus["boot4"]}", :prefix => false) 
				@env.ui.info(" #{"Clipboard:".ljust(25)} #{vmstatus["clipboard"]}", :prefix => false) 
				@env.ui.info(" #{"Remote Desktop:".ljust(25)} #{vmstatus["vrde"]}", :prefix => false) 
				@env.ui.info(" #{"USB:".ljust(25)} #{vmstatus["usb"]}", :prefix => false) 
				(1..8).each {|key|
					#If interface exists
					if vmstatus.has_key?("nic#{key}") && !vmstatus["nic#{key}"].eql?("none") 							
						@env.ui.info(" ")
						@env.ui.info(" #{"Interface:".ljust(25)} nic#{key}", :prefix => false) 
						@env.ui.info(" #{"Network Type:".ljust(25)} #{vmstatus["nic#{key}"]}", :prefix => false) 
						@env.ui.info(" #{"MAC Address:".ljust(25)} #{vmstatus["macaddress#{key}"]}", :prefix => false) 
						@env.ui.info(" #{"Cable connected:".ljust(25)} #{vmstatus["cableconnected#{key}"]}", :prefix => false) 
					end
				}
				
				@env.ui.info(" ")
				
				0
			end
		end
  end
end
