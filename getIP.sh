echo $1
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
