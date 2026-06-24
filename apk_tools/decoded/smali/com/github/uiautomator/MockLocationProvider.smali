.class Lcom/github/uiautomator/MockLocationProvider;
.super Ljava/lang/Object;
.source "MockLocationProvider.java"


# instance fields
.field private ctx:Landroid/content/Context;

.field private providerName:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Landroid/content/Context;)V
    .locals 12
    .param p1, "name"    # Ljava/lang/String;
    .param p2, "ctx"    # Landroid/content/Context;

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 16
    iput-object p1, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    .line 17
    iput-object p2, p0, Lcom/github/uiautomator/MockLocationProvider;->ctx:Landroid/content/Context;

    .line 19
    const-string v0, "location"

    invoke-virtual {p2, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    .line 21
    .local v0, "lm":Landroid/location/LocationManager;
    iget-object v2, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x1

    const/4 v9, 0x1

    const/4 v10, 0x0

    const/4 v11, 0x5

    move-object v1, v0

    invoke-virtual/range {v1 .. v11}, Landroid/location/LocationManager;->addTestProvider(Ljava/lang/String;ZZZZZZZII)V

    .line 23
    iget-object v1, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Landroid/location/LocationManager;->setTestProviderEnabled(Ljava/lang/String;Z)V

    .line 24
    return-void
.end method


# virtual methods
.method pushLocation(DDDF)V
    .locals 4
    .param p1, "lat"    # D
    .param p3, "lon"    # D
    .param p5, "alt"    # D
    .param p7, "accuracy"    # F

    .line 27
    iget-object v0, p0, Lcom/github/uiautomator/MockLocationProvider;->ctx:Landroid/content/Context;

    const-string v1, "location"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    .line 30
    .local v0, "lm":Landroid/location/LocationManager;
    new-instance v1, Landroid/location/Location;

    iget-object v2, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    invoke-direct {v1, v2}, Landroid/location/Location;-><init>(Ljava/lang/String;)V

    .line 31
    .local v1, "mockLocation":Landroid/location/Location;
    invoke-virtual {v1, p1, p2}, Landroid/location/Location;->setLatitude(D)V

    .line 32
    invoke-virtual {v1, p3, p4}, Landroid/location/Location;->setLongitude(D)V

    .line 33
    invoke-virtual {v1, p5, p6}, Landroid/location/Location;->setAltitude(D)V

    .line 34
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Landroid/location/Location;->setTime(J)V

    .line 35
    invoke-virtual {v1, p7}, Landroid/location/Location;->setAccuracy(F)V

    .line 36
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x11

    if-lt v2, v3, :cond_0

    .line 37
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtimeNanos()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Landroid/location/Location;->setElapsedRealtimeNanos(J)V

    .line 39
    :cond_0
    iget-object v2, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    invoke-virtual {v0, v2, v1}, Landroid/location/LocationManager;->setTestProviderLocation(Ljava/lang/String;Landroid/location/Location;)V

    .line 40
    return-void
.end method

.method shutdown()V
    .locals 2

    .line 43
    iget-object v0, p0, Lcom/github/uiautomator/MockLocationProvider;->ctx:Landroid/content/Context;

    const-string v1, "location"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    .line 45
    .local v0, "lm":Landroid/location/LocationManager;
    iget-object v1, p0, Lcom/github/uiautomator/MockLocationProvider;->providerName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->removeTestProvider(Ljava/lang/String;)V

    .line 46
    return-void
.end method
