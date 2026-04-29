#!/usr/bin/env python3
"""Analisa o relatório JSON do OWASP ZAP e falha se encontrar vulnerabilidade Alta."""
import json
import sys

with open("zap-reports/zap-report.json") as f:
    data = json.load(f)

severities = {"High": 0, "Medium": 0, "Low": 0, "Informational": 0}
vuln_types = {}

for site in data.get("site", []):
    for alert in site.get("alerts", []):
        sev = alert.get("riskdesc", "").split(" ")[0]
        severities[sev] = severities.get(sev, 0) + 1
        name = alert.get("name", "Unknown")
        vuln_types[name] = vuln_types.get(name, 0) + 1

total = sum(severities.values())
print(f"\n📈 TOTAL DE ALERTAS: {total}\n")
print("📊 POR SEVERIDADE:")
print(f"  🔴 High:          {severities.get('High', 0)}")
print(f"  🟠 Medium:        {severities.get('Medium', 0)}")
print(f"  🟡 Low:           {severities.get('Low', 0)}")
print(f"  🔵 Informational: {severities.get('Informational', 0)}\n")

print("🔍 TIPOS DE VULNERABILIDADES MAIS COMUNS:")
for vuln, count in sorted(vuln_types.items(), key=lambda x: -x[1])[:10]:
    print(f"  • {vuln}: {count}")

high_count = severities.get("High", 0)
if high_count > 0:
    print(f"\n❌ FALHA: {high_count} vulnerabilidade(s) de severidade ALTA detectada(s)!")
    print("   O pipeline foi bloqueado para proteger o deploy.")
    sys.exit(1)
else:
    print(f"\n✅ Nenhuma vulnerabilidade High/Critical encontrada.")
