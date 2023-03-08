# KNADA git sync

Docker image brukt av Airflow for å klone repoer i init- og sidecar-containere.


## Clone

```yaml
name: git-clone
image: europe-west1-docker.pkg.dev/knada-gcp/knada/git-sync
command:
  - /bin/sh
  - /git-clone.sh
args:
  - $repo
  - $branch
  - $dir
volumeMounts:
  - mountPath: $dir
    name: git-clone
```
## Sync

```yaml
name: git-clone
image: europe-west1-docker.pkg.dev/knada-gcp/knada/git-sync
command:
  - /bin/sh
  - /git-sync.sh
args:
  - $repo
  - $branch
  - $dir
  - $sync-time
volumeMounts:
  - mountPath: $dir
    name: git-clone
```
