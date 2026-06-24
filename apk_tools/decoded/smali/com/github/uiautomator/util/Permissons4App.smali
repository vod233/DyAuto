.class public Lcom/github/uiautomator/util/Permissons4App;
.super Ljava/lang/Object;
.source "Permissons4App.java"


# static fields
.field private static final PERMISSION_REQUEST_CODE:I = 0x3e8

.field private static final TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 12
    const-class v0, Lcom/github/uiautomator/util/Permissons4App;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/github/uiautomator/util/Permissons4App;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static checkPermissionAllGranted(Landroid/content/Context;[Ljava/lang/String;)Z
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "permissions"    # [Ljava/lang/String;

    .line 47
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_1

    .line 48
    aget-object v1, p1, v0

    invoke-static {p0, v1}, Landroidx/core/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_0

    .line 49
    const/4 v1, 0x0

    return v1

    .line 47
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 52
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x1

    return v0
.end method

.method public static handleRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 1
    .param p0, "requestCode"    # I
    .param p1, "permissions"    # [Ljava/lang/String;
    .param p2, "grantResults"    # [I

    .line 59
    const/16 v0, 0x3e8

    invoke-static {p0, p1, p2, v0}, Lcom/github/uiautomator/util/Permissons4App;->handleRequestPermissionsResult(I[Ljava/lang/String;[II)V

    .line 60
    return-void
.end method

.method public static handleRequestPermissionsResult(I[Ljava/lang/String;[II)V
    .locals 3
    .param p0, "requestCode"    # I
    .param p1, "permissions"    # [Ljava/lang/String;
    .param p2, "grantResults"    # [I
    .param p3, "customRequestCode"    # I

    .line 66
    if-ne p0, p3, :cond_1

    .line 67
    const/4 v0, 0x1

    .line 69
    .local v0, "isAllGranted":Z
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v2, p2

    if-ge v1, v2, :cond_1

    .line 70
    aget v2, p2, v1

    if-eqz v2, :cond_0

    .line 71
    const/4 v0, 0x0

    .line 72
    goto :goto_1

    .line 69
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 79
    .end local v0    # "isAllGranted":Z
    .end local v1    # "i":I
    :cond_1
    :goto_1
    return-void
.end method

.method public static initPermissions(Landroid/app/Activity;[Ljava/lang/String;)V
    .locals 1
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "permissions"    # [Ljava/lang/String;

    .line 18
    const/16 v0, 0x3e8

    invoke-static {p0, p1, v0}, Lcom/github/uiautomator/util/Permissons4App;->initPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    .line 19
    return-void
.end method

.method public static initPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V
    .locals 2
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "permissions"    # [Ljava/lang/String;
    .param p2, "requestCode"    # I

    .line 25
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_1

    .line 26
    invoke-static {p0, p1}, Lcom/github/uiautomator/util/Permissons4App;->isAllGranted(Landroid/content/Context;[Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 27
    sget-object v0, Lcom/github/uiautomator/util/Permissons4App;->TAG:Ljava/lang/String;

    const-string v1, "Permissions all granted"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 29
    :cond_0
    sget-object v0, Lcom/github/uiautomator/util/Permissons4App;->TAG:Ljava/lang/String;

    const-string v1, "Request permissions"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    invoke-static {p0, p1, p2}, Landroidx/core/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    .line 33
    :cond_1
    :goto_0
    return-void
.end method

.method private static isAllGranted(Landroid/content/Context;[Ljava/lang/String;)Z
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "permissions"    # [Ljava/lang/String;

    .line 39
    invoke-static {p0, p1}, Lcom/github/uiautomator/util/Permissons4App;->checkPermissionAllGranted(Landroid/content/Context;[Ljava/lang/String;)Z

    move-result v0

    return v0
.end method
