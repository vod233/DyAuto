.class public Lcom/github/uiautomator/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# static fields
.field private static final REQUEST_IGNORE_BATTERY_OPTIMIZATIONS:I = 0x3e9


# instance fields
.field private final TAG:Ljava/lang/String;

.field private floatView:Lcom/github/uiautomator/FloatView;

.field private textViewIP:Landroid/widget/TextView;

.field private tvInStorage:Landroid/widget/TextView;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 31
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 32
    const-string v0, "ATXMainActivity"

    iput-object v0, p0, Lcom/github/uiautomator/MainActivity;->TAG:Ljava/lang/String;

    return-void
.end method

.method private getAppVersionName()Ljava/lang/String;
    .locals 3

    .line 88
    :try_start_0
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    .line 89
    .local v0, "packageInfo":Landroid/content/pm/PackageInfo;
    iget-object v1, v0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    .line 90
    .end local v0    # "packageInfo":Landroid/content/pm/PackageInfo;
    :catch_0
    move-exception v0

    .line 91
    .local v0, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    invoke-virtual {v0}, Landroid/content/pm/PackageManager$NameNotFoundException;->printStackTrace()V

    .line 92
    const/4 v1, 0x0

    return-object v1
.end method

.method private isIgnoringBatteryOptimizations()Z
    .locals 3

    .line 134
    const/4 v0, 0x0

    .line 135
    .local v0, "isIgnoring":Z
    const-string v1, "power"

    invoke-virtual {p0, v1}, Lcom/github/uiautomator/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/PowerManager;

    .line 136
    .local v1, "powerManager":Landroid/os/PowerManager;
    if-eqz v1, :cond_0

    .line 137
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/os/PowerManager;->isIgnoringBatteryOptimizations(Ljava/lang/String;)Z

    move-result v0

    .line 139
    :cond_0
    return v0
.end method

.method private showToast(Ljava/lang/String;)V
    .locals 2
    .param p1, "message"    # Ljava/lang/String;

    .line 143
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 144
    return-void
.end method


# virtual methods
.method public checkNetworkAddress(Landroid/view/View;)V
    .locals 5
    .param p1, "v"    # Landroid/view/View;

    .line 174
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "wifi"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/wifi/WifiManager;

    .line 175
    .local v0, "wifiManager":Landroid/net/wifi/WifiManager;
    invoke-virtual {v0}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v1

    invoke-virtual {v1}, Landroid/net/wifi/WifiInfo;->getIpAddress()I

    move-result v1

    .line 176
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

    .line 177
    .local v2, "ipStr":Ljava/lang/String;
    iget-object v3, p0, Lcom/github/uiautomator/MainActivity;->textViewIP:Landroid/widget/TextView;

    invoke-virtual {v3, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 178
    iget-object v3, p0, Lcom/github/uiautomator/MainActivity;->textViewIP:Landroid/widget/TextView;

    const v4, -0xffff01

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 179
    return-void
.end method

.method public dismissFloatWindow(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 159
    iget-object v0, p0, Lcom/github/uiautomator/MainActivity;->floatView:Lcom/github/uiautomator/FloatView;

    if-eqz v0, :cond_0

    .line 160
    const-string v0, "ATXMainActivity"

    const-string v1, "remove floatView immediate"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 161
    iget-object v0, p0, Lcom/github/uiautomator/MainActivity;->floatView:Lcom/github/uiautomator/FloatView;

    invoke-virtual {v0}, Lcom/github/uiautomator/FloatView;->hide()V

    .line 163
    :cond_0
    return-void
.end method

.method synthetic lambda$onCreate$0$com-github-uiautomator-MainActivity(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;

    .line 48
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/github/uiautomator/Service;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->stopService(Landroid/content/Intent;)Z

    .line 49
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->finish()V

    .line 50
    return-void
.end method

.method synthetic lambda$onCreate$1$com-github-uiautomator-MainActivity(Landroid/view/View;)V
    .locals 4
    .param p1, "v"    # Landroid/view/View;

    .line 54
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/github/uiautomator/IdentifyActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 55
    .local v0, "intent":Landroid/content/Intent;
    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    .line 56
    .local v1, "bundle":Landroid/os/Bundle;
    const-string v2, "theme"

    const-string v3, "RED"

    invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 57
    invoke-virtual {v0, v1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;

    .line 58
    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 59
    return-void
.end method

.method synthetic lambda$onCreate$2$com-github-uiautomator-MainActivity(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;

    .line 61
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.ACCESSIBILITY_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method synthetic lambda$onCreate$3$com-github-uiautomator-MainActivity(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;

    .line 63
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.APPLICATION_DEVELOPMENT_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 116
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    .line 117
    const/16 v0, 0x3e9

    if-ne p1, v0, :cond_1

    .line 119
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "requestIgnoreBatteryOptimizations resultCode: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ATXMainActivity"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 120
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_1

    .line 121
    invoke-direct {p0}, Lcom/github/uiautomator/MainActivity;->isIgnoringBatteryOptimizations()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 123
    const-string v0, "requestIgnoreBatteryOptimizations success"

    invoke-direct {p0, v0}, Lcom/github/uiautomator/MainActivity;->showToast(Ljava/lang/String;)V

    goto :goto_0

    .line 125
    :cond_0
    const-string v0, "requestIgnoreBatteryOptimizations failure"

    invoke-direct {p0, v0}, Lcom/github/uiautomator/MainActivity;->showToast(Ljava/lang/String;)V

    .line 130
    :cond_1
    :goto_0
    return-void
.end method

.method public onBackPressed()V
    .locals 1

    .line 188
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->moveTaskToBack(Z)Z

    .line 189
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 9
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 43
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 44
    const v0, 0x7f0a001c

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->setContentView(I)V

    .line 46
    const v0, 0x7f070043

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 47
    .local v0, "btnFinish":Landroid/widget/Button;
    new-instance v1, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/github/uiautomator/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 52
    const v1, 0x7f070044

    invoke-virtual {p0, v1}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 53
    .local v1, "btnIdentify":Landroid/widget/Button;
    new-instance v2, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0}, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/github/uiautomator/MainActivity;)V

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 61
    const v2, 0x7f070006

    invoke-virtual {p0, v2}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    new-instance v3, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda2;

    invoke-direct {v3, p0}, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda2;-><init>(Lcom/github/uiautomator/MainActivity;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 63
    const v2, 0x7f070051

    invoke-virtual {p0, v2}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    new-instance v3, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda3;

    invoke-direct {v3, p0}, Lcom/github/uiautomator/MainActivity$$ExternalSyntheticLambda3;-><init>(Lcom/github/uiautomator/MainActivity;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 65
    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    .line 66
    .local v2, "intent":Landroid/content/Intent;
    const-string v3, "hide"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v3

    .line 67
    .local v3, "isHide":Z
    if-eqz v3, :cond_0

    .line 68
    const-string v4, "ATXMainActivity"

    const-string v5, "launch args hide:true, move to background"

    invoke-static {v4, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 69
    const/4 v4, 0x1

    invoke-virtual {p0, v4}, Lcom/github/uiautomator/MainActivity;->moveTaskToBack(Z)Z

    .line 71
    :cond_0
    const v4, 0x7f070062

    invoke-virtual {p0, v4}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v4

    check-cast v4, Landroid/widget/TextView;

    iput-object v4, p0, Lcom/github/uiautomator/MainActivity;->textViewIP:Landroid/widget/TextView;

    .line 72
    const v4, 0x7f070060

    invoke-virtual {p0, v4}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v4

    check-cast v4, Landroid/widget/TextView;

    iput-object v4, p0, Lcom/github/uiautomator/MainActivity;->tvInStorage:Landroid/widget/TextView;

    .line 74
    const-string v4, "android.permission.ACCESS_COARSE_LOCATION"

    const-string v5, "android.permission.READ_PHONE_STATE"

    const-string v6, "android.permission.READ_PHONE_NUMBERS"

    const-string v7, "android.permission.READ_SMS"

    const-string v8, "android.permission.RECEIVE_SMS"

    filled-new-array {v4, v5, v6, v7, v8}, [Ljava/lang/String;

    move-result-object v4

    .line 80
    .local v4, "permissions":[Ljava/lang/String;
    invoke-static {p0, v4}, Lcom/github/uiautomator/util/Permissons4App;->initPermissions(Landroid/app/Activity;[Ljava/lang/String;)V

    .line 82
    const v5, 0x7f07003e

    invoke-virtual {p0, v5}, Lcom/github/uiautomator/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v5

    check-cast v5, Landroid/widget/TextView;

    .line 83
    .local v5, "viewVersion":Landroid/widget/TextView;
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "version: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/github/uiautomator/MainActivity;->getAppVersionName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 84
    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 194
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 197
    const-string v0, "ATXMainActivity"

    const-string v1, "unbind service"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 198
    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 0
    .param p1, "requestCode"    # I
    .param p2, "permissions"    # [Ljava/lang/String;
    .param p3, "grantResults"    # [I

    .line 103
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    .line 104
    invoke-static {p1, p2, p3}, Lcom/github/uiautomator/util/Permissons4App;->handleRequestPermissionsResult(I[Ljava/lang/String;[I)V

    .line 105
    return-void
.end method

.method protected onRestart()V
    .locals 0

    .line 183
    invoke-super {p0}, Landroid/app/Activity;->onRestart()V

    .line 184
    return-void
.end method

.method protected onResume()V
    .locals 4

    .line 168
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 169
    iget-object v0, p0, Lcom/github/uiautomator/MainActivity;->tvInStorage:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/github/uiautomator/util/MemoryManager;->getAvailableInternalMemorySize()J

    move-result-wide v2

    invoke-static {p0, v2, v3}, Landroid/text/format/Formatter;->formatFileSize(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/github/uiautomator/util/MemoryManager;->getTotalExternalMemorySize()J

    move-result-wide v2

    invoke-static {p0, v2, v3}, Landroid/text/format/Formatter;->formatFileSize(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 170
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/MainActivity;->checkNetworkAddress(Landroid/view/View;)V

    .line 171
    return-void
.end method

.method protected onStart()V
    .locals 0

    .line 98
    invoke-super {p0}, Landroid/app/Activity;->onStart()V

    .line 99
    return-void
.end method

.method public requestIgnoreBatteryOptimizations(Landroid/view/View;)V
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 108
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 109
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 110
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/github/uiautomator/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 111
    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Lcom/github/uiautomator/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 112
    return-void
.end method

.method public showFloatWindow(Landroid/view/View;)V
    .locals 3
    .param p1, "view"    # Landroid/view/View;

    .line 147
    invoke-static {}, Lcom/android/permission/FloatWindowManager;->getInstance()Lcom/android/permission/FloatWindowManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/android/permission/FloatWindowManager;->checkFloatPermission(Landroid/content/Context;)Z

    move-result v0

    .line 148
    .local v0, "floatEnabled":Z
    if-nez v0, :cond_0

    .line 149
    const-string v1, "ATXMainActivity"

    const-string v2, "float permission not checked"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    return-void

    .line 152
    :cond_0
    iget-object v1, p0, Lcom/github/uiautomator/MainActivity;->floatView:Lcom/github/uiautomator/FloatView;

    if-nez v1, :cond_1

    .line 153
    new-instance v1, Lcom/github/uiautomator/FloatView;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/FloatView;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/github/uiautomator/MainActivity;->floatView:Lcom/github/uiautomator/FloatView;

    .line 155
    :cond_1
    iget-object v1, p0, Lcom/github/uiautomator/MainActivity;->floatView:Lcom/github/uiautomator/FloatView;

    invoke-virtual {v1}, Lcom/github/uiautomator/FloatView;->show()V

    .line 156
    return-void
.end method
