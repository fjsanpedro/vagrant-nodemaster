require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class BoxList < Vagrant.plugin(2, :command)
			def execute
				options = {}
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote box list <client-name>"
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		
				
					
					
				boxes = RequestController.get_remote_boxes(argv[0])			
							
				@env.ui.info("Remote Client: #{argv[0]}", :prefix => false)
				boxes.each { |box|  @env.ui.info(" * #{box["name"]} , (#{box["provider"]})", :prefix => false) }
				
						
				0
			end
			
			
		end
  end
end
