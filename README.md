To install a Helm chart from this repository first add the repository:

```
helm repo add myrepo https://prasus.github.io/helm-charts 
helm repo update
```

## Installing charts

Use the `helm install` command to install the charts:

```
helm install myrepo/mychart --name myrelease --set key=value 
```

See the [Helm Documentation](https://github.com/helm/helm/tree/master/docs) for more information.
