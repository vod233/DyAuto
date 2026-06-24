.class public Lcom/github/uiautomator/monitor/WifiMonitor;
.super Lcom/github/uiautomator/monitor/AbstractMonitor;
.source "WifiMonitor.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "WifiMonitor"


# instance fields
.field private receiver:Landroid/content/BroadcastReceiver;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 25
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/monitor/AbstractMonitor;-><init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V

    .line 26
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/monitor/WifiMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/monitor/WifiMonitor;
    .param p1, "x1"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;
    .param p2, "x2"    # Ljava/lang/String;

    .line 20
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/monitor/WifiMonitor;->report(Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V

    return-void
.end method

.method private report(Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V
    .locals 1
    .param p1, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;
    .param p2, "content"    # Ljava/lang/String;

    .line 83
    const-string v0, "/info/wifi"

    invoke-virtual {p1, v0, p2}, Lcom/github/uiautomator/monitor/HttpPostNotifier;->Notify(Ljava/lang/String;Ljava/lang/String;)V

    .line 84
    return-void
.end method


# virtual methods
.method public init()V
    .locals 2

    .line 30
    const-string v0, "WifiMonitor"

    const-string v1, "Wifi monitor init"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 31
    new-instance v0, Lcom/github/uiautomator/monitor/WifiMonitor$1;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/monitor/WifiMonitor$1;-><init>(Lcom/github/uiautomator/monitor/WifiMonitor;)V

    iput-object v0, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->receiver:Landroid/content/BroadcastReceiver;

    .line 63
    return-void
.end method

.method public register()V
    .locals 3

    .line 67
    const-string v0, "WifiMonitor"

    const-string v1, "Wifi monitor starting"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 69
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 70
    .local v0, "filter":Landroid/content/IntentFilter;
    const-string v1, "android.net.wifi.STATE_CHANGE"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 71
    const-string v1, "android.net.conn.CONNECTIVITY_CHANGE"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 72
    iget-object v1, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->context:Landroid/content/Context;

    iget-object v2, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->receiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v1, v2, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 73
    return-void
.end method

.method public unregister()V
    .locals 2

    .line 77
    iget-object v0, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->receiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    .line 78
    iget-object v0, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/github/uiautomator/monitor/WifiMonitor;->receiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 80
    :cond_0
    return-void
.end method
