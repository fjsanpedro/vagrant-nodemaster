require 'optparse'
require 'vagrant-nodemaster/requestcontroller'

require "vagrant/util/ssh"

module Vagrant
	module NodeMaster
		class SSHVM < Vagrant.plugin(2, :command)
			include Vagrant::Util
			def execute
				options = {}
				options[:force] = false

				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant remote ssh <node-name> <vm_name> [-h]"
					
				end


				argv = parse_options(opts)         
				return if !argv

				raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if (argv.length != 2)


				#begin
				
				#Gettting SSH Config for vm. Inside this machine, the parameter
				#port is one that will be used at the client to make the redirection
				#to the virtual machine 
				vminfo=RequestController.vm_ssh_config(argv[0],argv[1])
								
				raise Errors::SSHNotReady if vminfo.nil?
				
				SSH.exec(vminfo)
				
				
#				rescue RestClient::RequestFailed => e
#					@env.ui.error("Remote Client \"#{argv[0]}\": Request Failed")
#				rescue RestClient::ResourceNotFound => e          
#					@env.ui.error("Remote Client \"#{argv[0]}\": Virtual Machine \"#{argv[1]}\" could not be found")
#				rescue RestClient::ExceptionWithResponse=> e          
#					@env.ui.error(e.response)
#				rescue Exception => e					
#					@env.ui.error(e.message)
#				end
				
				0



			end
		end
	end
end
