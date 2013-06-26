
require 'vagrant/plugin'
 

module Vagrant
  module NodeMaster
 
	class Command < Vagrant.plugin(2, :command)
		def initialize(argv, env)
			super

			@main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

#			puts "MAIN ARGS #{@main_args}"
#			puts "SUB COMMAND #{@sub_command}"
#			puts "SUB ARGS #{@sub_args}"

				@subcommands = Vagrant::Registry.new
#          @subcommands.register(:add) do
#            require File.expand_path("../add", __FILE__)
#            Add
#          end
#
#          @subcommands.register(:boxlist) do
#            require File.expand_path("../remoteboxlist", __FILE__)
#            BoxList
#          end
				
				@subcommands.register(:box) do
					require File.expand_path("../remote/remoteboxcommand", __FILE__)            
					BoxCommand
				end
				
				@subcommands.register(:up) do
					require File.expand_path("../remote/remoteup", __FILE__)
					UpVM
				end
				
				@subcommands.register(:halt) do
					require File.expand_path("../remote/remotehalt", __FILE__)
					HaltVM
				end
				
				@subcommands.register(:suspend) do
					require File.expand_path("../remote/remotesuspend", __FILE__)
					SuspendVM
				end
				
				@subcommands.register(:resume) do
					require File.expand_path("../remote/remoteresume", __FILE__)
					ResumeVM
				end
				
				@subcommands.register(:status) do
					require File.expand_path("../remote/remotevmstatus", __FILE__)
					StatusVM
				end
				
				@subcommands.register(:destroy) do
					require File.expand_path("../remote/remotedestroy", __FILE__)
					DestroyVM
				end
				
				@subcommands.register(:provision) do
					require File.expand_path("../remote/remoteprovision", __FILE__)
					ProvisionVM
				end

				@subcommands.register(:ssh) do
					require File.expand_path("../remote/remotessh", __FILE__)
					SSHVM
				end

				@subcommands.register(:snapshot) do
					require File.expand_path("../remote/remotesnapshotcommand", __FILE__)
					SnapshotCommand
				end
				
				@subcommands.register(:backup) do
					require File.expand_path("../remote/remotebackupcommand", __FILE__)            
					BackupCommand
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
            opts.banner = "Usage: vagrant remote <command> [<args>]"
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



		private
		def echoEnv
			puts "DEFAULT LOCAL DATA #{::Vagrant::Environment::DEFAULT_LOCAL_DATA}"			
			puts "VAGRANT FILE_NAME #{@env.vagrantfile_name}"
			puts "VAGRANT CONFIG GLOBAL #{@env.config_global}"
			puts "VAGRANT GEMS_PATH #{@env.gems_path}"
			puts "VAGRANT HOME_PATH #{@env.home_path}"
			puts "VAGRANT LOCAL_DATA_PATH #{@env.local_data_path}"
			puts "VAGRANT TMP_PATH #{@env.tmp_path}"					
			puts "VAGRANT UI_OBJ #{@env.ui}"
			puts "VAGRANT HOST_OBJ #{@env.host}"
			puts "VAGRANT CWD #{@env.cwd}"
			puts "VAGRANT LOCK_PATH #{@env.lock_path}"
			
		end
	end
  end
end
