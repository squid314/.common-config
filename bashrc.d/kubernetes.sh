# kubernetes tools

if type kubectl &>/dev/null ; then
    source <(kubectl completion bash)
    alias kc=kubectl
fi

if type kubeadm &>/dev/null ; then
    source <(kubeadm completion bash)
    alias ka=kubeadm
fi
