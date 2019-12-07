helm lint helm-chart-sources/* && \
	helm package helm-chart-sources/* && \
	helm repo index --url https://github.com/kafkaesque-io/pulsar-helm-chart .
