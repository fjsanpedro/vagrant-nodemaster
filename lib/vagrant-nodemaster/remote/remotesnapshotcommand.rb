
require 'vagrant/plugin'
 

module Vagrant
  module NodeMaster
 
	class SnapshotCommand < Vagrant.plugin(2, :command)
		def initialize(argv, env)
          super

          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

			puts "MAIN ARGS #{@main_args}"
			puts "SUB COMMAND #{@sub_command}"
			puts "SUB ARGS #{@sub_args}"

          @subcommands = Vagrant::Registry.new
#          @subcommands.register(:add) do
#            require File.expand_path("../add", __FILE__)
#            Add
#          end
#
          @subcommands.register(:list) do
            require File.expand_path("../remotesnapshotlist", __FILE__)
            SnapshotList
          end
          
          @subcommands.register(:take) do
            require File.expand_path("../remotesnapshottake", __FILE__)
            SnapshotTake
          end
          
          @subcommands.register(:restore) do
            require File.expand_path("../remotesnapshotrestore", __FILE__)
            SnapshotRestore
          end
          
#          @subcommands.register(:add) do
#            require File.expand_path("../remoteboxadd", __FILE__)
#            BoxAdd
#          end
#          
#          @subcommands.register(:remove) do
#            require File.expand_path("../remoteboxremove", __FILE__)
#            BoxRemove
#          end
          
        
        end

		def execute
#			if @main_args.include?("-h") || @main_args.include?("--help")
#				 Print the help for all the box commands.
#				return help
#			end
			
			# If we reached this far then we must have a subcommand. If not,
			# then we also just print the help and exit.
			command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
			return help if !command_class || !@sub_command
			
			@logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")
			
			begin	
				# Initialize and execute the command class
				command_class.new(@sub_args, @env).execute
			rescue RestClient::RequestFailed => e
				@env.ui.error("Remote Client \"#{@sub_args[0]}\": Request Failed")
			rescue RestClient::ResourceNotFound => e          
				@env.ui.error("Remote Client \"#{@sub_args[0]}\": Virtual Machine \"#{@sub_args[1]}\" could not be found")
			rescue RestClient::ExceptionWithResponse=> e          
				@env.ui.error(e.response)
			rescue Exception => e
				@env.ui.error(e.message)
			end
			

			
		end
		
		def help
          opts = OptionParser.new do |opts|
            opts.banner = "Usage: vagrant remote snapshot <command> [<args>]"
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
            opts.separator "For help on any individual command run `vagrant remote COMMAND -h`"
          end

          @env.ui.info(opts.help, :prefix => false)
        end
		
	end
  end
end
