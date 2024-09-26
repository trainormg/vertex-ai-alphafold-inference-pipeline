# Notes


Create a custom kernel for a python virtual env:
https://medium.com/@pratap.ram/tips-for-vertex-ai-managed-jupyter-notebook-6b19cae89435

```sh
python3 -m venv my-env-1
source my-env-1/bin/activate
ipython kernel install --name my-env-1 --user
```


```python
!pip uninstall -y shapely pygeos geopandas
# Install specific versions of shapely, pygeos, and geopandas known to be compatible
!pip install shapely==1.8.5.post1 pygeos==0.12.0 geopandas==0.10.2
# Upgrade google-cloud-aiplatform
!pip install -U google-cloud-aiplatform
```

```python
FILESTORE_SHARE = '/datasets'
FILESTORE_MOUNT_PATH = '/mnt/nfs/alphafold'
MODEL_PARAMS = f'gs://{BUCKET_NAME}'
# __IMAGE_URI = f'gcr.io/{PROJECT_ID}/alphafold-components'
IMAGE_URI = f'europe-west4-docker.pkg.dev/{PROJECT_ID}/alpha-kfp/alphafold-components'
```
