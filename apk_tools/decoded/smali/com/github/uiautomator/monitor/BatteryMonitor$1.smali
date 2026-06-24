.class Lcom/github/uiautomator/monitor/BatteryMonitor$1;
.super Landroid/content/BroadcastReceiver;
.source "BatteryMonitor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/monitor/BatteryMonitor;->init()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/monitor/BatteryMonitor;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/monitor/BatteryMonitor;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/monitor/BatteryMonitor;

    .line 27
    iput-object p1, p0, Lcom/github/uiautomator/monitor/BatteryMonitor$1;->this$0:Lcom/github/uiautomator/monitor/BatteryMonitor;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 30
    iget-object v0, p0, Lcom/github/uiautomator/monitor/BatteryMonitor$1;->this$0:Lcom/github/uiautomator/monitor/BatteryMonitor;

    iget-object v1, v0, Lcom/github/uiautomator/monitor/BatteryMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    invoke-static {v0, v1, p2}, Lcom/github/uiautomator/monitor/BatteryMonitor;->access$000(Lcom/github/uiautomator/monitor/BatteryMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Landroid/content/Intent;)V

    .line 31
    return-void
.end method
