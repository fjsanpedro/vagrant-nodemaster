require 'rest_client'

require 'pp'
require 'vagrant-nodemaster/apidesc'
require 'vagrant-nodemaster/client/clientdbmanager'

module Vagrant
  module NodeMaster
		class RequestController
			include RestRoutes 
			def self.get_remote_boxes(host)
				client=get_host_parameters(host)				
																			
				response = RestClient.get RouteManager.box_list_url(client[:address],client[:port])
#				response = RestClient.get "http://#{host}:3333/api/box/list"
				return JSON.parse(response.to_str)
			end
			
			def self.box_delete(host,box,provider)
				client=get_host_parameters(host)				
																			
				response = RestClient.delete RouteManager.box_delete_url(client[:address],client[:port],box,provider)

				return JSON.parse(response.to_str)
				
			end
			
			def self.box_add(host,box,url)
				client=get_host_parameters(host)								
				
				resource = RestClient::Resource.new(
					RouteManager.box_add_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :box => box,:url => url

				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_up(host,vmname)
				client=get_host_parameters(host)
				#Debido a que puede durar bastante el levantar
				#las máquinas, establezco que la petición no expire
				resource = RestClient::Resource.new(
					RouteManager.vm_up_url(client[:address],client[:port]),
					#"http://#{host}:3333/api/vm/up",
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_halt(host,vmname,force)
				client=get_host_parameters(host)
				#Debido a que puede durar bastante apagar
				#las máquinas, establezco que la petición no expire
				resource = RestClient::Resource.new(
					RouteManager.vm_halt_url(client[:address],client[:port]),
#					"http://#{host}:3333/api/vm/halt",
					:timeout => -1
				)
				
				response = resource.post :vmname => vmname,:force=>force
			
				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_destroy (host,vmname)
				client=get_host_parameters(host)
				resource = RestClient::Resource.new(
					RouteManager.vm_destroy_url(client[:address],client[:port]),
#					"http://#{host}:3333/api/vm/destroy",
					:timeout => -1  				
				)
				
				response = resource.post :vmname => vmname
			
				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_status(host,vmname)
				client=get_host_parameters(host)
				#url="http://#{host}:3333/api/vm/status"
				
#				if (vmname!=nil)
					#url="http://#{host}:3333/api/vm/#{vmname}/status"		
#				end
					
				
				
				response = RestClient.get RouteManager.vm_status_url(client[:address],client[:port],vmname)
								
				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_ssh_config(host,vmname)
				client=get_host_parameters(host)
				response = RestClient.get RouteManager.vm_sshconfig_url(client[:address],client[:port],vmname)
#					response = RestClient.get "http://#{host}:3333/api/vm/#{vmname}/sshconfig"					
				
				result=JSON.parse(response.to_str, {:symbolize_names => true})
				#Change the target machine
				result[:host]=client[:address]
				return result
			end
			
			
			def self.vm_suspend(host,vmname)
				client=get_host_parameters(host)
				#Debido a que puede durar bastante el levantar
				#las máquinas, establezco que la petición no expire
				resource = RestClient::Resource.new(
					RouteManager.vm_suspend_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				return JSON.parse(response.to_str)
				
			end
			
			def self.vm_resume(host,vmname)
				client=get_host_parameters(host)
				#Debido a que puede durar bastante el levantar
				#las máquinas, establezco que la petición no expire
				resource = RestClient::Resource.new(
					RouteManager.vm_resume_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				return JSON.parse(response.to_str)
				
			end
			
			
			def self.vm_provision(host,vmname)
				client=get_host_parameters(host)
				#Debido a que puede durar bastante el levantar
				#las máquinas, establezco que la petición no expire
				resource = RestClient::Resource.new(
					RouteManager.vm_provision_url(client[:address],client[:port]),					
					:timeout => -1						
				)
				
				response = resource.post :vmname => vmname					
			
				return JSON.parse(response.to_str)
				
			end
			
			def self.get_remote_snapshots(host,vmname)				
				client=get_host_parameters(host)			
				
				url=RouteManager.snapshot_list_url(client[:address],client[:port],vmname)

				response = RestClient.get url
				
				
				return JSON.parse(response.to_str,{:symbolize_names => true})
				
			end
			
			def self.vm_snapshot_take(host,vmname,sname,sdesc)
				client=get_host_parameters(host)			
				resource = RestClient::Resource.new(
					RouteManager.vm_snapshot_take_url(client[:address],client[:port],vmname),					
					:timeout => -1						
				)
				response = resource.post :vmname => vmname,:name => sname,:desc => sdesc
				return JSON.parse(response.to_str,{:symbolize_names => true})
			end
			
			def self.vm_snapshot_restore(host,vmname,snapid)
				client=get_host_parameters(host)			
				resource = RestClient::Resource.new(
					RouteManager.vm_snapshot_restore_url(client[:address],client[:port],vmname),					
					:timeout => -1						
				)
				response = resource.post :vmname => vmname,:snapid => snapid
				return JSON.parse(response.to_str,{:symbolize_names => true})
			end
			
			
			private
			
			def self.get_host_parameters(host)
			
				dbmanager=dbmanager=DB::ClientDBManager.new
				
				return dbmanager.get_client(host)
					
			end
			
			
		end
  end
end

#Cajon desastre
		#response = RestClient.get "http://#{argv[0]}:3333", {:params => {:id => 50, 'foo' => 'bar'}}
#		  	id=50
#		  	resource = RestClient::Resource.new("http://#{argv[0]}:3333/id/#{id}")
#		  	
#		  	puts "RESOURCE ES #{resource.url}"
#		  	
#		  	response = resource.get 
#		  	puts "EL CODIGO ES #{response.code}"
#		  	puts "EL RESULTADO ES #{response.to_str}"
#listboxes(#{argv[0],"http://#{argv[0]}:3333")
#			response = RestClient.get "http://#{argv[0]}:3333/api/box/list"
#			boxes = JSON.parse(response.to_str)


#def listboxes(host,url)
#			begin			
#			response = RestClient.get "#{url}/api/box/list"
#			puts "EL CODIGO ES #{response.code}"
#		  	puts "EL RESULTADO ES #{response.to_str}"
#		  	
#		  	boxes = JSON.parse(response.to_str)
#		  	puts "BOXES ES #{boxes} y tamao #{boxes.length}"
#		  	puts "Remote Client: #{host} "
#		  	boxes.each { |box|  puts " * #{box["name"]} , (#{box["provider"]})" }
#		  		
#		  	
#		  	
#			rescue Exception => e
#				puts e.message	
#			end
#		end


#			response = RestClient.post("http://#{host}:3333/api/vm/up", 
#										:vmname => vmname) {	
#				|response, request, result, &block|
#				puts "EL CODIGO ES #{response.code}"
#				
#				return response.code
#			}
