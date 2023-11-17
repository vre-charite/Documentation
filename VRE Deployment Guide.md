# ** DEPLOYING VRE SERVICES**
[TOC]
## Install the NFS Provisioner or StorageClasses
The NFS will allow kubernetes to interface with the NFS server of the VRE. 

Using the an NFS provisioner helm chart, replace the IP and nfs path with the appropriate values:
```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner \
nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=10.56.8.79 \
--set nfs.path=/nfs/path \
--set storageClass.onDelete=true

```
See also the storageconfigclasses in VRE/kubernetes that can be used
  
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)
  
## Install metallb if required
This is dependent on your implementation of kubernetes, but with bare metal k8s, Metallb must be installed before services in the cluster can be accessed externally. Metallb requires a pool of virtual (floating) IP addresses (VIPs), you define these in /kubernetes/metallb/config.yaml . These addresses can be assigned to cluster services, so that if the pod a service is running on becomes unreachable, the VIP of the service can just point at another pod. 

Source code in VRE/kubernetes/metallb

Create the namespace metallb-system
```
kubectl create namespace metallb-system
```
Create the memberlist secret
```
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```
Apply the ConfigMaps, customise the IP range inside the file
```
kubectl apply -f config.yaml
```
Deploy the service
```
kubectl apply -f metallb.yaml
```
In one code block:

```
kubectl create namespace metallb-system 
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f config.yaml
kubectl apply -f metallb.yaml
```
  
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)

## Deploy and configure PostgreSQL
Apply the PersistentVolumeClaims, secret, and deployment in /VRE/kubernetes/opsdb:
```
kubectl apply -f  new-datadir-postgres-0-pvc.yaml
kubectl apply -f  new-datadir-opsdb-0-pvc.yaml
kubectl apply -f  credential.yaml
kubectl apply -f  deployment.yaml
```


Log in to the opsdb pod to create the keycloak db and user, note that the password must be in wrapped in single quotation marks ''
```
kubectl exec -it opsdb-0 -n utility -- bash
psql INDOC_VRE -U indoc_vre
create database keycloak with encoding 'UTF8';
create user keycloak WITH PASSWORD 'keycloak-password';
GRANT ALL PRIVILEGES ON DATABASE "keycloak" to keycloak;
#ALTER USER keycloak WITH PASSWORD 'keycloak-password'; (to alter or just to check for correctness)
```
Note that the notification service also requires an account with full access to this db.

The INDOC_VRE database should have this schema [schema.sql](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/schemaonly.sql)

Within that schema, the casbin_rule table needs these rules: [casbinonly.sql](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/casbinonly.sql)

Apply these .sql files with \i /path/to/sqlfile.sql, after logging in to the appropriate db.

If the default username and password are postgres:postgres, follow the procedure to update them:
```
# 1. Exec into the container
kubectl exec -it postgres-guacamole-0  -- bash

# 2. Login to the DB, to login as postgres 
psql -U postgres 
# and enter password

# 3. To change password 
`ALTER USER postgres WITH PASSWORD 'newpassword';
# including the quotation marks

# 4. To edit pg_hba.conf navigate to it (from within the container)
cd /var/lib/postgresql/data/pgdata

# 5. To apply new config without restart: 
SELECT pg_reload_conf();

# 6. Log out:
\q

# 7. Exit container:
exit
```


## Keycloak Installation
Clone the repository VRE/kubernetes. In the subfolder /idp, apply the PersistentVolumeClaims. 
```
kubectl apply -f new-keycloak-antd-pvc.yaml
kubectl apply -f new-keycloak-auth-extension-pvc.yaml
kubectl apply -f storage-auth-extension.yaml
kubectl apply -f storage-antd.yaml
```
Check if the PVCs have been bound by the nfs provisioner
```
kubectl get pvc -A
```
Create the ConfigMaps used by keycloak into the utility namespace:
```
	kubectl -n utility create cm index.html --from-file=index.html
	kubectl -n utility create cm standalone.xml --from-file=standalone.xml
	kubectl -n utility create cm standalone-ha.xml --from-file=standalone-ha.xml
  kubectl -n utility create cm messages-en.properties --from-file=messages_en.properties
  
```
Apply the credential.yaml
```
kubectl apply -f credential.yaml
```
Then deploy keycloak:

```
kubectl apply -f keycloak.yaml
```
Access the keycloak GUI and create a vre realm, create clients for kong, react-app, minio, and when you add workbenches create clients for them too.
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)
  
## Install ingress-nginx
In the file `values.yaml` the parameter `loadBalancerIP` can be configured with the IP address allocated for the communication with the internet.
  
**NOTE:** when configured the `loadBalancerIP` appears in the list of IP addreses of an available master node. Thus this IP appears only at one of the masters. Every master node has its VM IP and its VIP-IP permanently configured, where the externally accessible IP for the HTTPS access is dynamically allocated by the API server. This means it is not configured in the VM's network adapter but in the nginx configuration file on each master node.
  
```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install vre-ingress ingress-nginx/ingress-nginx --set controller.service.loadBalancerIP=10.56.8.101  --namespace utility --set rbac.create=true --version 2.12.1 -f values.yaml 

kubectl port-forward pods/PODNAME PORTNUMBER:PORTNUMBER
``` 
  
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)
  
## Install kong apigateway and konga
In the same way as with, for example, the keycloak install above, first apply the PersistentVolumeClaims and then apply the deployment yaml files.

Either through konga GUI or directly with the kong container, import these services and their routes, which define the VRE internal API: [kongconfig.json](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/kongconfig.json)

  
## Install Consul and Vault
Apply the Consul PersistentVolumeClaims and statefulsets and run:

```
helm install consul --values helm-consul-values.yml --namespace vault ./consul
```
Before deploying vault apply its PersistentVolumeClaims and configure the environment.
```
# prepare env
SERVICE=vault
NAMESPACE=vault
SECRET_NAME=vault-server-tls
TMPDIR=/tmp
# Create a key for Kubernetes to sign
openssl genrsa -out ${TMPDIR}/vault.key 2048
# Create a Certificate Signing Request (CSR)
 cat <<EOF >${TMPDIR}/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SERVICE}
DNS.2 = ${SERVICE}.${NAMESPACE}
DNS.3 = ${SERVICE}.${NAMESPACE}.svc
DNS.4 = ${SERVICE}.${NAMESPACE}.svc.cluster.local
IP.1 = 127.0.0.1
EOF
```
  
```
openssl req -new -key ${TMPDIR}/vault.key -subj "/CN=${SERVICE}.${NAMESPACE}.svc" -out ${TMPDIR}/server.csr -config ${TMPDIR}/csr.conf

export CSR_NAME=vault-csr
```
```
cat <<EOF >${TMPDIR}/csr.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
 name: ${CSR_NAME}
spec:
 groups:
 - system:authenticated
 request: $(cat ${TMPDIR}/server.csr | base64 | tr -d '\n')
 usages:
 - digital signature
 - key encipherment
 - server auth
EOF
```
```
# Send the CSR to Kubernetes
kubectl create -f ${TMPDIR}/csr.yaml
# Approve the CSR in Kubernetes
kubectl certificate approve ${CSR_NAME}
```
Store key, cert, and Kubernetes CA into Kubernetes secrets store and create secret
```
# Retrieve the certificate
serverCert=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')
# Write the certificate out to a file
echo "${serverCert}" | openssl base64 -d -A -out ${TMPDIR}/vault.crt
# Retrieve Kubernetes CA.
kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${TMPDIR}/vault.ca
# Store the key, cert, and Kubernetes CA into Kubernetes secrets
kubectl create secret generic ${SECRET_NAME} \
 --namespace ${NAMESPACE} \
 --from-file=vault.key=${TMPDIR}/vault.key \
 --from-file=vault.crt=${TMPDIR}/vault.crt \
 --from-file=vault.ca=${TMPDIR}/vault.ca 
```
Inside VRE/kubernetes/vault/vault run:
```
helm install vault --values helm-vault-values.yml --namespace vault ./vault
```
Get vault credentials:
```
kubectl exec vault-0 -n vault -- vault operator init -format=json > cluster-keys.json
```
Unseal vault nodes
```
# You have do below step for every vault pod
# $unseal_key are from cluster-keys.json (unseal_keys_b64) which is
generated in above step.
# Note: Make sure to unseal at 3 keys for each pod. Looks at "Unseal
Progress" status until it is actually showing "running".
kubectl exec vault-0 -n vault -- vault operator unseal $unseal_key
```
Vault secrets are accessed by the containers when they are created. Configure the secrets and environment variables in [vaultconfig.json](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/vaultconfig.json) and import them into vault. You'll create a kv secrets engine with path /vre and the secrets can be accessed with 

```
kubectl exec vault-0 -- vault kv get -format=json vre/app/config 
```
[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)
  
## Create PVCs for vre greenroom and core 
## Deploy neo4j
To login to the portal you need to create an admin user in the neo4j db like this


```
CREATE (u:User {
  global_entity_id: "e25a09aa-919f-11eb-ac2b-ee9477001436-1617140144",
  path: "users",
  time_lastmodified: "2023-02-13T15:27:53.831053083",
  role: "admin",
  last_login: "2023-03-15T15:12:13.280840",
  name: "admin",
  last_name: "admin",
  first_name: "admin",
  email: "vre-admin@charite.de",
  username: "admin",
  status: "active"
})
RETURN u
```
to do this with k exec -it < neo4jpod > -- cypher-shell "CREATE...
```
cypher-shell "CREATE (u:User {global_entity_id: 'e25a09aa-919f-11eb-ac2b-ee9477001436-1617140144', announcement_indoctestproject: 7, path: 'users', time_lastmodified: '2023-02-13T15:27:53.831053083', role: 'admin', last_login: '2023-03-15T15:12:13.280840', name: 'admin', last_name: 'admin', first_name: 'admin', email: 'vre-admin@charite.de', username: 'admin', status: 'active'}) RETURN u;"

```
## Deploy RabbitMQ
Messager for the file operations in the greenroom.
## Deploy redis
Stores read/write states of datasets for file operation requests
## Deploy minio with KES
Object storage for VRE data
https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/PILOT-Opensource-Minio-051222-1323.pdf

https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/AUX/MinIO.pdf
## Deploy elasticsearch and kibana
For operations logging

## Deploy the VRE services with terraform or with manifests
The helm charts for the vre services can be installed with terraform. The manifests for the services also exist in {vre-service}/kubernetes repos.
## Deploying of VRE Projects <br /> &nbsp;                         
Deploy Workbench tools (Guacamole, JupyterHub, etc.) using the automation scripts and ansible playbooks from repository VRE-operation. 

[go to TOP](https://git.bihealth.org/vre/documentation/operational-and-maintenance-procedures/-/blob/main/CMD-I3.md#vre-applications)
