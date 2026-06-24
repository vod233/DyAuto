.class public Lcom/github/uiautomator/Service;
.super Landroid/app/Service;
.source "Service.java"


# static fields
.field public static final ACTION_START:Ljava/lang/String; = "com.github.uiautomator.ACTION_START"

.field public static final ACTION_STOP:Ljava/lang/String; = "com.github.uiautomator.ACTION_STOP"

.field private static final NOTIFICATION_ID:I = 0x1

.field private static final TAG:Ljava/lang/String; = "UIAService"


# instance fields
.field private builder:Landroidx/core/app/NotificationCompat$Builder;

.field private monitors:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/github/uiautomator/monitor/AbstractMonitor;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 36
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    .line 44
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/github/uiautomator/Service;->monitors:Ljava/util/List;

    return-void
.end method

.method private addMonitor(Lcom/github/uiautomator/monitor/AbstractMonitor;)V
    .locals 1
    .param p1, "monitor"    # Lcom/github/uiautomator/monitor/AbstractMonitor;

    .line 130
    iget-object v0, p0, Lcom/github/uiautomator/Service;->monitors:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 131
    return-void
.end method

.method private createNotificationChannel(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p1, "channelId"    # Ljava/lang/String;
    .param p2, "channelName"    # Ljava/lang/String;

    .line 55
    new-instance v0, Landroid/app/NotificationChannel;

    const/4 v1, 0x0

    invoke-direct {v0, p1, p2, v1}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .line 57
    .local v0, "chan":Landroid/app/NotificationChannel;
    const v2, -0xffff01

    invoke-virtual {v0, v2}, Landroid/app/NotificationChannel;->setLightColor(I)V

    .line 58
    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setLockscreenVisibility(I)V

    .line 59
    const-string v1, "notification"

    invoke-virtual {p0, v1}, Lcom/github/uiautomator/Service;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    .line 60
    .local v1, "service":Landroid/app/NotificationManager;
    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    .line 61
    return-object p1
.end method

.method private removeAllMonitor()V
    .locals 4

    .line 134
    iget-object v0, p0, Lcom/github/uiautomator/Service;->monitors:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/github/uiautomator/monitor/AbstractMonitor;

    .line 135
    .local v1, "monitor":Lcom/github/uiautomator/monitor/AbstractMonitor;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unregister: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "UIAService"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 136
    invoke-virtual {v1}, Lcom/github/uiautomator/monitor/AbstractMonitor;->unregister()V

    .line 137
    .end local v1    # "monitor":Lcom/github/uiautomator/monitor/AbstractMonitor;
    goto :goto_0

    .line 138
    :cond_0
    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    .param p1, "intent"    # Landroid/content/Intent;

    .line 50
    const/4 v0, 0x0

    return-object v0
.end method

.method public onCreate()V
    .locals 7

    .line 66
    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    .line 68
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/github/uiautomator/MainActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 69
    .local v0, "notificationIntent":Landroid/content/Intent;
    const-string v1, ""

    .line 70
    .local v1, "channelId":Ljava/lang/String;
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1a

    if-lt v2, v3, :cond_0

    .line 71
    const-string v2, "monitor service"

    const-string v3, "Monitor Service"

    invoke-direct {p0, v2, v3}, Lcom/github/uiautomator/Service;->createNotificationChannel(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 76
    :cond_0
    new-instance v2, Landroidx/core/app/NotificationCompat$Builder;

    invoke-direct {v2, p0, v1}, Landroidx/core/app/NotificationCompat$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const v3, 0x7f060061

    .line 77
    invoke-virtual {v2, v3}, Landroidx/core/app/NotificationCompat$Builder;->setSmallIcon(I)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    const v3, 0x7f0c0028

    .line 78
    invoke-virtual {p0, v3}, Lcom/github/uiautomator/Service;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroidx/core/app/NotificationCompat$Builder;->setTicker(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    const v3, 0x7f0c0029

    .line 79
    invoke-virtual {p0, v3}, Lcom/github/uiautomator/Service;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroidx/core/app/NotificationCompat$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    const v3, 0x7f0c0027

    .line 80
    invoke-virtual {p0, v3}, Lcom/github/uiautomator/Service;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroidx/core/app/NotificationCompat$Builder;->setContentText(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    const/high16 v3, 0xa000000

    .line 81
    const/4 v4, 0x1

    invoke-static {p0, v4, v0, v3}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroidx/core/app/NotificationCompat$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    .line 82
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {v2, v5, v6}, Landroidx/core/app/NotificationCompat$Builder;->setWhen(J)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v2

    iput-object v2, p0, Lcom/github/uiautomator/Service;->builder:Landroidx/core/app/NotificationCompat$Builder;

    .line 83
    invoke-virtual {v2}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    move-result-object v2

    .line 84
    .local v2, "notification":Landroid/app/Notification;
    invoke-virtual {p0, v4, v2}, Lcom/github/uiautomator/Service;->startForeground(ILandroid/app/Notification;)V

    .line 87
    new-instance v3, Lcom/github/uiautomator/monitor/HttpPostNotifier;

    const-string v4, "http://127.0.0.1:7912"

    invoke-direct {v3, v4}, Lcom/github/uiautomator/monitor/HttpPostNotifier;-><init>(Ljava/lang/String;)V

    .line 88
    .local v3, "notifier":Lcom/github/uiautomator/monitor/HttpPostNotifier;
    invoke-virtual {p0}, Lcom/github/uiautomator/Service;->getApplicationContext()Landroid/content/Context;

    move-result-object v4

    .line 90
    .local v4, "context":Landroid/content/Context;
    new-instance v5, Lcom/github/uiautomator/monitor/WifiMonitor;

    invoke-direct {v5, p0, v3}, Lcom/github/uiautomator/monitor/WifiMonitor;-><init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V

    invoke-direct {p0, v5}, Lcom/github/uiautomator/Service;->addMonitor(Lcom/github/uiautomator/monitor/AbstractMonitor;)V

    .line 91
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 101
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    .line 102
    const-string v0, "UIAService"

    const-string v1, "Stopping service"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 103
    invoke-direct {p0}, Lcom/github/uiautomator/Service;->removeAllMonitor()V

    .line 104
    const-string v1, "unregister all watchers"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 105
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/Service;->stopForeground(Z)V

    .line 106
    return-void
.end method

.method public onLowMemory()V
    .locals 2

    .line 126
    const-string v0, "UIAService"

    const-string v1, "Low memory"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 3
    .param p1, "intent"    # Landroid/content/Intent;
    .param p2, "flags"    # I
    .param p3, "startId"    # I

    .line 110
    invoke-super {p0, p1, p2, p3}, Landroid/app/Service;->onStartCommand(Landroid/content/Intent;II)I

    .line 112
    const-string v0, "UIAService"

    const-string v1, "On StartCommand"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 113
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v1

    .line 115
    .local v1, "action":Ljava/lang/String;
    const-string v2, "com.github.uiautomator.ACTION_START"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 116
    const-string v2, "Receive start-service action, but ignore it"

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 118
    :cond_0
    const-string v0, "com.github.uiautomator.ACTION_STOP"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 119
    invoke-virtual {p0}, Lcom/github/uiautomator/Service;->stopSelf()V

    .line 121
    :cond_1
    :goto_0
    const/4 v0, 0x2

    return v0
.end method

.method public setNotificationContentText(Ljava/lang/String;)V
    .locals 3
    .param p1, "text"    # Ljava/lang/String;

    .line 94
    iget-object v0, p0, Lcom/github/uiautomator/Service;->builder:Landroidx/core/app/NotificationCompat$Builder;

    invoke-virtual {v0, p1}, Landroidx/core/app/NotificationCompat$Builder;->setContentText(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    .line 95
    const-string v0, "notification"

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/Service;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 96
    .local v0, "nm":Landroid/app/NotificationManager;
    iget-object v1, p0, Lcom/github/uiautomator/Service;->builder:Landroidx/core/app/NotificationCompat$Builder;

    invoke-virtual {v1}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v0, v2, v1}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V

    .line 97
    return-void
.end method
