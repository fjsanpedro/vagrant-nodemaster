require 'rest_client'

require 'pp'
require 'vagrant-nodemaster/apidesc'
require 'vagrant-nodemaster/node/nodedbmanager'

module Vagrant
  module NodeMaster
		class RequestController
			include RestRoutes 
			
			def self.get_remote_boxes(host)
				client=get_host_parameters(host)				
																			
				response = RestClient.get RouteManager.box_list_url(client[:address],client[:port])
				JSON.parse(response.to_str)
			end
			
			def self.box_delete(host,box,provider)
				client=get_host_parameters(host)				
																			
				response = RestClient.delete RouteManager.box_delete_url(client[:address],client[:port],box,provider)

				JSON.parse(response.to_str)
				
			end
			
			def self.box_add(host,box,url)
				client=get_host_parameters(host)								
				
				resource = RestClient::Resource.new(
					RouteManager.box_add_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :box => box,:url => url

				JSON.parse(response.to_str)
				
			end
			
			def self.vm_up(host,vmname)
				client=get_host_parameters(host)
				#Due to the fact that starting the machines can take long,
				#setting the request not to expire
				resource = RestClient::Resource.new(
					RouteManager.vm_up_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				JSON.parse(response.to_str)
				
			end
			
			def self.vm_halt(host,vmname,force)
				client=get_host_parameters(host)
				#Due to the fact that halting the machines can take long,
				#setting the request not to expire
				resource = RestClient::Resource.new(
					RouteManager.vm_halt_url(client[:address],client[:port]),
					:timeout => -1
				)
				
				response = resource.post :vmname => vmname,:force=>force
			
				JSON.parse(response.to_str)
				
			end
			
			def self.vm_destroy (host,vmname)
				client=get_host_parameters(host)
				resource = RestClient::Resource.new(
					RouteManager.vm_destroy_url(client[:address],client[:port]),
					:timeout => -1  				
				)
				
				response = resource.post :vmname => vmname
			
				JSON.parse(response.to_str)
				
			end
			
			
			
			def self.vm_status(host,vmname)
				client=get_host_parameters(host)
				
				get_vm_status(client[:address],client[:port],vmname)				
				
			end
			
			def self.vm_ssh_config(host,vmname)
				client=get_host_parameters(host)
				
				response = RestClient.get RouteManager.vm_sshconfig_url(client[:address],client[:port],vmname)					
				
				result=JSON.parse(response.to_str, {:symbolize_names => true})
				#Change the target machine
				result[:host]=client[:address]
				
				result
			end
			
			
			def self.vm_suspend(host,vmname)
				client=get_host_parameters(host)
				#Due to the fact that suspending the machines can take long,
				#setting the request not to expire
				resource = RestClient::Resource.new(
					RouteManager.vm_suspend_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				JSON.parse(response.to_str)
				
			end
			
			def self.vm_resume(host,vmname)
				client=get_host_parameters(host)
				#Due to the fact that resuming the machines can take long,
				#setting the request not to expire
				resource = RestClient::Resource.new(
					RouteManager.vm_resume_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				JSON.parse(response.to_str)
				
			end
			
			
			def self.vm_provision(host,vmname)
				client=get_host_parameters(host)
				#Due to the fact that provisioning the machines can take long,
				#setting the request not to expire
				resource = RestClient::Resource.new(
					RouteManager.vm_provision_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				JSON.parse(response.to_str)
				
			end
			
			def self.get_remote_snapshots(host,vmname)				
				client=get_host_parameters(host)			
				
				url=RouteManager.snapshot_list_url(client[:address],client[:port],vmname)

				response = RestClient.get url
				
				
				JSON.parse(response.to_str,{:symbolize_names => true})
				
			end
			
			def self.vm_snapshot_take(host,vmname,sname,sdesc)
				client=get_host_parameters(host)	
				#Due to the fact that taking the snapshot can take long,
				#setting the request not to expire		
				resource = RestClient::Resource.new(
					RouteManager.vm_snapshot_take_url(client[:address],client[:port],vmname),					
					:timeout => -1						
				)
				response = resource.post :vmname => vmname,:name => sname,:desc => sdesc
				
				JSON.parse(response.to_str,{:symbolize_names => true})
				
			end
			
			def self.vm_snapshot_restore(host,vmname,snapid)
				client=get_host_parameters(host)			
				resource = RestClient::Resource.new(
					RouteManager.vm_snapshot_restore_url(client[:address],client[:port],vmname),					
					:timeout => -1						
				)
				response = resource.post :vmname => vmname,:snapid => snapid
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
						dbmanager=DB::NodeDBManager.new
						clients = dbmanager.get_nodes
					end
				
					clients.each do |client|				
						current_client=client
						#Fist get remote virtual machines
						vms=get_vm_status(client[:address],client[:port],vmname)
						
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
									:timeout => -1						
							)
    					
							response = resource.get({:params => {'download' => download_backup}})					
							
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
				clients = []
				
				
				raise "Error finding the node" if node==nil
				
				client = get_host_parameters(node)
				
				resource = RestClient::Resource.new(
						RouteManager.backup_log_url(client[:address],client[:port],vmname),					
						:timeout => -1						
				)
		
		
				response = resource.get :vmname => vmname	
		
				JSON.parse(response.to_str)
				
			end
			
			
			private
			
			def self.get_host_parameters(host)
			
				dbmanager=DB::NodeDBManager.new
				
				return dbmanager.get_node(host)
					
			end
			
			def self.get_vm_status(address,port,vmname)
				response = RestClient.get RouteManager.vm_status_url(address,port,vmname)
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

