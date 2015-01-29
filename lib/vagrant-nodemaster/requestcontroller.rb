require 'rest_client'

require 'pp'
require 'vagrant-nodemaster/apidesc'
require 'vagrant-nodemaster/node/nodedbmanager'

 

    
module Vagrant
module NodeMaster
    
    
    
	class RequestController
		include RestRoutes 
		GET_VERB = :get
		POST_VERB = :post
		DELETE_VERB = :delete
		PUT_VERB = :put
		SYNC_TIME = 10
		OPERATION_IN_PROGRESS = 100
		
		def self.box_downloads(host)
			client=get_host_parameters(host)
			resource = RestClient::Resource.new(
	          RouteManager.box_download_url(client[:address],client[:port])
	        )

	        response = execute(client,GET_VERB,resource);
	        JSON.parse(response.to_str,{:symbolize_names => true})
		end

		def self.get_remote_boxes(host)
			client=get_host_parameters(host)				

	        resource = RestClient::Resource.new(
	          RouteManager.box_list_url(client[:address],client[:port])
	        )
    
			response = execute(client,GET_VERB,resource);
			
			JSON.parse(response.to_str)
		end
		
		def self.box_delete(host,box,provider)
			client=get_host_parameters(host)
			
			
			resource = RestClient::Resource.new(
    		RouteManager.box_delete_url(client[:address],client[:port],box,provider)
    		)                                     
    
    		response = execute(client,DELETE_VERB,resource);

			JSON.parse(response.to_str)
			
		end
		
		def self.box_add(host,box,url,async=true)
			client=get_host_parameters(host)								
			
			resource = RestClient::Resource.new(
				RouteManager.box_add_url(client[:address],client[:port]),					
				:timeout => nil						
			)
			
			
    		response = execute(client,POST_VERB,resource,{:box => box,:url => url},async);        
    
			return JSON.parse(response.to_str) if async ==false
			
    		response
			
			
		end
		
		def self.vm_up(host,vmname,async=true)
			client=get_host_parameters(host)
			#Due to the fact that starting the machines can take long,
			#setting the request not to expire
			resource = RestClient::Resource.new(
				RouteManager.vm_up_url(client[:address],client[:port]),					
				:timeout => nil						
			)
			
								
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname},async);		  
		  	
			return JSON.parse(response.to_str) if async ==false
			response
			
		end
		
		def self.vm_halt(host,vmname,force,async=true)
			client=get_host_parameters(host)
			#Due to the fact that halting the machines can take long,
			#setting the request not to expire
			resource = RestClient::Resource.new(
				RouteManager.vm_halt_url(client[:address],client[:port]),
				:timeout => nil
			)
			
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname,:force=>force},async);
		  	
			return JSON.parse(response.to_str) if async ==false
    		response
			
		end
		
		def self.vm_destroy (host,vmname)
			client=get_host_parameters(host)
			
			resource = RestClient::Resource.new(
				RouteManager.vm_destroy_url(client[:address],client[:port]),
				:timeout => nil  				
			)
			
			
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname});
		  
			JSON.parse(response.to_str)
			
		end
		
  #Deletes from the remote node config the machine with name 'vmname'
		def self.vm_delete(host,vmname,remove=false)
			client=get_host_parameters(host)
		  
		  
		  
			resource = RestClient::Resource.new(
      			RouteManager.vm_delete_url(client[:address],client[:port],vmname),:payload => { :remove => remove }
    		)                                     
    
    		execute(client,DELETE_VERB,resource);
    
		end
		
		
		def self.vm_add(host,config,rename=false)
		    client=get_host_parameters(host)
		    
		    resource = RestClient::Resource.new(
		      RouteManager.vm_add_url(client[:address],client[:port]),
		      :timeout => nil ,
		      # :payload => {
		        # :content_type => 'text/plain',
		        # :file => File.new(config, 'rb')
		      # }         
		    )       
		     
		    execute(client,PUT_VERB,resource,{:file => File.read(config), :content_type => 'text/plain',:rename => rename})
		
		end

		
		def self.vm_status(host,vmname)
			client=get_host_parameters(host)
			
			#get_vm_status(client[:address],client[:port],vmname)				
			get_vm_status(client,vmname)
			
		end

		def self.vm_info(host,vmname)
			client=get_host_parameters(host)
			

			resource = RestClient::Resource.new(
        		RouteManager.vm_info_url(client[:address],client[:port],vmname)      
    		)  

			response = execute(client,GET_VERB,resource);
							
			JSON.parse(response.to_str)
			
		end


		
		def self.vm_ssh_config(host,vmname)
			client=get_host_parameters(host)
			
							
			resource = RestClient::Resource.new(
      			RouteManager.vm_sshconfig_url(client[:address],client[:port],vmname)
    		)
    
			response = execute(client,GET_VERB,resource);
    		result=JSON.parse(response.to_str, {:symbolize_names => true})									
			
			
			#Change the target machine
			result[:host]=client[:address]
			
			result
		end
		
		
		def self.vm_suspend(host,vmname,async=true)
			client=get_host_parameters(host)
			#Due to the fact that suspending the machines can take long,
			#setting the request not to expire
			resource = RestClient::Resource.new(
				RouteManager.vm_suspend_url(client[:address],client[:port]),					
				:timeout => nil						
			)
			
								
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname},async);
		  
			return JSON.parse(response.to_str) if async ==false
    		response
			
		end
		
		def self.vm_resume(host,vmname,async=true)
			client=get_host_parameters(host)
			#Due to the fact that resuming the machines can take long,
			#setting the request not to expire
			resource = RestClient::Resource.new(
				RouteManager.vm_resume_url(client[:address],client[:port]),					
				:timeout => nil						
			)				
			
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname},async);
		  
			return JSON.parse(response.to_str) if async ==false
    		response
			
		end
		
		
		def self.vm_provision(host,vmname,async=true)
			client=get_host_parameters(host)
			#Due to the fact that provisioning the machines can take long,
			#setting the request not to expire
			resource = RestClient::Resource.new(
				RouteManager.vm_provision_url(client[:address],client[:port]),					
				:timeout => nil						
			)				
			
								
		  	response = execute(client,POST_VERB,resource,{:vmname => vmname},async);
		  
			return JSON.parse(response.to_str) if async ==false
    		response
			
		end
		
		def self.get_remote_snapshots(host,vmname)
		  			
			client=get_host_parameters(host)
			
			resource = RestClient::Resource.new(
        		RouteManager.snapshot_list_url(client[:address],client[:port],vmname)
    		)     
    
    
    		response = execute(client,GET_VERB,resource);
			
			JSON.parse(response.to_str,{:symbolize_names => true})
			# return JSON.parse(response.to_str,{:symbolize_names => true}) if async ==false
    		# response
			
		end
		
		def self.vm_snapshot_take(host,vmname,sname,sdesc,async=true)
			client=get_host_parameters(host)
				
			#Due to the fact that taking the snapshot can take long,
			#setting the request not to expire
				
			resource = RestClient::Resource.new(
				RouteManager.vm_snapshot_take_url(client[:address],client[:port],vmname),					 					
				:timeout => nil,											
			)				

    
			response = execute(client,POST_VERB,resource,{:vmname => vmname,:name => sname,:desc => sdesc},async);
			
			#JSON.parse(response.to_str,{:symbolize_names => true})
			return JSON.parse(response.to_str,{:symbolize_names => true}) if async ==false
    		response
			
		end
		
		def self.vm_snapshot_delete(host,vmname,snapid)
		    client=get_host_parameters(host)  
		    
		    #Due to the fact that deleting the snapshot can take long,
		    #setting the request not to expire                  
		    resource = RestClient::Resource.new(
		      RouteManager.vm_snapshot_delete_url(client[:address],client[:port],vmname,snapid),                   
		      :timeout => nil,                     
		    )       

		            
		    response = execute(client,DELETE_VERB,resource);
		    
		    # JSON.parse(response.to_str,{:symbolize_names => true})
		    
		end
		
		
		def self.vm_snapshot_restore(host,vmname,snapid,async=true)
		  
			client=get_host_parameters(host)
						
			resource = RestClient::Resource.new(
				RouteManager.vm_snapshot_restore_url(client[:address],client[:port],vmname),					
				:timeout => nil						
			)
			
			response = execute(client,POST_VERB,resource,{:vmname => vmname,:snapid => snapid},async);
			
			
			#JSON.parse(response.to_str,{:symbolize_names => true})
			return JSON.parse(response.to_str,{:symbolize_names => true}) if async ==false
    		response
		end
		
		
		def self.node_operation_queued(host,id)			  
		  	client=get_host_parameters(host)
		  	resource = RestClient::Resource.new(
        		RouteManager.node_queue_url(client[:address],client[:port],id)
   		 	)
    
    		response = execute(client,GET_VERB,resource);
    
    		JSON.parse(response.to_str,{:symbolize_names => true})
		end
		
		def self.node_operation_queued_last(host)
		  	client=get_host_parameters(host)
    		resource = RestClient::Resource.new(
        		RouteManager.node_queue_last_url(client[:address],client[:port])
    		)
    
    		response = execute(client,GET_VERB,resource);
    
    		JSON.parse(response.to_str,{:symbolize_names => true})
		end
		
		def self.node_backup_take(ui,target_dir,host=nil,vmname=nil)				
			
			current_client=nil
			current_file = nil
			download_backup = false
			
			begin
				
				raise "Directory \"#{target_dir}\" does not exists" if target_dir && !File.directory?(target_dir)
			
				download_backup = true if target_dir
				
				clients = []
				if (host)
					clients << get_host_parameters(host)
				else
				  #FIXME QUITAR ESTO DE AQUI
					#@dbmanager=DB::NodeDBManager.new if !@dbmanager
					clients = DB::NodeDBManager.get_nodes
				end
			
				clients.each do |client|				
					current_client=client
					#Fist get remote virtual machines
					vms=get_vm_status(client,vmname)
					
					
					vms.each do |vm|
						
						th = nil
						if (ui)
							th = Thread.new(ui) do |ui|									
									draw_progress(ui,download_backup,client[:name],vm["name"])
							end
						end
					


						resource = RestClient::Resource.new(
								RouteManager.vm_snapshot_take_url(client[:address],client[:port],vm["name"]),
								:download => download_backup,					
								:timeout => nil						
						)
					
					#OLD. FIXME REMOVE
						#response = resource.get({:params => {'download' => download_backup}})
						response = execute(client,GET_VERB,resource,:params => {'download' => download_backup});					
						
						th.kill if th
						
						if response.code==200  
							if download_backup && response.headers[:content_type]=="Application/octet-stream"  

								time = Time.now
								
								basename = "Backup.#{client[:name]}.#{vm["name"]}.#{time.year}.#{time.month}.#{time.day}.#{time.hour}.#{time.min}.#{time.sec}"
								current_file = "#{target_dir}/#{basename}.zip"
								File.open(current_file, "w") do |f|
										f.write(response.body)
								end				 
								
								current_file=""		
								#FIXME DELETE If we want to use the filename of the attachment
#									if response.headers[:content_disposition] =~ /^attachment; filename=\"(.*?)\"$/										
#										current_file = "#{target_dir}/#{$1}"
#										File.open(current_file, "w") do |f|
#											f.write(response.body)
#										end				 
#										current_file=""
#									end
							end
							
							ui.success("OK") if ui
								
						end
						
					end
					
				end
				
			rescue RestClient::ResourceNotFound => e
				ui.error("Remote Client \"#{current_client[:name]}\": Box \"#{vmname}\" could not be found") if ui					
			rescue Exception => e					
				ui.error("ERROR: "+e.message) if ui
				#Checking that the tmp file is removed
				File.delete(current_file) if current_file && File.exists?(current_file)				
			end	
			
		end
		
		def self.node_backup_log(ui,node,vmname=nil)
			
			raise "Error finding the node" if node==nil
			
			client = get_host_parameters(node)
			
			resource = RestClient::Resource.new(
					RouteManager.backup_log_url(client[:address],client[:port],vmname),					
					:timeout => nil
			)
	
	    
				
	    	response = execute(client,GET_VERB,resource,:vmname => vmname);
	    
			JSON.parse(response.to_str)
			
		end
		
		def self.node_info(node)
			raise "Please enter a valid node" if node==nil
			client=get_host_parameters(node)

			resource = RestClient::Resource.new(
        		RouteManager.node_info_url(client[:address],client[:port]),:timeout => nil                        
    		) 

			response=execute(client,GET_VERB,resource);

			

    		JSON.parse(response.to_str,{:symbolize_names => true})

		end


		def self.node_config_show(node)
		  	raise "Please enter a valid node" if node==nil
		  	client=get_host_parameters(node)
		  
		  
		  	resource = RestClient::Resource.new(
        		RouteManager.config_show_url(client[:address],client[:port]),:timeout => nil                        
    		)   

    			  
		  	execute(client,GET_VERB,resource);
		  
		end
		
		
		
		def self.node_config_upload(node,config_path)        
		    client=get_host_parameters(node)
		    
		    
		    resource = RestClient::Resource.new(
		        RouteManager.config_upload_url(client[:address],client[:port]),         
		        :timeout => nil                        
		    )    
		    
		    execute(client,POST_VERB,resource,{:file => File.read(config_path), :content_type => 'text/plain'})
		    
		end
		
		
		def self.node_password_change(node,password)
		  	client=get_host_parameters(node)
    
    
    		resource = RestClient::Resource.new(
        		RouteManager.node_password_change_url(client[:address],client[:port]),:timeout => nil                        
    		)
    
    		execute(client,POST_VERB,resource,{:password => Digest::MD5.hexdigest(password)});
    
		end
		
		
		private
		
		def self.execute(host,http_method,resource,params=nil,async=true)
		  client = login(host)
		  
		  #FIXME AÑADIR AQUI GESTION DE ERRORES
		  #SI NO HAY COOKIE
		  #SI NO HAY TOKEN
		  #Y EnVIAR DESDE SERVeR ALGUNA EXECPCION 
		  #PARA MONITORIZAR LA FALTA DE ALGUN PARAMETRO Y REPETIR LA TRANSACCION
		  resource.options[:headers] = { :content_md5 => CGI.escape(client[:token]),
		                                 :cookies => client[:cookies]
		                               }
		  
		  data= {}			    			  
		  
		  data.merge!(params) if params!=nil			  
		  
		  
		  
		  #response = resource.send http_method.to_sym, :content_md5 => client[:token], :cookies => client[:cookies]
		  
		  response = resource.send http_method.to_sym, data			  
		  
		  if response.code == 202 && async==false
		      #Getting the location operation id
	    	opid = response.gsub!(/\D/, "")
		      
	      	begin
		      sleep SYNC_TIME
		      client1 = login(host)			    
		      resourceop = RestClient::Resource.new(
        		RouteManager.node_queue_url(client1[:address],client1[:port],opid)
      			)
      
      			resourceop.options[:headers] = { :content_md5 => CGI.escape(client1[:token]),
                		                       :cookies => client1[:cookies]
                  }

		      responseop = resourceop.send GET_VERB
      
      		  res = JSON.parse(responseop.to_str)
            
  			end while (res[0] == OPERATION_IN_PROGRESS) #While operation code is IN PROGRESS iterate
                                 
      		res[1]       
		     
		  else
		    response  
		  end
		  			  
		end
		
		
		
		def self.login(host)			  
		  
		  response = RestClient.get RouteManager.login_url(host[:address],host[:port])
		  
		  host[:token] = Digest::MD5.hexdigest(response.headers[:content_md5]+host[:password])
		  host[:cookies] = response.cookies			  
		  
		  host
		end
		
		def self.get_host_parameters(host)
		
			#@dbmanager=DB::NodeDBManager.get_reference if !@dbmanager				
			DB::NodeDBManager.get_node(host)
				
		end
		
		def self.get_vm_status(client,vmname)
    
			resource = RestClient::Resource.new(
        		RouteManager.vm_status_url(client[:address],client[:port],vmname)      
    		)  

			response = execute(client,GET_VERB,resource);
							
			JSON.parse(response.to_str)
			
		end

		
		
		def self.draw_progress(ui,download,node,vmname)
			return if !ui
			ui.info("Downloading ",:new_line => false) if download
			ui.info("Waiting for ",:new_line => false) if !download
			
			ui.info("backup of Virtual Machine \'#{vmname}\' from Node \'#{node}\' . . .  ",:new_line => false)
			
			val=0
			while true
				sleep(0.1)
	
				case val
				when 0 then
					ui.info("|\b",:new_line => false)
				when 1 then
					ui.info("/\b",:new_line => false)
				when 2 then
					ui.info("-\b",:new_line => false)
				when 3 then
					ui.info("\\\b",:new_line => false)
				end
				val=val+1
				
				val=0 if val==4
			end
		end
		
		
	end
end
end

