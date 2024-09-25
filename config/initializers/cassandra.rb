require 'cassandra'

# Crea una conexión global a Cassandra
$cassandra_cluster = Cassandra.cluster(hosts: ['127.0.0.1'], port: 9042)
$cassandra_session = $cassandra_cluster.connect('mi_keyspace')
