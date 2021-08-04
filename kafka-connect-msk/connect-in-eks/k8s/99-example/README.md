- Create namespace for kafka  
  `kubectl create namespace kafka`  
  
- Download and install `strimzi-cluster-operator` from https://github.com/strimzi/strimzi-kafka-operator/releases  
  `kubectl apply -f strimzi-cluster-operator-0.20.1.yaml -n kafka`

- ERROR : Cluster Operator verticle in namespace kafka failed to start
io.fabric8.kubernetes.client.KubernetesClientException: kafkas.kafka.strimzi.io is forbidden: User "system:serviceaccount:kafka:strimzi-cluster-operator" cannot watch resource "kafkas" in API group "kafka.strimzi.io" in the namespace "kafka"

- SOLUTION : https://github.com/strimzi/strimzi-kafka-operator/issues/1292

```
kubectl create clusterrolebinding strimzi-cluster-operator-namespaced --clusterrole=strimzi-cluster-operator-namespaced --serviceaccount kafka:strimzi-cluster-operator

kubectl create clusterrolebinding strimzi-cluster-operator-entity-operator-delegation --clusterrole=strimzi-entity-operator --serviceaccount kafka:strimzi-cluster-operator

kubectl create clusterrolebinding strimzi-cluster-operator-topic-operator-delegation --clusterrole=strimzi-topic-operator --serviceaccount kafka:strimzi-cluster-operator
```

- Verify the cluster-operator  
  `kubectl get pods -n kafka`

  `kubectl get pods -l=name=strimzi-cluster-operator -n kafka`

- Verify the Custom Resource Definitions  
  `kubectl get crd | grep strimzi`

- Verify the Cluster Roles
  `kubectl get clusterrole | grep strimzi`

- Create the kafka connect cluster  
  `kubectl apply -f kafka-connect.yaml -n kafka` 

- Verify the connect cluster  
  `kubectl get kafkaconnects -n kafka`

- Verify the connect cluster logs
  `kubectl get kafkaconnect strimzi-connect-cluster -o yaml -n kafka`

- Verify the pod  
  `kubectl get pod -l=strimzi.io/cluster=strimzi-connect-cluster -n kafka`

- Verify the pod logs
  `kubectl logs <pod-name>`

- Deploy the connectors in connect cluster
  `kubectl apply -f source-connector.yaml -n kafka`

- Verify the connectors
  `kubectl get kafkaconnectors -n kafka`

- Verify the connector logs
  `kubectl get kafkaconnectors source-connector -o yaml -n kafka`

- Create secret for connectors  
  `kubectl -n kafka create secret generic connect-secrets --from-file=connect-secrets.properties`

- NOT REQUIRED : Create egress network policy
  `kubectl get networkpolicy internet-egress -o yaml -n kafka`

- NOT REQUIRED : 
  `http://entechlog-vm-kube-master:5000/v2/_catalog`  
  `http://192.168.1.20:5000/v2/_catalog`

- NOT REQUIRED : Create the config maps for connectors
  `kubectl apply -f kafka-connect-config-map.yaml -n kafka`

- NOT REQUIRED : Verify the config maps 
  `kubectl describe configmaps kafka-connect-config-map -n kafka`

