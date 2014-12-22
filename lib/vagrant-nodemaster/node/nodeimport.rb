require 'vagrant-nodemaster/node/nodedbmanager'
require 'pp'

module Vagrant
  module NodeMaster
  
		class NodeImport < Vagrant.plugin(2, :command)

			def execute
					
				options = {}

				options[:raw] = false
				options[:sample] = false
				
				opts = OptionParser.new do |opts|
					opts.banner = "Usage: vagrant node import <file>"						
					opts.separator ""
					opts.on("-r", "--raw", "Import file exactly. Used when file has encoded md5 passwords ") do |f|
		              options[:raw] = true
		           	end
		           	opts.on("-s", "--sample", "Writes a sample export file") do |f|
		              options[:sample] = true
		           	end
				end
				
				argv = parse_options(opts)				
				return if !argv
		  		raise Vagrant::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length != 1
		  		
		  		if (!options[:sample])		  			
		  			if !File.exist?(argv[0])
		  				@env.ui.error("The file does not exist")
		  			else
		  				#FILE IMPORT
		  				#CHECK IF RAW IMPORT OR NOT
		  				File.foreach(argv[0]).with_index { |line, line_num|
							if (line_num>0)
								
								line = line.gsub("\n",'')								
								parts=line.split(",") 
								#0 => node name
								#1 => node address
								#2 => node port
								#3 => node password								
								
								begin

									DB::NodeDBManager.import_node(parts[0],parts[1],parts[2].to_i,parts[3],options[:raw])
								
								rescue Exception => e
									if e.class == SQLite3::ConstraintException
										@env.ui.error("Error importing node '#{parts[0]}': There is a node with the same name")
									else 
										@env.ui.error("Error importing node '#{parts[0]}': "+e.message)
									end
								end
							end
						}
		  			end
		  		else
		  			#USER WANTS TO WRITE A SAMPLE FILE
		  			
		  			#CHECK IF THE FILE EXISTS, SHOWING OVERWRITE QUESTION
		  			if File.exist?(argv[0])
		  				choice = @env.ui.ask("The file already exists, Do you really want to overwrite [N/Y]? ")

		  				if (!choice || choice.upcase != "Y" )									
							return 0				
						end
		  			end		  			



					$samplecontent = "\"Node Name\",\"Node Address\",\"Node Port\",\"Node Password\"\n"
					$samplecontent << "examplenode,127.0.0.1,3333,examplepassword\n";
					
					
					File.write(argv[0], $samplecontent)

		  		end
		  		
		  		
		  		
					
				0
			end
  
  	end
  
  end
end
