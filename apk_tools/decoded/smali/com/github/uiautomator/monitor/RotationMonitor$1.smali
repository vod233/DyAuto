.class Lcom/github/uiautomator/monitor/RotationMonitor$1;
.super Landroid/content/BroadcastReceiver;
.source "RotationMonitor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/monitor/RotationMonitor;->init()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/monitor/RotationMonitor;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/monitor/RotationMonitor;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/monitor/RotationMonitor;

    .line 30
    iput-object p1, p0, Lcom/github/uiautomator/monitor/RotationMonitor$1;->this$0:Lcom/github/uiautomator/monitor/RotationMonitor;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 33
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor$1;->this$0:Lcom/github/uiautomator/monitor/RotationMonitor;

    invoke-static {v0}, Lcom/github/uiautomator/monitor/RotationMonitor;->access$000(Lcom/github/uiautomator/monitor/RotationMonitor;)V

    .line 34
    return-void
.end method
