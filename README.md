# readme
## prerequisites
project is prepared to be deployed on azure, so following are needed to be set for terraform:
* env variables:
    - `ARM_CLIENT_ID`
    - `ARM_SUBSCRIPTION_ID`
    - `ARM_TENANT_ID`
    - `ARM_CLIENT_SECRET`
* being logged in to azure (`az login`)
* being logged in to repository (`az acr login`)

moreover, on build machine you need to have:
* terraform
* helm
* docker
* kubectl
## running the whole thing
after cloning the repo, from root execute terraform init and then just run terraform plan and apply.
it will create repository, cluster, resource group, prepare config and then run commands to build and deploy the app.
if you feel exceptionally powerful today and have already connected to k8s cluster, you can also deploy manually using kustomize by 
```
kubectl apply -k deploy/production (or deploy/base/chart/templates)
```
## customization
defaults are enough for the app to work correctly, but you have two options of customization - via helm or kustomize. manifests are pre-build, but when you change values rememeber to rebuild helm templates by 
```
helm template chart --output-dir deploy/base
```
as deployment is designed to be done by kustomize, not helm.
## folder structure 
```
/app directory contains microsevice code.
/chart contains helm templates and values
/deploy contains actual manifests to deploy and kustomizations
    /base/chart/templates has previously build helm templates alongside with base kustomization
    /production has patch and kustomization for "production" example
 ```
