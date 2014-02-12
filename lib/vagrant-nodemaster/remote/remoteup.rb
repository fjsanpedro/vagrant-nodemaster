require 'optparse'
require 'vagrant-nodemaster/requestcontroller'
module Vagrant
  module NodeMaster
	class UpVM < Vagrant.plugin(2, :command)
		def execute
	        options = {}          
          options[:async] = true
          
          opts = OptionParser.new do |opts|
            opts.banner = "Usage: vagrant remote up <node-name> [vm_name] [--synchronous]"
            opts.separator ""
            opts.on("-s", "--synchronous", "Wait until the operation finishes") do |f|
              options[:async] = false
            end
          end
          
          argv = parse_options(opts)
          return if !argv  
          raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length < 1 || argv.length > 2)
          
          		
					machines=RequestController.vm_up(argv[0],argv[1],options[:async])
          			  	
          if options[:async] == false		
  					machines.each do |machine|
  						@env.ui.success("Remote Client \"#{argv[0]}\": Virtual Machine \"#{machine["vmname"]}\" launched")
  					end          				
  										
  					@env.ui.info(" ")
					else
			       @env.ui.info("Remote Client \"#{argv[0]}\": The operation ID is \"#{machines.gsub!(/\D/, "")}\"")
					end          		         		
          
        end
        
	end
  end
end
