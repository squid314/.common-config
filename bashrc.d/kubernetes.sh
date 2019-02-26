# kubernetes tools

if type kubectl &>/dev/null ; then
    source <(kubectl completion bash)
fi

if type kubeadm &>/dev/null ; then
    source <(kubeadm completion bash)
fi
