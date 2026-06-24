.class Lcom/github/uiautomator/monitor/WifiMonitor$1;
.super Landroid/content/BroadcastReceiver;
.source "WifiMonitor.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/monitor/WifiMonitor;->init()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/monitor/WifiMonitor;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/monitor/WifiMonitor;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/monitor/WifiMonitor;

    .line 31
    iput-object p1, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 10
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 34
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    const-string v1, "android.net.wifi.STATE_CHANGE"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "wifi"

    if-eqz v0, :cond_0

    .line 35
    const-string v0, "wifi_state"

    const/4 v2, 0x0

    invoke-virtual {p2, v0, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    .line 36
    .local v0, "wifiState":I
    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 39
    :pswitch_0
    iget-object v3, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    iget-object v4, v3, Lcom/github/uiautomator/monitor/WifiMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    invoke-static {v3, v4, v1}, Lcom/github/uiautomator/monitor/WifiMonitor;->access$000(Lcom/github/uiautomator/monitor/WifiMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V

    .line 40
    iget-object v3, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    iget-object v4, v3, Lcom/github/uiautomator/monitor/WifiMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    new-instance v5, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;

    iget-object v6, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    const-string v7, ""

    invoke-direct {v5, v6, v2, v7}, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;-><init>(Lcom/github/uiautomator/monitor/WifiMonitor;ZLjava/lang/String;)V

    invoke-virtual {v5}, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v4, v2}, Lcom/github/uiautomator/monitor/WifiMonitor;->access$000(Lcom/github/uiautomator/monitor/WifiMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V

    .line 45
    .end local v0    # "wifiState":I
    :cond_0
    :goto_0
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    const-string v2, "android.net.conn.CONNECTIVITY_CHANGE"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 47
    const-string v0, "networkInfo"

    invoke-virtual {p2, v0}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v0

    check-cast v0, Landroid/net/NetworkInfo;

    .line 48
    .local v0, "info":Landroid/net/NetworkInfo;
    if-eqz v0, :cond_1

    .line 50
    sget-object v2, Landroid/net/NetworkInfo$State;->CONNECTED:Landroid/net/NetworkInfo$State;

    invoke-virtual {v0}, Landroid/net/NetworkInfo;->getState()Landroid/net/NetworkInfo$State;

    move-result-object v3

    if-ne v2, v3, :cond_1

    invoke-virtual {v0}, Landroid/net/NetworkInfo;->isAvailable()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 51
    move-object v2, p1

    check-cast v2, Lcom/github/uiautomator/Service;

    invoke-virtual {v2, v1}, Lcom/github/uiautomator/Service;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/wifi/WifiManager;

    .line 52
    .local v2, "wifi":Landroid/net/wifi/WifiManager;
    invoke-virtual {v2}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v3

    .line 53
    .local v3, "wInfo":Landroid/net/wifi/WifiInfo;
    iget-object v4, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    iget-object v5, v4, Lcom/github/uiautomator/monitor/WifiMonitor;->notifier:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    new-instance v6, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;

    iget-object v7, p0, Lcom/github/uiautomator/monitor/WifiMonitor$1;->this$0:Lcom/github/uiautomator/monitor/WifiMonitor;

    const/4 v8, 0x1

    invoke-virtual {v3}, Landroid/net/wifi/WifiInfo;->getSSID()Ljava/lang/String;

    move-result-object v9

    invoke-direct {v6, v7, v8, v9}, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;-><init>(Lcom/github/uiautomator/monitor/WifiMonitor;ZLjava/lang/String;)V

    invoke-virtual {v6}, Lcom/github/uiautomator/monitor/WifiMonitor$WifiInfos;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v4, v5, v6}, Lcom/github/uiautomator/monitor/WifiMonitor;->access$000(Lcom/github/uiautomator/monitor/WifiMonitor;Lcom/github/uiautomator/monitor/HttpPostNotifier;Ljava/lang/String;)V

    .line 57
    .end local v0    # "info":Landroid/net/NetworkInfo;
    .end local v2    # "wifi":Landroid/net/wifi/WifiManager;
    .end local v3    # "wInfo":Landroid/net/wifi/WifiInfo;
    :cond_1
    invoke-virtual {p1, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/wifi/WifiManager;

    .line 58
    .local v0, "wifiManager":Landroid/net/wifi/WifiManager;
    invoke-virtual {v0}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v1

    invoke-virtual {v1}, Landroid/net/wifi/WifiInfo;->getIpAddress()I

    move-result v1

    .line 59
    .local v1, "ip":I
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    and-int/lit16 v3, v1, 0xff

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    shr-int/lit8 v4, v1, 0x8

    and-int/lit16 v4, v4, 0xff

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    shr-int/lit8 v4, v1, 0x10

    and-int/lit16 v4, v4, 0xff

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    shr-int/lit8 v3, v1, 0x18

    and-int/lit16 v3, v3, 0xff

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 60
    .local v2, "ipStr":Ljava/lang/String;
    move-object v3, p1

    check-cast v3, Lcom/github/uiautomator/Service;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const v5, 0x7f0c0027

    invoke-virtual {p1, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/github/uiautomator/Service;->setNotificationContentText(Ljava/lang/String;)V

    .line 61
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method
