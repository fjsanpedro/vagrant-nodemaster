require 'vagrant/plugin'
require 'sqlite3'
require 'vagrant-nodemaster/node/nodedbmanager' 

module Vagrant
  module NodeMaster
   
		class Command < Vagrant.plugin(2, :command)
			
			def initialize(argv, env)
				super
				
				@main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)
				
				#Initializing db structure
        		DB::NodeDBManager.new(@env.data_dir)
				
#				puts "MAIN ARGS #{@main_args}"
#				puts "SUB COMMAND #{@sub_command}"
#				puts "SUB ARGS #{@sub_args}"
				
				@subcommands = Vagrant::Registry.new
				
				@subcommands.register(:list) do
					require File.expand_path("../node/nodelist", __FILE__)
					NodeList
				end       
				
				@subcommands.register(:add) do
					require File.expand_path("../node/nodeadd", __FILE__)
					NodeAdd
				end
				
				@subcommands.register(:remove) do
					require File.expand_path("../node/noderemove", __FILE__)
					NodeRemove
				end
			
				@subcommands.register(:update) do
					require File.expand_path("../node/nodeupdate", __FILE__)
					NodeUpdate
				end

				@subcommands.register(:info) do
					require File.expand_path("../node/nodeinfo", __FILE__)
					NodeInfo
				end
				
				@subcommands.register(:updatepw) do
		          require File.expand_path("../node/nodeupdatepw", __FILE__)
		          NodeUpdatePw
		        end

				@subcommands.register(:status) do
					require File.expand_path("../node/nodestatus", __FILE__)
					NodeStatus
				end
				
				@subcommands.register(:operation) do
		          require File.expand_path("../node/nodeoperationcommand", __FILE__)
		          NodeOperationCommand
		        end


				@subcommands.register(:import) do
		          require File.expand_path("../node/nodeimport", __FILE__)
		          NodeImport
		        end
				
			end

			
			
			
			
			def execute
				if @main_args.include?("-h") || @main_args.include?("--help")
					# Print the help for all the box commands.
					return help
				end
				
				
				
			  # If we reached this far then we must have a subcommand. If not,
				# then we also just print the help and exit.
				command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
				return help if !command_class || !@sub_command
				@logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")	  
			  
			  begin
					# Initialize and execute the command class
					command_class.new(@sub_args, @env).execute
				rescue Exception => e
					@env.ui.error(e.message)
				end
			  
    
				0
			end
			
			def help
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant node <command> [<args>]"
					opts.separator ""
					opts.separator "Available subcommands:"
			
					# Add the available subcommands as separators in order to print them
					# out as well.
					keys = []
					@subcommands.each { |key, value| keys << key.to_s }
			
					keys.sort.each do |key|
						opts.separator "     #{key}"
					end
			
					opts.separator ""
					opts.separator "For help on any individual command run `vagrant node COMMAND -h`"
				end
			
				@env.ui.info(opts.help, :prefix => false)
			end
			
			
		end
		
	end
end
