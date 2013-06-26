vagrant-nodemaster
==================
This plugin allows you to control centralizely remote virtual environments configured with the plugin [Vagrant-Node](https://github.com/fjsanpedro/vagrant-nodemaster/tree/master/lib/vagrant-node).


This plugin has been developed in the context of the [Catedra SAES](http://www.catedrasaes.org) of the University of Murcia(Spain).

##Installation
Requires Vagrant 1.2 and libsqlite3-dev

```bash
$ vagrant plugin install vagrant-nodemaster
```

##Usage
This plugin provides two main commands: `vagrant remote` and `vagrant node`.

The command `Vagrant node` allows you to manage a set of computers as *nodes*. This set is composed by the an id of the node, the ip address/dns name and the port where it is listening.

This command is composed by the following subcommands:

* `vagrant node add  <node-name> <node-address> <node-port> --hostname`:
Adds a node identified by node-name, with the ip node-address (or dns name if `--hostname` parameter is present) and the node-port where the node is listening.
* `vagrant node remove  [node-name] --clean`: Removes a node identified by its *node-name* from the set of nodes. Also you can use the parameter --clean to remove all nodes from the list.
* `vagrant node update  <node-name> <node-address> <node-port> --hostname`: Updates the information of the node identified by its *node-name*.
* `vagrant node status`: Shows the list of nodes and its status, like if they are listening.

The command `Vagrant remote` enables you to execute in remote nodes those commands that you can use locally. Also, some new ones have been added.

* `vagrant remote box`
  * `vagrant remote box add <node-name> <box-name> <url>`: Executes `vagrant box add <box-name> <url>` in node identified by *node-name*.
  
  * `vagrant remote box list <node-name>`: Executes `vagrant box list` in node identified by *node-name*.
  
  * `vagrant remote box remove <node-name> <box-name> <box-provider>`: Executes `vagrant box remove <box-name> <box-provider>` in node identified by *node-name*.
  
* `vagrant remote destroy <node-name> [vm_name] [--force]`:  Executes `vagrant destroy [vm_name] [--force]` in node identified by *node-name*.
  
* `vagrant remote halt <node-name> [vm_name] [--force]`: Executes `vagrant halt [vm_name] [--force]` in node identified by *node-name*.

* `vagrant remote provision <node-name> [vm_name]`: Executes `vagrant provision [vm_name]` in node identified by *node-name* .

* `vagrant remote resume <node-name> [vm_name]`: Executes `vagrant resume [vm_name]` in node identified by *node-name* .

* `vagrant remote status <node-name> [vm_name]`: Executes `vagrant status [vm_name]` in node identified by *node-name*.

* `vagrant remote up <node-name> [vm_name]`: Executes `vagrant up [vm_name]` in node identified by *node-name*.

* `vagrant remote suspend <node-name> [vm_name]`: Executes `vagrant suspend [vm_name]` in node identified by *node-name*.

* `vagrant remote ssh <node-name> <vm_name>`: Executes `vagrant ssh <vm_name>` in node identified by *node-name*. This command enables you to connect by ssh to every vm in remote nodes.


* `vagrant remote snapshot` (New command)

  * `vagrant remote snapshot take <node-name> <vmname> <name> [description]`: Takes a snapshot of the current state of the virtual machine *vmname* in remote node *node-name*. This snapshot is identified by *name* and optionally can have a *description*.
  * `vagrant remote snapshot restore <node-name> <vmname> <snapshot-uuid|snapshot-name]>`: Restores the snapshot identified by its *snapshot-uuid* or by its *snapshot-name* of the virtual machine *vmname* in remote node *node-name*.
  * `vagrant remote snapshot list <node-name> [vmname]`: Shows the list of snapshots of the virtual machine *vmname* in remote *node-name*. This list also shows the current snapshot that is in use.
  

* `vagrant remote backup` (New command)

  * `Vagrant remote backup take [node-name] [vmname] [--download target_directory][--background]`: This command allows you to make a backup of the virtual machine *vmname* in remote node *node-name*. This backup includes all the virtual machine images, and it is stored in a fixed place of the remote node. Also you can use the parameter `--download` to download the backup at the same time that is is taking. With parameter `--background`, this operation is donde in background.
  * `vagrant remote backup log <node-name> [vmname]`: Shows the log of backup operations done in virtual machine *vmname* in remote node *node-name*.

## Important:
**The main lack of this version is that there is no type of authentication mechanism. Be carefull when you use it in a public infraestructure.**

## To-Do:
* Move to a proper place the node database (currently it is stored in /tmp)
* Because the plugin is still under development, there are some comments and *puts* sentences that will be removed in latter versions.
* Check some commands
* Add more parameters and options to commands
* Lots of things...



