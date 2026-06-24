.class public Lcom/android/permission/FloatWindowManager;
.super Ljava/lang/Object;
.source "FloatWindowManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/permission/FloatWindowManager$OnConfirmResult;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "FloatWindowManager"

.field private static volatile instance:Lcom/android/permission/FloatWindowManager;


# instance fields
.field private dialog:Landroid/app/Dialog;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private ROM360PermissionApply(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 185
    const-string v0, "FloatWindowManager"

    const-string v1, "Request 360 permission"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 186
    new-instance v0, Lcom/android/permission/FloatWindowManager$1;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$1;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 196
    return-void
.end method

.method private commonROMPermissionApply(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 258
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMeizuRom()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 259
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->meizuROMPermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 261
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_1

    .line 262
    new-instance v0, Lcom/android/permission/FloatWindowManager$6;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$6;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 279
    :cond_1
    :goto_0
    return-void
.end method

.method public static commonROMPermissionApplyInternal(Landroid/content/Context;)V
    .locals 5
    .param p0, "context"    # Landroid/content/Context;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/NoSuchFieldException;,
            Ljava/lang/IllegalAccessException;
        }
    .end annotation

    .line 282
    const-class v0, Landroid/provider/Settings;

    .line 283
    .local v0, "clazz":Ljava/lang/Class;
    const-string v1, "ACTION_MANAGE_OVERLAY_PERMISSION"

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    .line 285
    .local v1, "field":Ljava/lang/reflect/Field;
    new-instance v2, Landroid/content/Intent;

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 286
    .local v2, "intent":Landroid/content/Intent;
    const/high16 v3, 0x10000000

    invoke-virtual {v2, v3}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    .line 287
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "package:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 288
    invoke-virtual {p0, v2}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    .line 289
    return-void
.end method

.method private commonROMPermissionCheck(Landroid/content/Context;)Z
    .locals 7
    .param p1, "context"    # Landroid/content/Context;

    .line 111
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMeizuRom()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 112
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->meizuPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 114
    :cond_0
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isVivoSystem()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 115
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->vivoPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 117
    :cond_1
    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    .line 118
    .local v1, "result":Ljava/lang/Boolean;
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x17

    if-lt v2, v3, :cond_2

    .line 120
    :try_start_0
    const-class v2, Landroid/provider/Settings;

    .line 121
    .local v2, "clazz":Ljava/lang/Class;
    const-string v3, "canDrawOverlays"

    new-array v4, v0, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 122
    .local v3, "canDrawOverlays":Ljava/lang/reflect/Method;
    const/4 v4, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    aput-object p1, v0, v6

    invoke-virtual {v3, v4, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v1, v0

    .line 125
    .end local v2    # "clazz":Ljava/lang/Class;
    .end local v3    # "canDrawOverlays":Ljava/lang/reflect/Method;
    goto :goto_0

    .line 123
    :catch_0
    move-exception v0

    .line 124
    .local v0, "e":Ljava/lang/Exception;
    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "FloatWindowManager"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_2
    :goto_0
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static getInstance()Lcom/android/permission/FloatWindowManager;
    .locals 2

    .line 45
    sget-object v0, Lcom/android/permission/FloatWindowManager;->instance:Lcom/android/permission/FloatWindowManager;

    if-nez v0, :cond_1

    .line 46
    const-class v0, Lcom/android/permission/FloatWindowManager;

    monitor-enter v0

    .line 47
    :try_start_0
    sget-object v1, Lcom/android/permission/FloatWindowManager;->instance:Lcom/android/permission/FloatWindowManager;

    if-nez v1, :cond_0

    .line 48
    new-instance v1, Lcom/android/permission/FloatWindowManager;

    invoke-direct {v1}, Lcom/android/permission/FloatWindowManager;-><init>()V

    sput-object v1, Lcom/android/permission/FloatWindowManager;->instance:Lcom/android/permission/FloatWindowManager;

    .line 50
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 52
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/permission/FloatWindowManager;->instance:Lcom/android/permission/FloatWindowManager;

    return-object v0
.end method

.method private huaweiPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 86
    invoke-static {p1}, Lcom/android/permission/rom/HuaweiUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private huaweiROMPermissionApply(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 199
    const-string v0, "FloatWindowManager"

    const-string v1, "Request HAWEI permission"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 200
    new-instance v0, Lcom/android/permission/FloatWindowManager$2;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$2;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 210
    return-void
.end method

.method private meizuPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 94
    invoke-static {p1}, Lcom/android/permission/rom/MeizuUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private meizuROMPermissionApply(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 213
    const-string v0, "FloatWindowManager"

    const-string v1, "Request Flyme permission"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 214
    new-instance v0, Lcom/android/permission/FloatWindowManager$3;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$3;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 224
    return-void
.end method

.method private miuiPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 90
    invoke-static {p1}, Lcom/android/permission/rom/MiuiUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private miuiROMPermissionApply(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 227
    const-string v0, "FloatWindowManager"

    const-string v1, "Request MIUI permission"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 228
    new-instance v0, Lcom/android/permission/FloatWindowManager$4;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$4;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 238
    return-void
.end method

.method private oppoROMPermissionApply(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 241
    new-instance v0, Lcom/android/permission/FloatWindowManager$5;

    invoke-direct {v0, p0, p1}, Lcom/android/permission/FloatWindowManager$5;-><init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 251
    return-void
.end method

.method private oppoROMPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 102
    invoke-static {p1}, Lcom/android/permission/rom/OppoUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private qikuPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 98
    invoke-static {p1}, Lcom/android/permission/rom/QikuUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private showConfirmDialog(Landroid/content/Context;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "result"    # Lcom/android/permission/FloatWindowManager$OnConfirmResult;

    .line 292
    const-string v0, "\u60a8\u7684\u624b\u673a\u6ca1\u6709\u6388\u4e88\u60ac\u6d6e\u7a97\u6743\u9650\uff0c\u8bf7\u5f00\u542f\u540e\u518d\u8bd5"

    invoke-direct {p0, p1, v0, p2}, Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Ljava/lang/String;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 293
    return-void
.end method

.method private showConfirmDialog(Landroid/content/Context;Ljava/lang/String;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "message"    # Ljava/lang/String;
    .param p3, "result"    # Lcom/android/permission/FloatWindowManager$OnConfirmResult;

    .line 296
    iget-object v0, p0, Lcom/android/permission/FloatWindowManager;->dialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 297
    iget-object v0, p0, Lcom/android/permission/FloatWindowManager;->dialog:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    .line 300
    :cond_0
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 301
    invoke-virtual {v0, p2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/android/permission/FloatWindowManager$8;

    invoke-direct {v1, p0, p3}, Lcom/android/permission/FloatWindowManager$8;-><init>(Lcom/android/permission/FloatWindowManager;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 302
    const-string v2, "\u73b0\u5728\u53bb\u5f00\u542f"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/android/permission/FloatWindowManager$7;

    invoke-direct {v1, p0, p3}, Lcom/android/permission/FloatWindowManager$7;-><init>(Lcom/android/permission/FloatWindowManager;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V

    .line 309
    const-string v2, "\u6682\u4e0d\u5f00\u542f"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 317
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v0

    iput-object v0, p0, Lcom/android/permission/FloatWindowManager;->dialog:Landroid/app/Dialog;

    .line 318
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    .line 319
    return-void
.end method

.method private vivoPermissionCheck(Landroid/content/Context;)Z
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 106
    invoke-static {p1}, Lcom/android/permission/rom/VivoUtils;->checkFloatWindowPermission(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method


# virtual methods
.method public applyPermission(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 132
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-ge v0, v1, :cond_4

    .line 133
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMiuiRom()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 134
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->miuiROMPermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 135
    :cond_0
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMeizuRom()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 136
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->meizuROMPermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 137
    :cond_1
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsHuaweiRom()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 138
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->huaweiROMPermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 139
    :cond_2
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIs360Rom()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 140
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->ROM360PermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 141
    :cond_3
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isOppoSystem()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 142
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->oppoROMPermissionApply(Landroid/content/Context;)V

    goto :goto_0

    .line 145
    :cond_4
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->commonROMPermissionApply(Landroid/content/Context;)V

    .line 147
    :cond_5
    :goto_0
    return-void
.end method

.method public applyPermissionDirect(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .line 156
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-ge v0, v1, :cond_4

    .line 157
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMiuiRom()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 158
    invoke-static {p1}, Lcom/android/permission/rom/MiuiUtils;->applyMiuiPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 159
    :cond_0
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsHuaweiRom()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 160
    invoke-static {p1}, Lcom/android/permission/rom/HuaweiUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 161
    :cond_1
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIs360Rom()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 162
    invoke-static {p1}, Lcom/android/permission/rom/QikuUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 163
    :cond_2
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isOppoSystem()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 164
    invoke-static {p1}, Lcom/android/permission/rom/OppoUtils;->applyOppoPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 165
    :cond_3
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isVivoSystem()Z

    move-result v0

    if-eqz v0, :cond_7

    .line 166
    invoke-static {p1}, Lcom/android/permission/rom/VivoUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 170
    :cond_4
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMeizuRom()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 171
    invoke-static {p1}, Lcom/android/permission/rom/MeizuUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 172
    :cond_5
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isVivoSystem()Z

    move-result v0

    if-eqz v0, :cond_6

    .line 173
    invoke-static {p1}, Lcom/android/permission/rom/VivoUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 176
    :cond_6
    :try_start_0
    invoke-static {p1}, Lcom/android/permission/FloatWindowManager;->commonROMPermissionApplyInternal(Landroid/content/Context;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 179
    goto :goto_0

    .line 177
    :catch_0
    move-exception v0

    .line 178
    .local v0, "e":Ljava/lang/Exception;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Throw exception "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "FloatWindowManager"

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 182
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_7
    :goto_0
    return-void
.end method

.method public checkFloatPermission(Landroid/content/Context;)Z
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 56
    const-string v0, "FloatWindowManager"

    const-string v1, "Start check permission"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 57
    invoke-virtual {p0, p1}, Lcom/android/permission/FloatWindowManager;->checkPermission(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 58
    const/4 v0, 0x1

    return v0

    .line 60
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/permission/FloatWindowManager;->applyPermission(Landroid/content/Context;)V

    .line 61
    const/4 v0, 0x0

    return v0
.end method

.method public checkPermission(Landroid/content/Context;)Z
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .line 67
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-ge v0, v1, :cond_5

    .line 68
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMiuiRom()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 69
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->miuiPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 70
    :cond_0
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsMeizuRom()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 71
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->meizuPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 72
    :cond_1
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIsHuaweiRom()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 73
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->huaweiPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 74
    :cond_2
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->checkIs360Rom()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 75
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->qikuPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 76
    :cond_3
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isOppoSystem()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 77
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->oppoROMPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 78
    :cond_4
    invoke-static {}, Lcom/android/permission/rom/RomUtils;->isVivoSystem()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 79
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->vivoPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0

    .line 82
    :cond_5
    invoke-direct {p0, p1}, Lcom/android/permission/FloatWindowManager;->commonROMPermissionCheck(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method
