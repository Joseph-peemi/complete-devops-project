# resource "helm_release" "prometheus" {
#   depends_on       = [module.eks]
#   name             = "prometheus"
#   chart            = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   namespace        = "monitoring"
#   create_namespace = true
#   timeout          = 600
#
#   values = [
#     <<EOF
# grafana:
#   service:
#     type: LoadBalancer
#
# prometheus:
#   service:
#     type: ClusterIP
#   prometheusSpec:
#     scrapeInterval: 15s
#     additionalScrapeConfigs:
#       - job_name: 'node'
#         static_configs:
#           - targets: ['prometheus-prometheus-node-exporter.monitoring.svc.cluster.local:9100']
#       - job_name: 'flask-app'
#         kubernetes_sd_configs:
#           - role: pod
#             namespaces:
#               names: ['default']
#         relabel_configs:
#           - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
#             action: keep
#             regex: "true"
#           - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
#             action: replace
#             target_label: __metrics_path__
#             regex: (.+)
#           - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
#             action: replace
#             regex: ([^:]+)(?::\d+)?;(\d+)
#             replacement: $1:$2
#             target_label: __address__
#
# alertmanager:
#   service:
#     type: ClusterIP
#   config:
#     route:
#       receiver: 'slack-notifications'
#     receivers:
#       - name: 'slack-notifications'
#         slack_configs:
#           - send_resolved: true
#             channel: '#devops-alerts-monitoring'
#             username: 'PrometheusBot'
#             icon_emoji: ':rotating_light:'
#             api_url: '${var.slack_webhook_url}'
#
# additionalPrometheusRulesMap:
#   app-alerts:
#     groups:
#       - name: node_alerts
#         rules:
#           - alert: HighCPUUsage
#             expr: avg(rate(node_cpu_seconds_total{mode!="idle"}[10s])) by (instance) > 0.8
#             for: 10s
#             labels:
#               severity: warning
#             annotations:
#               summary: "High CPU usage detected on {{ $labels.instance }}"
#               description: "CPU usage is above 80% for more than 10 seconds."
#       - name: flask_app_alerts
#         rules:
#           - alert: FlaskAppDown
#             expr: up{job="flask-app"} == 0
#             for: 30s
#             labels:
#               severity: critical
#             annotations:
#               summary: "Flask app is down"
#               description: "The Flask app has been unreachable for more than 30 seconds."
#           - alert: HighRequestLatency
#             expr: rate(flask_http_request_duration_seconds_sum[1m]) / rate(flask_http_request_duration_seconds_count[1m]) > 0.5
#             for: 1m
#             labels:
#               severity: warning
#             annotations:
#               summary: "High request latency on Flask app"
#               description: "Average request latency is above 500ms for more than 1 minute."
# EOF
#   ]
# }

resource "helm_release" "prometheus" {
  depends_on       = [module.eks]
  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = true
  timeout          = 600

  values = [
    <<EOF
grafana:
  service:
    type: LoadBalancer

prometheus:
  service:
    type: ClusterIP
  prometheusSpec:
    scrapeInterval: 15s
    additionalScrapeConfigs:
      - job_name: 'node'
        static_configs:
          - targets:
              - 'prometheus-prometheus-node-exporter.monitoring.svc.cluster.local:9100'
      - job_name: 'flask-app'
        kubernetes_sd_configs:
          - role: pod
            namespaces:
              names:
                - default
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: "true"
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
            action: replace
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
            target_label: __address__

alertmanager:
  enabled: true
  service:
    type: ClusterIP
  config:
    global:
      resolve_timeout: 5m
    route:
      group_by:
        - alertname
      group_wait: 10s
      group_interval: 5m
      repeat_interval: 3h
      receiver: slack-notifications
    receivers:
      - name: slack-notifications
        slack_configs:
          - api_url: '${var.slack_webhook_url}'
            channel: '#devops-alerts-monitoring'
            send_resolved: true
            username: 'PrometheusBot'
            icon_emoji: ':rotating_light:'
            title: '{{ .CommonAnnotations.summary }}'
            text: '{{ .CommonAnnotations.description }}'

additionalPrometheusRulesMap:
  app-alerts:
    groups:
      - name: node_alerts
        rules:
          - alert: HighCPUUsage
            expr: avg(rate(node_cpu_seconds_total{mode!="idle"}[10s])) by (instance) > 0.8
            for: 10s
            labels:
              severity: warning
            annotations:
              summary: "High CPU usage detected on {{ $labels.instance }}"
              description: "CPU usage is above 80% for more than 10 seconds."
      - name: flask_app_alerts
        rules:
          - alert: FlaskAppDown
            expr: up{job="flask-app"} == 0
            for: 30s
            labels:
              severity: critical
            annotations:
              summary: "Flask app is down"
              description: "The Flask app has been unreachable for more than 30 seconds."
          - alert: HighRequestLatency
            expr: rate(flask_http_request_duration_seconds_sum[1m]) / rate(flask_http_request_duration_seconds_count[1m]) > 0.5
            for: 1m
            labels:
              severity: warning
            annotations:
              summary: "High request latency on Flask app"
              description: "Average request latency is above 500ms for more than 1 minute."
EOF
  ]
}
