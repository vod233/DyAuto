.class public abstract Lcom/github/uiautomator/monitor/AbstractMonitor;
.super Ljava/lang/Object;
.source "AbstractMonitor.java"


# instance fields
.field context:Landroid/content/Context;

.field notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/github/uiautomator/monitor/HttpPostNotifier;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "notifier"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 14
    iput-object p1, p0, Lcom/github/uiautomator/monitor/AbstractMonitor;->context:Landroid/content/Context;

    .line 15
    iput-object p2, p0, Lcom/github/uiautomator/monitor/AbstractMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 16
    invoke-virtual {p0}, Lcom/github/uiautomator/monitor/AbstractMonitor;->init()V

    .line 18
    :try_start_0
    invoke-virtual {p0}, Lcom/github/uiautomator/monitor/AbstractMonitor;->unregister()V
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    .line 21
    goto :goto_0

    .line 19
    :catch_0
    move-exception v0

    .line 23
    :goto_0
    invoke-virtual {p0}, Lcom/github/uiautomator/monitor/AbstractMonitor;->register()V

    .line 24
    return-void
.end method


# virtual methods
.method public abstract init()V
.end method

.method public abstract register()V
.end method

.method public abstract unregister()V
.end method
