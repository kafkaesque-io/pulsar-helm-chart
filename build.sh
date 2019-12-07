helm lint helm-chart-sources/* && \
	helm package helm-chart-sources/* && \
	helm repo index --url https://kafkaesque-io.github.io/pulsar-helm-chart .
