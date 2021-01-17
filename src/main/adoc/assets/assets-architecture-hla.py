from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECS
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.aws.storage import S3
from diagrams.aws.database import RDS
from diagrams.oci.storage import FileStorage
from diagrams.onprem.compute import Server
from diagrams.onprem.database import HBase
from diagrams.k8s.storage import Volume
from diagrams.k8s.compute import ReplicaSet
from diagrams.aws.database import Database
from diagrams.onprem.logging import FluentBit
from diagrams.onprem.queue import Kafka
from diagrams.onprem.analytics import Spark
from diagrams.onprem.network import Nginx
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.azure.database import BlobStorage

with Diagram("Deployment HLA", filename="assets-architecture-hla", show=False, direction="TB"):
 
    with Cluster("Group#1") as pe:

        with Cluster("Configuration Cluster") as configServer:
            configServerP = ECS("Primary")
            configServerB = ECS("Backup")
            configServerP - configServerB

        with Cluster("VM#1"):
            s1 = ECS("MicroService #A")
            s2 = ECS("MicroService #B")
            ELB("elb") >> s1

        with Cluster("VM#2"):
            s3 = [ Server("S3 - A...Z") ]

        # Volumes
        with Cluster("Files"):
            volumeA = FileStorage("/files")
            volumeDB = Database("/database")

        # Logging
        with Cluster("Logging"):
            logs = FluentBit("logging")
            s2 >> Edge(label="produces") >> logs

        # Monitoring
        with Cluster("Monitoring"):
            s2 << Edge(label="collect") << Prometheus("metric") << Grafana("monitoring")

        httpsProxy = Nginx("HTTPS_PROXY")

    with Cluster("Cloud APIs"):
        cAPI_ELB = ELB("Cloud API - ELB")
        cAPI_Targets = [ ECS("Cloud API - Organization(s) A...Z") ]
        cAPI_ELB >> cAPI_Targets

    s1 >> Edge(label="produces") >> volumeA
    s2 >> Edge(label="consumes") >> volumeA
    s2 >> Edge(label="R/W") >> volumeDB

    # Configuration
    s2 >> Edge(label="Read/Write") >> configServerP

    s2 >> Edge(label="POST") >> s3
    s2 >> Edge(label="POST") >> cAPI_ELB

    # pe >> httpsProxy
    httpsProxy >> Edge(color="blue", style="dashed", label="proxy") >> cAPI_ELB
