.class public Lcom/github/uiautomator/monitor/BatteryMonitor;
.super Lcom/github/uiautomator/monitor/AbstractMonitor;
.source "BatteryMonitor.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "UIABatteryMonitor"

.field private static final USB_STATE_CHANGE:Ljava/lang/String; = "android.hardware.usb.action.USB_STATE"


# instance fields
.field public receiver:Landroid/content/BroadcastReceiver;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 21
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/monitor/AbstractMonitor;-><init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V

    .line 18
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->receiver:Landroid/content/BroadcastReceiver;

    .line 22
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/monitor/BatteryMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Landroid/content/Intent;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/monitor/BatteryMonitor;
    .param p1, "x1"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;
    .param p2, "x2"    # Landroid/content/Intent;

    .line 14
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/monitor/BatteryMonitor;->report(Lcom/github/uiautomator/monitor/HttpPostNotifier;Landroid/content/Intent;)V

    return-void
.end method

.method private report(Lcom/github/uiautomator/monitor/HttpPostNotifier;Landroid/content/Intent;)V
    .locals 3
    .param p1, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 55
    const-string v0, "level"

    const/4 v1, 0x0

    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    .line 56
    .local v0, "level":Ljava/lang/Integer;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "notify battery changed. current level "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "UIABatteryMonitor"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 57
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "/info/battery"

    invoke-virtual {p1, v2, v1}, Lcom/github/uiautomator/monitor/HttpPostNotifier;->Notify(Ljava/lang/String;Ljava/lang/String;)V

    .line 58
    return-void
.end method


# virtual methods
.method public init()V
    .locals 2

    .line 26
    const-string v0, "UIABatteryMonitor"

    const-string v1, "Battery monitor init"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 27
    new-instance v0, Lcom/github/uiautomator/monitor/BatteryMonitor$1;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/monitor/BatteryMonitor$1;-><init>(Lcom/github/uiautomator/monitor/BatteryMonitor;)V

    iput-object v0, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->receiver:Landroid/content/BroadcastReceiver;

    .line 33
    return-void
.end method

.method public register()V
    .locals 3

    .line 37
    const-string v0, "UIABatteryMonitor"

    const-string v1, "Register BatteryMonitor"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 39
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 40
    .local v0, "filter":Landroid/content/IntentFilter;
    const-string v1, "android.intent.action.BATTERY_CHANGED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 41
    const-string v1, "android.hardware.usb.action.USB_STATE"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 42
    iget-object v1, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->context:Landroid/content/Context;

    iget-object v2, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->receiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v1, v2, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 43
    return-void
.end method

.method public unregister()V
    .locals 2

    .line 47
    iget-object v0, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->receiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    .line 48
    const-string v0, "UIABatteryMonitor"

    const-string v1, "battery unregistered"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 49
    iget-object v0, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/github/uiautomator/monitor/BatteryMonitor;->receiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 51
    :cond_0
    return-void
.end method
