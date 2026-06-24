.class Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;
.super Ljava/lang/Object;
.source "WifiMonitor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/monitor/WifiMonitor;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "WifiInfos"
.end annotation


# instance fields
.field private ssid:Ljava/lang/String;

.field final synthetic this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

.field private wifiStatus:Z


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/monitor/WifiMonitor;ZLjava/lang/String;)V
    .locals 1
    .param p1, "this$0"    # Lcom/github/uiautomator/monitor/WifiMonitor;
    .param p2, "wifiStatus"    # Z
    .param p3, "ssid"    # Ljava/lang/String;

    .line 91
    iput-object p1, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 88
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->wifiStatus:Z

    .line 89
    const-string v0, ""

    iput-object v0, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->ssid:Ljava/lang/String;

    .line 92
    iput-boolean p2, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->wifiStatus:Z

    .line 93
    iput-object p3, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->ssid:Ljava/lang/String;

    .line 94
    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 2

    .line 98
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "{wifiStatus:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->wifiStatus:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",ssid:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->ssid:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "}"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
