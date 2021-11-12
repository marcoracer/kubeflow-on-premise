# Instalação on-premise do kubeflow sobre kubernetes
Esse projeto foi criado para auxiliar de forma semi-automatizada na instalação do kubernetes (k8s) e kubeflow em uma infraestrutura on-premise.

### Prerequisitos

* Ubuntu 18.04 LTS atualizado
* Requisitos mínimos [kubeflow-k8s](https://www.kubeflow.org/docs/started/k8s/overview/#:~:text=Minimum%20system%20requirements,-Your%20Kubernetes%20cluster&text=Your%20cluster%20must%20include%20at,12%20GB%20memory)
* kfctl instalado


## Começando
Vamos prosseguir com a instalação dos requisitos para o k8s, depois vamos iniciar o cluster k8s, então realizar customizações e instalar o kubeflow.

O primeiro requisito que não foi automatizado é o kfctl. Estamos buscando a versão 1.1, e caso deseje usar versão mais nova, verifique se o processo de instalação continua o mesmo [kfctl-tags github](https://github.com/kubeflow/kfctl/tags).

### 1) Baixe o binário, extraia o executável e mova para a pasta binário local:
```
$ wget https://github.com/kubeflow/kfctl/releases/download/v1.1.0/kfctl_v1.1.0-0-g9a3621e_linux.tar.gz
$ tar -xvf kfctl_v1.1.0-0-g9a3621e_linux.tar.gz
$ sudo chmod 555 kfctl
$ sudo mv kfctl /usr/local/bin/
$ kfctl version
```

### 2) Desabiligar a swap e comentar a entrada da swap no arquivo fstab:

```
$ sudo swapoff -a
$ sudo vim /etc/fstab
  > comente a entrada do swap com #, salve e feche o editor.
```

### 3) Iniciando o cluster com kubeadm
Basta executar o script `init-k8s.sh`:
```
$ ./init-k8s.sh
```
A saída final lista todas os serviços de api que devem estar com disponibilidade True.

### 3.1) Customizando manifesto do cluster
Edite o arquivo kube-apiserver.yaml e adicione as duas linhas abaixo na seção spec>containers>command:
```
$ sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
+>- --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
+>- --service-account-issuer=kubernetes.default.svc
```

O resultado seria aproximadamente:
```
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.0.33:6443
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=192.168.0.33
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
   ...
    - --secure-port=6443
    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
    - --service-account-issuer=kubernetes.default.svc
    image: k8s.gcr.io/kube-apiserver:v1.20.1
```

### 3.2) Adicionando os nós ao cluster
É interessante adicionar os nós nesse momento. Basta executar o comando kubeadm join em cada worker, conforme descrito no final da inicialização do cluster. Qualquer dúvida olhar na documentação [kubeadm-join](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/)
```
kubeadm join --discovery-token <token> --discovery-token-ca-cert-hash <sha256:hash> <ip>:6443
```


### 4) Instalar o Kubeflow
Basta executar o script `install-kubeflow.sh`:
```
$ ./install-kubeflow.sh
```
Verifique se todos os pods do namespace kubeflow estão rodando com sucesso.

kubectl port-forward -n kubeflow svc/ml-pipeline-ui 9090:80

TODO: 


### 5) OPCIONAL Monitoramento do cluster com dashboard
Basta executar o script `install-dashboard.sh`, pegar o token e ligar o proxy do k8s:
```
$ ./install-dashboard.sh
$ kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount admin-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
```

então abra no navegador o [kubernetes-dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).

Caso queria usar o usuário de leitura apenas:
`
kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount read-only-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
`

## Monitorando containers do docker
A aplicação ctop permite verificar o uso de processamento e memória como um `top` dos containers que estão sendo executados pelo 
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.5/ctop-0.7.5-linux-amd64 -O /usr/local/bin/ctop

## Removendo
Caso seja necessário remover tudo, basta executar o script `remove-all.sh`.
```
$ ./remove-all.sh
```
COnfirme que os serviços do kubelet e docker não estão mais rodando e pronto.

## Autores

* **Marco Borges** - *Solution Architect & MLOps* - [marcoracer](https://github.com/marcoracer)
* **Pablo Goulart** - *Solution Architect & DevOps* - [pablosistemas](https://github.com/pablosistemas)
* **Murilo Costa** - *Software Architect & DevOps* - [murilocg](https://github.com/murilocg)






https://www.kubeflow.org/docs/notebooks/custom-notebook/
