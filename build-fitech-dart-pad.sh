#!/bin/sh

this_dir=$(dirname $0)
cd ${this_dir}

image_name=dart-pad:fitech101

docker build --file Dockerfile.dartpad -t $image_name $@ .
