# GKE Test

## Deploy Procedure

Before docker building, please store your valid SSH Key (`id_rsa`) in `./.ssh` directory.

```txt
docker build -t sample-app .

# execute local
docker run --name test -d -p 8080:8080 sample-app

# push docker image to container repository
docker tag sample-app gcr.io/[PROJECT_ID]/sample-app:tag1
gcloud docker -- push gcr.io/[PROJECT_ID]/sample-app:tag1

# deploy image to container
kubectl run sample-app --image gcr.io/[PROJECT_ID]/sample-app:tag1 --port 8080
kubectl expose deployment sample-app --type "LoadBalancer"
kubectl get service sample-app

# clean up
kubectl delete service sample-app
kubectl delete deployments sample-app

gcloud container images delete gcr.io/[PROJECT_ID]/sample-app:tag1
```

## Reference

* [k8s quickstart](https://cloud.google.com/kubernetes-engine/docs/quickstart)
* [go get for private repos in docker](https://divan.github.io/posts/go_get_private/)
* [Building Minimal Docker Containers for Go Applications](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)