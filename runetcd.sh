
apt-get update && apt-get install -y apt-transport-https ca-certificates curl iproute2

ETCD_VER=v3.4.34

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

listen_ip = $(ip a | awk "/inet/ && /brd/" | tail -1 | awk '{print $2}' | awk -F/ '{print $1}')

/tmp/etcd-download-test/etcd --name $1 --initial-advertise-peer-urls $2 \
  --listen-peer-urls http://${listen_ip}:2380 \
  --listen-client-urls http://${listen_ip}:2379,http://$3:2379 \
  --advertise-client-urls $4 --initial-cluster-token etcd-cluster-1 \
  --initial-cluster $5 \
  --initial-cluster-state new