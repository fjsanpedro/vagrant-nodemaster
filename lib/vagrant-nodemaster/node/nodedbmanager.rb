require 'sqlite3'

module Vagrant
	module NodeMaster
		module DB
			class ClientDBManager
				
				def initialize					
					@db=check_database					
				end
				
				def add_client(client_name,client_address,client_port,dnsformat)
					
					if (!portvalid?(client_port))		
						raise "Client port must be above 1023"
					end
					
					
					if (!namevalid?(client_name))
						raise "Client name Invalid (Spectial characters allowed: '_' and '-')." 
					end
					
					if (dnsformat && !dnsvalid?(client_address)) || 
						(!dnsformat && !ipvalid?(client_address))						
					
						raise "Invalid ip or dns address."
						 
					end				
														
					
					sql="INSERT INTO #{TABLE_NAME} VALUES ( ? , ? , ?)"
					@db.execute(sql,client_name,client_address,client_port)
					
				end
				
				def update_client(client_name,client_address,client_port,dnsformat)
					
					if (!portvalid?(client_port))						
					
						raise "Client port must be above 1023"
						 
					end
					
					if (dnsformat && !dnsvalid?(client_address)) || 
						(!dnsformat && !ipvalid?(client_address))						
					
						raise "Invalid ip or dns address."
						 
					end			
					
					sql="UPDATE #{TABLE_NAME} SET #{CLIENT_ADDRESS_COLUMN} = ?,#{CLIENT_PORT_COLUMN} = ?  WHERE #{CLIENT_NAME_COLUMN}= ?"
					@db.execute(sql,client_address,client_port,client_name)
					
				end
				

				
				
				def remove_client(client_name)
					sql="DELETE FROM #{TABLE_NAME} WHERE #{CLIENT_NAME_COLUMN}=?"
					@db.execute(sql,client_name)
				end
				
				def remove_clients
					sql="DELETE FROM #{TABLE_NAME}"
					@db.execute(sql)
				end

				
				def get_client_names
					sql="SELECT #{CLIENT_NAME_COLUMN} FROM #{TABLE_NAME}"
					return @db.execute(sql);
				end				
				
				def get_clients
					sql="SELECT * FROM #{TABLE_NAME}"
					return @db.execute(sql);
				end
				
				def get_client(client_name)
					sql="SELECT * FROM #{TABLE_NAME} WHERE #{CLIENT_NAME_COLUMN}=?"
					raise "Client not found" if (clientar=@db.execute(sql,client_name)).empty?
					client = {}
					client[:name]=clientar[0][0]
					client[:address]=clientar[0][1]
					client[:port]=clientar[0][2]
					return client
				end
				
				private
			
				TABLE_NAME='client_table'
				CLIENT_NAME_COLUMN = 'client_name'
				CLIENT_ADDRESS_COLUMN = 'client_address'
				CLIENT_PORT_COLUMN = 'client_port'
				
				def check_database					
					#Creates and/or open the database
					db = SQLite3::Database.new( "/tmp/test.db" )
									
					if db.execute("SELECT name FROM sqlite_master 
											 WHERE type='table' AND name='#{TABLE_NAME}';").length==0						
#						db.execute( "create table '#{TABLE_NAME}' (id INTEGER PRIMARY KEY AUTOINCREMENT, 
#												{CLIENT_NAME_COLUMN} TEXT, #{CLIENT_ADDRESS_COLUMN} TEXT);" )				
						db.execute( "create table '#{TABLE_NAME}' (#{CLIENT_NAME_COLUMN} TEXT PRIMARY KEY, 
												 																#{CLIENT_ADDRESS_COLUMN} TEXT NOT NULL,
												 																#{CLIENT_PORT_COLUMN} INTEGER NOT NULL);" )
					end
					return db
				end
		
				def ipvalid?(client_address)
						
						ipreg= '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
						
						
						ipregex = Regexp.new(ipreg)
						

						if (client_address =~ ipregex) 
							return true
						end
						
						return false 
						
				end
				
				def dnsvalid?(client_address)
						
						
						hostreg='^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
						
						
						hregex = Regexp.new(hostreg)

						if (client_address =~ hregex)
							return true
						end
						
						return false 
						
				end
				
						
				def namevalid?(client_name)
					#only allowing '_' and '-'
					namereg = '^[a-z0-9_-]*$'
					nameregex = Regexp.new(namereg)
					if (client_name =~nameregex)
						return true
					end
						return false
						
				end
				
				def portvalid?(client_port)
					if (client_port>=1024)
						return true
					end
					return false
				end
						
			end
		end
	end
end
