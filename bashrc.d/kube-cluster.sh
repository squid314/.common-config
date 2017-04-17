# kube-cluster.sh

# script to duplicate what kube-cluster's os_shell.command script does

pathmunge "${HOME}/kube-cluster/bin" after

# get master VM's IP
master_vm_ip="`~/bin/corectl q -i k8smaster-01`"

# set etcd endpoint
export ETCDCTL_PEERS="http://$master_vm_ip:2379"

# set fleetctl endpoint
export FLEETCTL_TUNNEL=""
export FLEETCTL_ENDPOINT="http://$master_vm_ip:2379"
export FLEETCTL_DRIVER="etcd"
export FLEETCTL_STRICT_HOST_KEY_CHECKING="false"

# set kubernetes master
export KUBERNETES_MASTER="http://$master_vm_ip:8080"

# clean up
unset master_vm_ip
