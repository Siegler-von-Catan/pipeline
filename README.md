# Pipeline - Repo

The pipeline repo is for bundling together our tools pipeline,
to be able to automatically execute all steps in the pipeline, including
- extraction of the motive
- shape from shading
- post-processing, like generating the 3d stl file using blender

I tried to keep track of some of the datasets origins and how we processed them in
`dataset_information.md`.

# Usage
We bundled the dependencies in a Dockerfile, to make it as easy as possible to use.

## Installation
```
git clone --recurse-submodules
```


## Running the pipeline
```
./docker_run.sh
```
