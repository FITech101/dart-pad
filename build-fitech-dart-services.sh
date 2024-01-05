#!/bin/sh

this_dir=$(dirname $0)
cd ${this_dir}

image_name=dart-services:fitech101

docker build --file Dockerfile.dartservices -t $image_name $@ .
