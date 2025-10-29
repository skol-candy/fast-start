---
hide:
    - toc
---

# Welcome to the Application Modernization Fast-Start

This set of labs focuses on processes used to modernize applications from traditional WebSphere Application Server (tWAS) to WebSphere Liberty.

### Liberty

Liberty is an application server designed for the cloud. It’s small, lightweight, and designed with modern cloud-native application development in mind.  It supports the full MicroProfile and Jakarta EE APIs and is composable, meaning that you can use only the features that you need, keeping the server lightweight, which is great for microservices.  It also deploys to every major cloud platform, including Docker, Kubernetes, and Cloud Foundry.

!!! Note "Liberty"
    WebSphere Liberty is included in the JSphere Suite specifically as part of the Enterprise Application Runtimes (EAR) offerings. (As well as EASeJ).  Open Liberty is the community addition of this runtime.  JSphere Suite does also include other modernization paths such as EASeJ.

### Operational Modernization

Operational Modernization gives an operations team the opportunity to embrace modern operations best practices without putting change requirements on the development team.  The scaling, routing, clustering, high availability, and continuous availability functionality that were previously provided by the application server middleware, can be provided by the hybrid cloud platform (for instance OCP / Kubernetes, K8s service, SaaS offering).

### Application Modernization Accelerator (AMA)

The AMA / TA tool provides the following value:

- Identifies the Java EE programming models in the traditional Java application
- Determines the complexity of re-platforming these applications by listing a high-level inventory of the content and structure of each application
- Highlights Java EE programming model and WebSphere API differences between the WebSphere runtime profile types
- Identifies Java EE specification implementation differences that might affect the app
- Generates accelerators for deploying the application to Liberty and containers in a target environment

Additionally, the tool provides a recommendation for the right-fit IBM WebSphere Application Server edition and offers advice, best practices, and potential solutions to assess the ease of moving apps to Liberty or newer versions of WebSphere traditional. It automatically generates a migration bundle with the artifacts you will need to containerize your application running on Liberty and deploy it to OpenShift Cloud Platform, accelerating application migrating to cloud process, minimizing errors and risks and reducing time to market.

This bootcamp activity presupposes you have some familiarization with Java, application servers and containerization / Kubernetes concepts.