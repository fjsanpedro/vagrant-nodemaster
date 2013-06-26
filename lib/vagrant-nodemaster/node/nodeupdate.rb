require 'vagrant-nodemaster/node/nodedbmanager'

module Vagrant
  module NodeMaster
  
		class NodeUpdate < Vagrant.plugin(2, :command)
#			def initialize(sub_args, env,db)
#					super(sub_args,env)					
#					@db=db
#			end
			def execute
					
					options = {}
					
					#TODO CAMBIAR LA FORMA DE INVOCAR A ESTE COMANDO PARA NO TENER
					#QUE INTRODUCIR TODOS LOS DATOS SI SE QUIERE MODIFICAR LA INFORMACION
					#DEL CLIENTE
					opts = OptionParser.new do |opts|
						opts.banner = "Usage: vagrant node update <node-name> <node-address> <node-port> --hostname"
						opts.on("--hostname", "Address in dns format") do |d|
							options[:dns] = d
						end
						
					end
					
					argv = parse_options(opts)
					return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 3
		  		
		  		dbmanager=DB::NodeDBManager.new	  		
		  		
		  				
		  		dbmanager.update_node(argv[0],argv[1],argv[2].to_i,options[:dns])
					
					0
			end
  
  	end
  
  
  
  end
end
