.class public Lcom/github/uiautomator/monitor/RotationMonitor;
.super Lcom/github/uiautomator/monitor/AbstractMonitor;
.source "RotationMonitor.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "UIARotationMonitor"


# instance fields
.field receiver:Landroid/content/BroadcastReceiver;

.field windowService:Landroid/view/WindowManager;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 22
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/monitor/AbstractMonitor;-><init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V

    .line 23
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/monitor/RotationMonitor;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/monitor/RotationMonitor;

    .line 15
    invoke-direct {p0}, Lcom/github/uiautomator/monitor/RotationMonitor;->report()V

    return-void
.end method

.method private report()V
    .locals 4

    .line 55
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->windowService:Landroid/view/WindowManager;

    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Display;->getRotation()I

    move-result v0

    .line 56
    .local v0, "rotation":I
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Orientation "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "UIARotationMonitor"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 57
    iget-object v1, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, ""

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "/info/rotation"

    invoke-virtual {v1, v3, v2}, Lcom/github/uiautomator/monitor/HttpPostNotifier;->Notify(Ljava/lang/String;Ljava/lang/String;)V

    .line 58
    return-void
.end method


# virtual methods
.method public init()V
    .locals 2

    .line 27
    const-string v0, "UIARotationMonitor"

    const-string v1, "Rotation monitor init"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 28
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->context:Landroid/content/Context;

    const-string v1, "window"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    iput-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->windowService:Landroid/view/WindowManager;

    .line 30
    new-instance v0, Lcom/github/uiautomator/monitor/RotationMonitor$1;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/monitor/RotationMonitor$1;-><init>(Lcom/github/uiautomator/monitor/RotationMonitor;)V

    iput-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->receiver:Landroid/content/BroadcastReceiver;

    .line 36
    return-void
.end method

.method public register()V
    .locals 4

    .line 40
    const-string v0, "UIARotationMonitor"

    const-string v1, "Rotation monitor starting"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 41
    invoke-direct {p0}, Lcom/github/uiautomator/monitor/RotationMonitor;->report()V

    .line 44
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->receiver:Landroid/content/BroadcastReceiver;

    new-instance v2, Landroid/content/IntentFilter;

    const-string v3, "android.intent.action.CONFIGURATION_CHANGED"

    invoke-direct {v2, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 45
    return-void
.end method

.method public unregister()V
    .locals 2

    .line 49
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->receiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    .line 50
    iget-object v0, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/github/uiautomator/monitor/RotationMonitor;->receiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 52
    :cond_0
    return-void
.end method
