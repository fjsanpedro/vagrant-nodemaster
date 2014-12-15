require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
		class BoxAdd < Vagrant.plugin(2, :command)
			def execute
				options = {}
        options[:async] = true
	
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote box add <node-name> <box-name> <url> [--synchronous]"
					opts.separator ""
          opts.on("-s", "--synchronous", "Wait until the operation finishes") do |f|
            options[:async] = false
          end
				end
				
				
				argv = parse_options(opts)          
									
				return if !argv
				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3
		
				
				res = RequestController.box_add(argv[0],argv[1],argv[2],options[:async])
				
				@env.ui.success("Remote Client \"#{argv[0]}\": Box \"#{argv[1]}\" added") if options[:async]==false
 
				@env.ui.info("Remote Client \"#{argv[0]}\": The operation ID is \"#{res.gsub!(/\D/, "")}\"") if options[:async]==true

						
				0
			end
			
			
		end
  end
end
