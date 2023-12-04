# otus-linux-adv
## TASK: Creating cluster FS storage using Pacemaker, Corosync, ISCSI, GFS2

### Prerequiremts
Ensure that the folder hierarchy matches the repository. Clone this repository to your local machine.

### Deploying Vritual Enviroment
Choose between Ubuntu20 or CentOS7 for the iSCSI initiators and targets. The provided Vagrant configuration uses CentOS7 for initiators and Ubuntu20 for the target. Make sure to provide your public SSH key for instance connections. If VBox does not support adding an additional drive to the iSCSI target (`config.vm.disk`), add it manually in this case.

### ISCSI Configuration
Run the following command to execute roles related to iSCSI configuration:
`ansible-playbook --tags tag1,tag2,tag3  main.yml`
1. Modify variables in the `inventory` file as needed.
2. The first role installs necessary tools and services.
3. The second role configures the iSCSI target using variables from the `inventory` file.
4. The third role installs and configures the iSCSI initiator, maps the presented LUN, and configures multipath.
   After successful execution, check the configured multipath on all initiators:
   `multipath -ll` -> multipathd displays topology, so `dm-0` devices has been created
   ```
    36001405cf76e61fea10463babcb560b8 dm-0 LIO-ORG ,disk01
    size=1.0G features='0' hwhandler='0' wp=rw
    `-+- policy='service-time 0' prio=1 status=enabled
        `- 2:0:0:1 sdb 8:16 active ready running
    ```
    If the command doesn't show anything, check `/etc/multipath.conf`:
    ```
    multipaths {
        multipath {
            wwid 36001405e0df420ec993436b95b279f76
            alias otusDSK
        }
    }
    ```
    you can try to restart `ansible-playbook --tags tag3  main.yml` or reoad multipath config on all iscsi-initiators`multipath -r`

### PCS and Fence Configuration
`ansible-playbook --tags tag4,tag5,tag6  main.yml`
This step installs and configures the HA Pacemaker cluster, which is a requirement for the GFS2 cluster file system. Fence agents, including `fence_vbox`, will be installed and configured to shut down an unhealthy cluster node in case of any issues. Verify the success of this step:
`pcs status`

### GFS2 Configuration
`ansible-playbook --tags tag7  main.yml`
This step configures DLM and CLVM. Verify the result of the playbook:
`[root@iscsi-int-1 vagrant]# pcs status`
```
Cluster name: hacluster
Stack: corosync
Current DC: init-node-1 (version 1.1.23-1.el7_9.1-9acf116022) - partition with quorum
Last updated: Mon Dec  4 21:48:16 2023
Last change: Mon Dec  4 21:22:46 2023 by root via cibadmin on init-node-3

3 nodes configured
9 resource instances configured

Online: [ init-node-1 init-node-2 init-node-3 ]

Full list of resources:

 pcs1_fence_dev	(stonith:fence_vbox):	Started init-node-1
 pcs2_fence_dev	(stonith:fence_vbox):	Started init-node-3
 pcs3_fence_dev	(stonith:fence_vbox):	Started init-node-2
 Clone Set: dlm-clone [dlm]
     Started: [ init-node-1 init-node-2 init-node-3 ]
 Clone Set: clvmd-clone [clvmd]
     Started: [ init-node-1 init-node-2 init-node-3 ]

Daemon Status:
  corosync: active/enabled
  pacemaker: active/enabled
  pcsd: active/enabled
  ```


### Full configuration of all steps
Run the following command to perform the full configuration:
`ansible-playbook --tags all  main.yml`
