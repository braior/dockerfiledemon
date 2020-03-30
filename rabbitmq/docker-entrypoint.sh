echo "rabbit@$(HOSTNAME).rabbitmq-headless.rabbitmq.svc.cluster.local" >>/etc/hosts
#echo "NODENAME=rabbit@$(HOSTNAME).rabbitmq-headless.rabbitmq.svc.cluster.local" >>/etc/rabbitmq/rabbitmq-env.conf
rabbitmq-server
