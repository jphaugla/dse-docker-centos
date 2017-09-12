#  choose docker version here
#VERSION=4.8.13-1
#VERSION=5.0.9-1
VERSION=5.1.3-1
SUFFIX=${VERSION:0:1}${VERSION:2:1}
IMAGE=dsecent${SUFFIX}
echo "image is ${IMAGE}"
docker build . -t ${IMAGE} -f Dockerfile --build-arg DSE_VERSION=$VERSION
