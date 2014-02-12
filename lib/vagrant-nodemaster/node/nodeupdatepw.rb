require 'vagrant-nodemaster/node/nodedbmanager'
require 'vagrant-nodemaster/requestcontroller'

module Vagrant
  module NodeMaster
  
		class NodeUpdatePw < Vagrant.plugin(2, :command)
			def execute
					
					options = {}
					options[:remote] = false
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node updatepw <node-name> --remote"
						opts.on("--remote", "Change also remote node pasword") do |r|
							options[:remote] = r
						end
						
					end
					
					argv = parse_options(opts)
					
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		  		
		  		
		  		
		  		
		  		pass_m = "Insert your new password for the Node #{argv[0]}: "
          confirm_m = "Please Insert again the new password: "
          
          if STDIN.respond_to?(:noecho)
            print pass_m
            password=STDIN.noecho(&:gets).chomp
            print "\n#{confirm_m}"
            confirm=STDIN.noecho(&:gets).chomp
            print "\n"
          else            
            password = @env.ui.ask(pass_m)
            confirm = @env.ui.ask(confirm_m)
          end

          
          raise "Passwords does not match!" if (password!=confirm)
          
          
          #First, change Password at remote node
          if (options[:remote])             
             if (!RequestController.node_password_change(argv[0],password))
              @env.ui.error("Remote password change failed! No changes have been comitted locally")  
              return             
             end
          end
         
          #If everything is ok then change the password locally
 		  		#db=DB::NodeDBManager.new
		  		DB::NodeDBManager.update_node_password(argv[0],password)
		  		
		  		if options[:remote]
            @env.ui.success("Password change performed successfully locally and remotely")
          else
            @env.ui.success("Password change performed successfully locally")
          end
					
					0
			end
  
  	end
  
  
  
  end
end
