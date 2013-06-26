require 'vagrant-nodemaster/node/nodedbmanager'

module Vagrant
  module NodeMaster
  
		class NodeList < Vagrant.plugin(2, :command)
			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node list"
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 0
		  		
		  		dbmanager=DB::NodeDBManager.new
		  		
		  		@env.ui.info("#{"NODE".ljust(25)} ADDRESS (PORT) ",:prefix => false)
					dbmanager.get_nodes.each do |entry|
						@env.ui.info("#{entry[:name].ljust(25)} #{entry[:address]}(#{entry[:port]})", :prefix => false) 
					end
					@env.ui.info(" ", :prefix => false)
					0
			end
  
  	end
  
  
  
  end
end
