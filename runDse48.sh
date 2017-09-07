export STOMP_INTERFACE=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' opscentos`
echo "STOMP INTERFACE is ${STOMP_INTERFACE}"
docker run -d --name dsecent1 -p 9042:9042 -e STOMP_INTERFACE="$STOMP_INTERFACE" dsecent48
# docker run -d --name dsecent1 -p 9042:9042 dsecent48 
export SEEDS=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dsecent1`
echo "SEEDS is ${SEEDS}"
docker run -d --name dsecent2 -e SEEDS="$SEEDS" -e STOMP_INTERFACE="$STOMP_INTERFACE" dsecent48
