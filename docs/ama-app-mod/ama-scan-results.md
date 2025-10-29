---
Title: Understanding the Scans
    - toc
---

# Understanding the Scans

## Live-Profile "Collect"

Live-profile “collect” with `transformationadvisor`:

```bash
./transformationadvisor \
  -w /path/to/your/WAS/install \
  -p YourProfileName
```

- **When to use**: you have shell access to a running WAS profile that already has your EAR/WAR deployed.
- **What it does**: automatically packages up the entire profile—server.xml, resources, JMS, deployed archives—and uploads (or prepares for upload) to the AMA UI.
- **Why it’s valuable**:
    - You get a full picture of how the app is configured at runtime (data sources, security, clustering, custom JVM args…).
    - No need to manually locate your EAR/WAR.
    - You can review container recipes right in the UI, side-by-side with your live-server config.
 
## Binary Scan 

Binary scan with `binaryAppScanner.jar`:

```bash
java -jar binaryAppScanner.jar \
  /path/to/yourApp.ear \
  --all \
  --sourceAppServer=was90 \
  --sourceJava=ibm8 \
  --targetAppServer=liberty \
  --targetJava=java21 \
  --targetCloud=containers \
  --output=/some/output/dir
```

- **When to use**: you only have the packaged archive(s) — EAR, WAR or an exploded directory — or you want to drive specific migrations flags (Java-8→21, Liberty feature list, container manifests).
- **What it does**:
    - Runs the Detailed Migration Analysis (inventory, technology evaluation, API-change rules)
    - Generates OpenRewrite recipes for Java-8→21 upgrades
    - Builds a Liberty server.xml snippet and a containerization folder with Dockerfile + Kubernetes YAML
- **Why it’s valuable**:
    - Fine-grained control over source-and-target flags
    - Ideal for embedding in a CI/CD pipeline (you point at the built artifact, not the live server)
    - You can prove “zero flagged rules” after you’ve refactored and rebuilt.
- **When to use each scan**:
    - Full Modernization: start with the collect step to feed the AMA UI and get a holistic, server-side view. Then run the binary scan against the same EAR to drill into Java-21 migration and container recipes.
    - Pure code-migration pipelines: skip straight to the binary scan. You only care about API-changes and container output, and you want it fully automatable without touching production servers.
 
!!! Question "Where do I scan?"
    How do I use the scanners?  When do I use which scanner?
    
    - Have a running profile? Do the `transformationadvisor -w… -p… collect` first.
    - Have only artifacts or want JDK migration flags? Run `binaryAppScanner.jar` with your `--source… and --target…` options

    Using both in tandem gives you the best of both worlds: real-world config context plus precise, flag-driven migration guidance.

## Next Steps

Although you could use the artifacts from these reports to quickly deploy the application, the bootcamp experience continues using [watsonx Code Assistant](../wca-app-dev-mod/index.md) to finish the modernization experience.

