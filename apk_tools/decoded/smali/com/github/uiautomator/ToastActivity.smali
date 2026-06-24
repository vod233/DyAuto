.class public Lcom/github/uiautomator/ToastActivity;
.super Landroid/app/Activity;
.source "ToastActivity.java"


# static fields
.field static final TAG:Ljava/lang/String; = "ToastActivity"

.field private static floatView:Lcom/github/uiautomator/FloatView;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private getFloatView()Lcom/github/uiautomator/FloatView;
    .locals 1

    .line 51
    sget-object v0, Lcom/github/uiautomator/ToastActivity;->floatView:Lcom/github/uiautomator/FloatView;

    if-nez v0, :cond_0

    .line 52
    new-instance v0, Lcom/github/uiautomator/FloatView;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/FloatView;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/github/uiautomator/ToastActivity;->floatView:Lcom/github/uiautomator/FloatView;

    .line 54
    :cond_0
    sget-object v0, Lcom/github/uiautomator/ToastActivity;->floatView:Lcom/github/uiautomator/FloatView;

    return-object v0
.end method


# virtual methods
.method public onBackPressed()V
    .locals 1

    .line 59
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/ToastActivity;->moveTaskToBack(Z)Z

    .line 60
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 19
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 21
    const-string v0, "ToastActivity"

    const-string v1, "onCreate"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 22
    invoke-virtual {p0}, Lcom/github/uiautomator/ToastActivity;->getIntent()Landroid/content/Intent;

    move-result-object v1

    .line 24
    .local v1, "intent":Landroid/content/Intent;
    const-string v2, "message"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 25
    .local v2, "message":Ljava/lang/String;
    if-eqz v2, :cond_0

    const-string v3, ""

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    .line 26
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "openatx: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    .line 29
    :cond_0
    const-string v3, "showFloatWindow"

    invoke-virtual {v1, v3}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 30
    .local v3, "showFloat":Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "showFloat: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 32
    invoke-static {}, Lcom/android/permission/FloatWindowManager;->getInstance()Lcom/android/permission/FloatWindowManager;

    move-result-object v4

    invoke-virtual {v4, p0}, Lcom/android/permission/FloatWindowManager;->checkPermission(Landroid/content/Context;)Z

    move-result v4

    .line 33
    .local v4, "floatEnabled":Z
    if-nez v4, :cond_1

    .line 34
    const-string v5, "floatPermission is not enabled"

    invoke-static {v0, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 36
    :cond_1
    const-string v0, "true"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 37
    invoke-direct {p0}, Lcom/github/uiautomator/ToastActivity;->getFloatView()Lcom/github/uiautomator/FloatView;

    move-result-object v0

    invoke-virtual {v0}, Lcom/github/uiautomator/FloatView;->show()V

    goto :goto_0

    .line 38
    :cond_2
    const-string v0, "false"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 39
    invoke-direct {p0}, Lcom/github/uiautomator/ToastActivity;->getFloatView()Lcom/github/uiautomator/FloatView;

    move-result-object v0

    invoke-virtual {v0}, Lcom/github/uiautomator/FloatView;->hide()V

    .line 42
    :cond_3
    :goto_0
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/ToastActivity;->moveTaskToBack(Z)Z

    .line 43
    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 47
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 48
    return-void
.end method
