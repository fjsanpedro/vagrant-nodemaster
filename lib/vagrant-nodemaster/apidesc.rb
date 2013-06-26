module RestRoutes		
	#FIXME Figure how to manage remote port
#	REMOTE_PORT = 3333
	
	class RouteManager
	
		def self.box_list_route
			BOX_LIST_ROUTE
		end
		
		def self.box_delete_route
			BOX_DELETE_ROUTE
		end
		
		def self.box_add_route
			BOX_ADD_ROUTE
		end
		
		def self.vm_up_route
			VM_UP_ROUTE
		end
		
		def self.vm_suspend_route 
			VM_SUSPEND_ROUTE
		end
		
		def self.vm_resume_route
			VM_RESUME_ROUTE
		end
		
		def self.vm_halt_route
			VM_HALT_ROUTE
		end
		
		def self.vm_destroy_route
			VM_DESTROY_ROUTE
		end
		
		def self.vm_status_route
			VM_STATUS_ROUTE
		end
		
		def self.vm_provision_route
			VM_PROVISION_ROUTE
		end
		
		def self.vm_status_all_route
			VM_STATUS_ALL_ROUTE
		end
		
		def self.vm_sshconfig_route
			SSH_CONFIG_ROUTE
		end
		
		def self.snapshots_all_route
			SNAPSHOTS_ALL_ROUTE
		end
		
		def self.vm_snapshots_route
			VM_SNAPSHOTS_ROUTE
		end
		
		def self.vm_snapshot_take_route
			VM_SNAPSHOT_TAKE_ROUTE
		end
		
		def self.vm_snapshot_restore_route
			VM_SNAPSHOT_RESTORE_ROUTE
		end
		
		def self.node_backup_log_route
			NODE_BACKUP_LOG_ROUTE
		end
		
		def self.vm_backup_log_route
			VM_BACKUP_LOG_ROUTE
		end
		
		
		def self.box_list_url(host,port)
			"http://#{host}:#{port}#{box_list_route}"
		end
		
		def self.box_add_url(host,port)			
			"http://#{host}:#{port}#{box_add_route}"
		end
		
		def self.box_delete_url(host,port,box,provider)
			
			url=String.new(box_delete_route)
			url[":box"]=box
			url[":provider"]=provider
			url="http://#{host}:#{port}#{url}"
			
			url
			
		end

		
		
		def self.vm_up_url(host,port)
			"http://#{host}:#{port}#{vm_up_route}"
		end
		
		def self.vm_halt_url(host,port)
			"http://#{host}:#{port}#{vm_halt_route}"
		end
	
		def self.vm_destroy_url(host,port)
			"http://#{host}:#{port}#{vm_destroy_route}"
		end			
		
		def self.vm_suspend_url(host,port)
			"http://#{host}:#{port}#{vm_suspend_route}"
		end
		
		def self.vm_resume_url(host,port)
			"http://#{host}:#{port}#{vm_resume_route}"
		end
		
		def self.vm_provision_url(host,port)
			"http://#{host}:#{port}#{vm_provision_route}"
		end
		
			
		
		
		def self.vm_status_url(host,port,vmname=nil)	
			url="http://#{host}:#{port}#{vm_status_all_route}"
		
			if (vmname!=nil)
				url=String.new(vm_status_route)
				url[":vm"]=vmname
				url="http://#{host}:#{port}#{url}"		
			end
			
			url
			
		end
		
		def self.vm_sshconfig_url(host,port,vmname)
			url=String.new(vm_sshconfig_route)
			url[":vm"]=vmname
			
			"http://#{host}:#{port}#{url}"
								
		end
		
		def self.snapshot_list_url(host,port,vmname=nil)	
			url="http://#{host}:#{port}#{snapshots_all_route}"
		
			if (vmname!=nil)
				url=String.new(vm_snapshots_route)
				url[":vm"]=vmname
				url="http://#{host}:#{port}#{url}"		
			end
			
			url
			
		end
		
		def self.vm_snapshot_take_url(host,port,vmname)				
			url=String.new(vm_snapshot_take_route)				
			url[":vm"]=vmname
			url="http://#{host}:#{port}#{url}"						
			
			url
			
		end
		
		def self.vm_snapshot_restore_url(host,port,vmname)
			url=String.new(vm_snapshot_restore_route)
			url[":vm"]=vmname
			url="http://#{host}:#{port}#{url}"		
			
			url
			
		end
		
		def self.backup_log_url(host,port,vmname=nil)
			url="http://#{host}:#{port}#{node_backup_log_route}"
		
			if (vmname!=nil)
				url=String.new(vm_backup_log_route)
				url[":vm"]=vmname
				url="http://#{host}:#{port}#{url}"		
			end
			
			url
			
		end
		
		
		
		private
			BOX_LIST_ROUTE =	"/api/box/list"
			BOX_DELETE_ROUTE =	"/api/box/:box/:provider/delete"
			BOX_ADD_ROUTE = "/api/box/add" 
			
			VM_UP_ROUTE = "/api/vm/up"
			VM_HALT_ROUTE = "/api/vm/halt"
			VM_DESTROY_ROUTE =	"/api/vm/destroy"
			VM_SUSPEND_ROUTE = "/api/vm/suspend"
			VM_RESUME_ROUTE = "/api/vm/resume"
			VM_PROVISION_ROUTE = "/api/vm/provision"
			VM_STATUS_ALL_ROUTE = "/api/vm/status"
			VM_STATUS_ROUTE = "/api/vm/:vm/status"			
			SSH_CONFIG_ROUTE = "/api/vm/:vm/sshconfig"
			
			SNAPSHOTS_ALL_ROUTE = "/api/vm/snapshots"
			VM_SNAPSHOTS_ROUTE = "/api/vm/:vm/snapshots"
			VM_SNAPSHOT_TAKE_ROUTE = "/api/vm/:vm/take"
			VM_SNAPSHOT_RESTORE_ROUTE = "/api/vm/:vm/restore"
			
			VM_BACKUP_LOG_ROUTE = "/api/vm/:vm/backuplog"
			NODE_BACKUP_LOG_ROUTE = "/api/backuplog"
			
	end
	
end
