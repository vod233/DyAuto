.class public Lcom/github/uiautomator/AdbBroadcastReceiver;
.super Landroid/content/BroadcastReceiver;
.source "AdbBroadcastReceiver.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "MockGPSReceiver"


# instance fields
.field private mockGPS:Lcom/github/uiautomator/MockLocationProvider;

.field private mockWifi:Lcom/github/uiautomator/MockLocationProvider;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 18
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 18
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    invoke-virtual/range {p2 .. p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v3

    const-string v4, "stop.mock"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 19
    iget-object v3, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockGPS:Lcom/github/uiautomator/MockLocationProvider;

    if-eqz v3, :cond_0

    .line 20
    invoke-virtual {v3}, Lcom/github/uiautomator/MockLocationProvider;->shutdown()V

    .line 22
    :cond_0
    iget-object v3, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockWifi:Lcom/github/uiautomator/MockLocationProvider;

    if-eqz v3, :cond_6

    .line 23
    invoke-virtual {v3}, Lcom/github/uiautomator/MockLocationProvider;->shutdown()V

    goto/16 :goto_3

    .line 26
    :cond_1
    new-instance v3, Lcom/github/uiautomator/MockLocationProvider;

    const-string v4, "gps"

    invoke-direct {v3, v4, v1}, Lcom/github/uiautomator/MockLocationProvider;-><init>(Ljava/lang/String;Landroid/content/Context;)V

    iput-object v3, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockGPS:Lcom/github/uiautomator/MockLocationProvider;

    .line 27
    new-instance v3, Lcom/github/uiautomator/MockLocationProvider;

    const-string v4, "network"

    invoke-direct {v3, v4, v1}, Lcom/github/uiautomator/MockLocationProvider;-><init>(Ljava/lang/String;Landroid/content/Context;)V

    iput-object v3, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockWifi:Lcom/github/uiautomator/MockLocationProvider;

    .line 29
    const-string v3, "lat"

    invoke-virtual {v2, v3}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "0"

    if-eqz v4, :cond_2

    invoke-virtual {v2, v3}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    goto :goto_0

    :cond_2
    move-object v3, v5

    :goto_0
    invoke-static {v3}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v3

    .line 30
    .local v3, "lat":D
    const-string v6, "lon"

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    if-eqz v7, :cond_3

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    goto :goto_1

    :cond_3
    move-object v6, v5

    :goto_1
    invoke-static {v6}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v14

    .line 31
    .local v14, "lon":D
    const-string v6, "alt"

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    if-eqz v7, :cond_4

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    goto :goto_2

    :cond_4
    move-object v6, v5

    :goto_2
    invoke-static {v6}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v16

    .line 32
    .local v16, "alt":D
    const-string v6, "accurate"

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    if-eqz v7, :cond_5

    invoke-virtual {v2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    :cond_5
    invoke-static {v5}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v5

    .line 33
    .local v5, "accurate":F
    const/4 v6, 0x4

    new-array v6, v6, [Ljava/lang/Object;

    const/4 v7, 0x0

    invoke-static {v3, v4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v8

    aput-object v8, v6, v7

    const/4 v7, 0x1

    invoke-static {v14, v15}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v8

    aput-object v8, v6, v7

    const/4 v7, 0x2

    invoke-static/range {v16 .. v17}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v8

    aput-object v8, v6, v7

    const/4 v7, 0x3

    invoke-static {v5}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v8

    aput-object v8, v6, v7

    const-string v7, "setting mock to Latitude=%f, Longitude=%f Altitude=%f Accuracy=%f"

    invoke-static {v7, v6}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "MockGPSReceiver"

    invoke-static {v7, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 34
    iget-object v6, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockGPS:Lcom/github/uiautomator/MockLocationProvider;

    move-wide v7, v3

    move-wide v9, v14

    move-wide/from16 v11, v16

    move v13, v5

    invoke-virtual/range {v6 .. v13}, Lcom/github/uiautomator/MockLocationProvider;->pushLocation(DDDF)V

    .line 35
    iget-object v6, v0, Lcom/github/uiautomator/AdbBroadcastReceiver;->mockWifi:Lcom/github/uiautomator/MockLocationProvider;

    invoke-virtual/range {v6 .. v13}, Lcom/github/uiautomator/MockLocationProvider;->pushLocation(DDDF)V

    .line 37
    .end local v3    # "lat":D
    .end local v5    # "accurate":F
    .end local v14    # "lon":D
    .end local v16    # "alt":D
    :cond_6
    :goto_3
    return-void
.end method
