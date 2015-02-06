require 'vagrant-nodemaster/node/nodedbmanager'
require 'socket'
require 'timeout'

module Vagrant
  module NodeMaster
  
		class NodeStatus < Vagrant.plugin(2, :command)

			def execute
					
					options = {}
					
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node status"
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 0
		  		
		  		#dbmanager=DB::NodeDBManager.new

					status = {}



					DB::NodeDBManager.get_nodes.each do |entry|							
							status[entry[:name]]=ERROR
							if port_open?(entry[:address],entry[:port])
								status[entry[:name]]=OK
							end
					end
					
					
					#@env.ui.info("Client Status:", :prefix => false)
					@env.ui.info("#{"NODE".ljust(25)} STATUS ",:prefix => false)
					status.each do |name,status|
							@env.ui.info("#{name.ljust(25)} #{status}",:prefix => false)
					end
					
					@env.ui.info(" ",:prefix => false)
					
					0
			end
			
			
			private
			OK="LISTENING"
			ERROR= "HOST DOWN"
			
			def port_open?(ip, port, seconds=1)
				begin
					Timeout::timeout(seconds) do
						begin
							TCPSocket.new(ip, port).close
							true
						rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
							false
						end
					end
		
				rescue Timeout::Error
					false
				end
			end
  
  	end
  
  
  
  end
end
