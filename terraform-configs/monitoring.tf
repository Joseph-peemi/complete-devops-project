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
              - targets: ['prometheus-prometheus-node-exporter.monitoring.svc.cluster.local:9100']

    alertmanager:
      service:
        type: ClusterIP
      config:
        route:
          receiver: 'slack-notifications'
        receivers:
          - name: 'slack-notifications'
            slack_configs:
              - send_resolved: true
                channel: '#devops-alerts-monitoring'
                username: 'PrometheusBot'
                icon_emoji: ':rotating_light:'
                api_url: '${var.slack_webhook_url}'

    additionalPrometheusRulesMap:
      node-alerts:
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
    EOF
  ]
}
