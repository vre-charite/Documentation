[TOC]
# **VRE INFRASTRUCTURE**
## Kubernetes Installation with Apt
Configure master node/s with ansible:

Install ansible:
```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```  
This is based on the ansible playbook in [vre-operation](https://git.bihealth.org/vre/vre-operation/)/cluster called [cluster.yaml](https://git.bihealth.org/vre/vre-operation/-/blob/master/cluster/cluster.yaml). To run the playbook clone vre-operation onto the VM you wish to use as a master node. Edit the /vre-operation/ansible-playbook/inventory/hosts file with the IPs of your cluster and then run:
```
ansible-playbook ~/vre-operation/cluster/cluster.yaml -i ~/vre-operation/ansible-playbook/inventory/hosts
```
Or to configure master node/s manually without the playbook, run the following on the VM you wish to use as master:
```
sudo apt install python3-pip git -y
apt-get install docker.io
apt-get install nfs-common
#comment out swap config, in /etc/fstab or do so with the command:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
#enable ip_forward in config in /etc/sysctl.conf by uncommenting the #following line:
net.ipv4.ip_forward=1
#further enable ip_forward with:
sysctl -p
#install the following
apt-get install apt-transport-https
apt-get install curl
#add apt key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
#add apt repo
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#install kubelet, kubeadm, and kubectl
apt install kubelet=1.18.8-00 -y
apt install kubeadm=1.18.8-00 -y
apt install kubectl=1.18.8-00 -y
#hold those packages from being updated:
apt-mark showholds | grep -q kube && echo -n HOLDED || apt-mark hold kubelet kubeadm kubectl
```
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)
### HAproxy configuration  
HAproxy must be installed on every master that is included in at end of this file. 
```
sudo su
apt install haproxy -y
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
```
Save the following in `/etc/haproxy/haproxy.cfg` 
```
# /etc/haproxy/haproxy.cfg
#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 1
    timeout http-request    10s
    timeout queue           20s
    timeout connect         30s
    timeout client          20s
    timeout server          20s
    timeout http-keep-alive 10s
    timeout check           30s

#---------------------------------------------------------------------
# apiserver frontend which proxys to the master nodes
#---------------------------------------------------------------------
frontend apiserver
    bind *:6443
    mode tcp
    option tcplog
    default_backend apiserver

#---------------------------------------------------------------------
# round robin balancing for apiserver
#---------------------------------------------------------------------
backend apiserver
    option httpchk GET /healthz
    http-check expect status 200
    mode tcp
    option ssl-hello-chk
    balance     roundrobin
        server master-1 10.56.8.85:6444 check
        server master-2 10.56.8.86:6444 check
        server master-3 10.56.8.87:6444 check
```
Restart `haproxy service`
```
systemctl enable haproxy --now && systemctl restart haproxy && systemctl status haproxy
```
It's possible haproxy will report being unable to connect to the backend server - this is because the kubernetes API server has not yet been initialised, so this isn't a problem.
  
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)

### Configure docker proxy
```
# enter environmental variables
sudo su
https_proxy=http://proxy.charite.de:8080/
KRB5CNAME=FILE:/tmp/krb5cc_155083_4s3GCt
XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
http_proxy=http://proxy.charite.de:8080/
no_proxy=localhost,127.0.0.1,::1,10.0.0.0/8,*.charite.de

# add permanent proxy config for docker daemon and SAVE THE FILE
mkdir /etc/systemd/system/docker.service.d
printf '[Service]\nEnvironment="HTTP_PROXY=http://proxy.charite.de:8080"\nEnvironment="HTTPS_PROXY=http://proxy.charite.de:8080"\nEnvironment="NO_PROXY=localhost,127.0.0.1,::1,10.0.0.0/8,*.charite.de"\n' >> /etc/systemd/system/docker.service.d/http-proxy.conf
```
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)

### create daemon.json inside /etc/docker and add the following content
```
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}

```
### restart the docker daemon/service and test connection
```
systemctl daemon-reload && systemctl restart docker  
docker run hello-world
```

### Initialize kubernetes
Login to one of the master nodes once and run:  
```
kubeadm init --control-plane-endpoint "10.56.8.101:6443" --apiserver-advertise-address=10.56.8.65  --apiserver-bind-port=6444 --pod-network-cidr=10.244.0.0/16 --upload-certs
```
Make a note of output or exported it to textfile so that the token can be used to join the rest of master nodes, something like this:
```
sudo kubeadm join 10.56.8.85:6443 --token 02g2q6.ibs6vjya4utbtf68 --discovery-token-ca-cert-hash sha256:9ff10dbe3b6a2bfa8eaf5add6aa795bb68de769ce201576dca31e04cfd08a261 --control-plane --certificate-key 4809c59a7666f4b3dcf47265129117ac9dc25e56b1fc6b6eca8fff10be73557e --apiserver-advertise-address=10.56.8.85  --apiserver-bind-port=6444
sudo kubeadm join 10.3.50.16:6443 --token 02g2q6.ibs6vjya4utbtf68 --discovery-token-ca-cert-hash sha256:9ff10dbe3b6a2bfa8eaf5add6aa795bb68de769ce201576dca31e04cfd08a261
``` 
**OR**  
if you add nodes more than 24 hous after the initialization, then the token is expired and you need to execute the following command **on the primary master:** 
```
kubeadm token create --print-join-command
```
... and its output execute **on the joining node.**
  
To start using the kubernetes cluster run on **primary master only:**
```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
**On any other node,** from the **primary master** copy the config `/etc/kubernetes/admin.conf` to backup masters. **Execute from primary master:**  
```
scp /etc/kubernetes/admin.conf root@<backup-master>:/root/.kube/config
```
**OR**  if you can't copy it directly to the root:  
```
scp /etc/kubernetes/admin.conf <YourUserName>@<backup-master>:~/.kube/config
```
**ON THE JOINING NODE** assuming you are logged in with your account you used for `scp`-ing the config file:
```  
sudo su
mkdir /root/.kube
cp config /root/.kube/config
```
it should always be saved as `/root/.kube/config`.

Restart kubelet on each master:
`systemctl restart kubelet`

Note: the certificates expire after 2 days; to join after this time you need to generate new certificates.
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)

### Configure Calico
As an older version of kubernetes is used, an older version of calico.yaml must be used for them to be compatible, for instance version 3.20.3. The incompatibility is due to 'PodDisruptionBudget' inside of the newest calico.yaml being unrecognised by the older kubernetes
```
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```

### Configure worker node/s
  
This is based on the ansible playbook in [vre-operation](https://git.bihealth.org/vre/vre-operation/)/worker_node called [worker_node_deployment.yaml](https://git.bihealth.org/vre/vre-operation/-/blob/master/worker_node/worker_node_deployment.yaml). To run the playbook, clone vre-operation onto the VM you wish to use as a worker node and run:
```
ansible-playbook worker_node_deployment.yaml
```
Or to configure worker node/s manually without the playbook, run the following on the VM you wish to use as workers:  
```

``` 

## Helm installation
Install page https://helm.sh/docs/intro/install/  
```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)

## Terraform Installation
Deploy infrastructure as code using Terraform and configuration files in repository vre-infra. Deployment commands can be found [here](https://git.bihealth.org/hadoop/vre/vre-infra/-/blob/main/.gitlab-ci.yml). Deployment instructions can be found in the VRE Documentation for [preparation](https://vre.charite.de/xwiki/wiki/adminsubwiki/view/Main/System%20Administrator%20Guide/Project%20Initiation%20and%20Workbench%20Tool%20Setup/Keycloak%20Authentication%20Flow%20Creation/), for [Guacamole](https://vre.charite.de/xwiki/wiki/adminsubwiki/view/Main/System%20Administrator%20Guide/Project%20Initiation%20and%20Workbench%20Tool%20Setup/Guacamole/Guacamole%20Deployment/), [JupyterHub](https://vre.charite.de/xwiki/wiki/adminsubwiki/view/Main/System%20Administrator%20Guide/Project%20Initiation%20and%20Workbench%20Tool%20Setup/Jupyterhub/Jupyterhub%20deployment/), and [Superset](https://vre.charite.de/xwiki/wiki/adminsubwiki/view/Main/System%20Administrator%20Guide/Project%20Initiation%20and%20Workbench%20Tool%20Setup/Superset/Superset%20deployment/).
  
install page https://www.terraform.io/cli/install/apt
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
which terraform && terraform version
```
Terraform Initialisation  
  
Please see the [source documentation](https://git.bihealth.org/hadoop/vre/vre-infra/-/blob/main/.gitlab-ci.yml)  
```
cd $HOME/vre-infra/terraform
rm -rf .terraform
terraform init -backend-config=config/charite/config.tf
terraform plan -lock-timeout=300s -var-file=config/charite/charite.tfvars --out=charite-${CI_COMMIT_SHORT_SHA}
```
  
Services are deployed to certain namespaces like here to the K8s namespace "vre". This namespace and the Kubernetes infrastructure must exist before Terraform can perform the deployment. One can use YAML files for this or set it up during the initialization command. The namespace creation could also be added to a Terraform file, but: if someone changes/removes the namespace from the TF file, the entire namespace will be wiped. If the following namespaces don’t exist, create them:
```
kubectl create namespace vre
kubectl create namespace utility
kubectl create namespace greenroom
```
then apply the plan: terraform apply -lock-timeout=300s -input=false charite-${CI_COMMIT_SHORT_SHA} 
## Post Kubernetes Install Workflow
Once you have a running Kubernetes cluster, you will then deploy the services necessary to run the VRE on the cluster. Before these steps are shown in detail, the following short summary of the process could be helpful.

The ingress controller (nginx), user authenticator (keycloak), apigateway (kong), secrets storage (vault), and backend DB (postgresql) will be the first services that should be set up. Together, these services allow users to externally reach the VRE infrastructure and be securely authenticated.

The source code and resources for these services can be found in the VRE/kubernetes repo:

- keycloak is VRE/kubernetes/idp
- nginx is VRE/kubernetes/ingress-nginx
- vault is VRE/kubernetes/vault
- kong is VRE/kubernetes/apigateway
- postgresql is in VRE/kubernetes/opsbd

To set up some of these, you will first need to apply their PersistentVolumeClaims (instructions later on) so the services have access to disk memory, and then apply their deployments. For nginx and vault you can deploy them with an appropriate helm chart configured for the kubernetes environment.

For the PersistentVolumeClaims to be bound to PersistentVolumes, you will need to first deploy and nfs provisioner service.

These databases and other stateful applications are not managed by Terraform, to avoid that a change to a Terraform configuration file accidentally wipes the database (everything deployed by Terraform is stateless). Therefore, all stateful microservices like the Postgres database, RabbitMQ cluster, Elastic Search are deployed using Helm charts with the deployment type StatefulSet. 

Once all these are set up you can move on to deploying the user services with terraform.
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)

## Helpful Kubernetes Commands to Monitor and Debug
In the following sections, you will deploy PersistentVolumeClaims, statefulsets, deployments, services, and other Kubernetes entities. To monitor the status of these entities the following commands may be of use:

display pods/services/deployments/stateful sets/PVCs/PVs in all namespaces
```

kubectl get pods -A
kubectl get services -A
kubectl get deployments -A 
kubectl get statefulset -A 
kubectl get pvc -A
kubectl get pv -A 
```
display pods/services/deployments/stateful sets/PVCs/PVs in a particular namespace
```
kubectl get pods -n <namespace>
kubectl get services -n <namespace>
kubectl get deployments -n <namespace>
kubectl get statefulset -n <namespace>
kubectl get pvc -n <namespace>
kubectl get pv -n <namespace>
```
display more information about the display pods/services/deployments/stateful sets/PVCs/PVs. Written out for one, however the command is the same for all as above:
```
kubectl describe pods -n <namespace> <podname>
```
list containers running in a pod 
```
kubectl get pods <podname> -o jsonpath='{.spec.containers[*].name}'
```
show logs from the container running inside a pod, for instance to debug if the container is failing:
```
kubectl logs -n <namespace> <podname> --all-containers
#or for a particular container:
kubectl logs -n <namespace> <podname> <container name>
```
show the nodes of the k8s cluster, for instance to check they are joined correctly
```
kubectl get nodes
```
show which pods are running on which nodes
```
kubectl get pods -o wide -A
```
Delete a deployment, service, pod, pvc, pv:
```
kubectl delete <pod,service,deployment,pvc,pv> -n <namespace> <name of Entity to delete>
```
Execute commands inside a pod:

```
kubectl exec -it <pod name> -- bash
```
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I2.md#vre-infrastructure)
