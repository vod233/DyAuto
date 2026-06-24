.class public Lcom/android/permission/rom/VivoUtils;
.super Ljava/lang/Object;
.source "VivoUtils.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "QikuUtils"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static applyPermission(Landroid/content/Context;)V
    .locals 4
    .param p0, "context"    # Landroid/content/Context;

    .line 52
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const-string v1, "com.iqoo.secure"

    invoke-virtual {v0, v1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v0

    .line 53
    .local v0, "appIntent":Landroid/content/Intent;
    if-eqz v0, :cond_1

    .line 55
    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    .line 56
    instance-of v1, p0, Landroid/app/Activity;

    if-eqz v1, :cond_0

    .line 57
    move-object v1, p0

    check-cast v1, Landroid/app/Activity;

    new-instance v2, Lcom/android/permission/rom/VivoUtils$1;

    invoke-direct {v2, p0}, Lcom/android/permission/rom/VivoUtils$1;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 64
    :catch_0
    move-exception v1

    .line 65
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 67
    instance-of v2, p0, Landroid/app/Activity;

    if-eqz v2, :cond_0

    .line 68
    move-object v2, p0

    check-cast v2, Landroid/app/Activity;

    new-instance v3, Lcom/android/permission/rom/VivoUtils$2;

    invoke-direct {v3, p0}, Lcom/android/permission/rom/VivoUtils$2;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 75
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_0
    :goto_0
    goto :goto_1

    .line 77
    :cond_1
    instance-of v1, p0, Landroid/app/Activity;

    if-eqz v1, :cond_2

    .line 78
    move-object v1, p0

    check-cast v1, Landroid/app/Activity;

    new-instance v2, Lcom/android/permission/rom/VivoUtils$3;

    invoke-direct {v2, p0}, Lcom/android/permission/rom/VivoUtils$3;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 86
    :cond_2
    :goto_1
    return-void
.end method

.method public static checkFloatWindowPermission(Landroid/content/Context;)Z
    .locals 8
    .param p0, "context"    # Landroid/content/Context;

    .line 25
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    .line 26
    .local v0, "version":I
    const/4 v1, 0x1

    const/16 v2, 0x15

    if-lt v0, v2, :cond_2

    .line 28
    const/4 v2, 0x0

    :try_start_0
    invoke-static {p0}, Lcom/android/permission/rom/VivoUtils;->getFloatPermissionStatus(Landroid/content/Context;)I

    move-result v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-nez v3, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1

    .line 29
    :catch_0
    move-exception v3

    .line 30
    .local v3, "e":Ljava/lang/Exception;
    invoke-virtual {v3}, Ljava/lang/Exception;->printStackTrace()V

    .line 33
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x17

    if-lt v4, v5, :cond_1

    .line 35
    :try_start_1
    const-class v4, Landroid/provider/Settings;

    .line 36
    .local v4, "clazz":Ljava/lang/Class;
    const-string v5, "canDrawOverlays"

    new-array v6, v1, [Ljava/lang/Class;

    const-class v7, Landroid/content/Context;

    aput-object v7, v6, v2

    invoke-virtual {v4, v5, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 37
    .local v5, "canDrawOverlays":Ljava/lang/reflect/Method;
    const/4 v6, 0x0

    new-array v7, v1, [Ljava/lang/Object;

    aput-object p0, v7, v2

    invoke-virtual {v5, v6, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v1

    .line 38
    .end local v4    # "clazz":Ljava/lang/Class;
    .end local v5    # "canDrawOverlays":Ljava/lang/reflect/Method;
    :catch_1
    move-exception v2

    .line 39
    .local v2, "e1":Ljava/lang/Exception;
    invoke-static {v2}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "QikuUtils"

    invoke-static {v5, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 42
    .end local v2    # "e1":Ljava/lang/Exception;
    :cond_1
    return v1

    .line 45
    .end local v3    # "e":Ljava/lang/Exception;
    :cond_2
    return v1
.end method

.method public static getFloatPermissionStatus(Landroid/content/Context;)I
    .locals 9
    .param p0, "context"    # Landroid/content/Context;

    .line 95
    if-eqz p0, :cond_3

    .line 98
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 99
    .local v0, "packageName":Ljava/lang/String;
    const-string v1, "content://com.iqoo.secure.provider.secureprovider/allowfloatwindowapp"

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 100
    .local v1, "uri":Landroid/net/Uri;
    const-string v8, "pkgname = ?"

    .line 101
    .local v8, "selection":Ljava/lang/String;
    const/4 v2, 0x1

    new-array v6, v2, [Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v0, v6, v2

    .line 102
    .local v6, "selectionArgs":[Ljava/lang/String;
    nop

    .line 103
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const/4 v4, 0x0

    const/4 v7, 0x0

    .line 104
    move-object v3, v1

    move-object v5, v8

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2

    .line 105
    .local v2, "cursor":Landroid/database/Cursor;
    if-eqz v2, :cond_2

    .line 106
    invoke-interface {v2}, Landroid/database/Cursor;->getColumnNames()[Ljava/lang/String;

    .line 107
    invoke-interface {v2}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 108
    const-string v3, "currentlmode"

    invoke-interface {v2, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    .line 109
    .local v3, "columnIndex":I
    const/4 v4, 0x0

    .line 110
    .local v4, "currentMode":I
    const/4 v5, -0x1

    if-eq v3, v5, :cond_0

    .line 111
    invoke-interface {v2, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    .line 113
    :cond_0
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 114
    return v4

    .line 116
    .end local v3    # "columnIndex":I
    .end local v4    # "currentMode":I
    :cond_1
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 117
    invoke-static {p0}, Lcom/android/permission/rom/VivoUtils;->getFloatPermissionStatus2(Landroid/content/Context;)I

    move-result v3

    return v3

    .line 121
    :cond_2
    invoke-static {p0}, Lcom/android/permission/rom/VivoUtils;->getFloatPermissionStatus2(Landroid/content/Context;)I

    move-result v3

    return v3

    .line 96
    .end local v0    # "packageName":Ljava/lang/String;
    .end local v1    # "uri":Landroid/net/Uri;
    .end local v2    # "cursor":Landroid/database/Cursor;
    .end local v6    # "selectionArgs":[Ljava/lang/String;
    .end local v8    # "selection":Ljava/lang/String;
    :cond_3
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "context is null"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private static getFloatPermissionStatus2(Landroid/content/Context;)I
    .locals 10
    .param p0, "context"    # Landroid/content/Context;

    .line 132
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 133
    .local v0, "packageName":Ljava/lang/String;
    const-string v1, "content://com.vivo.permissionmanager.provider.permission/float_window_apps"

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 134
    .local v1, "uri2":Landroid/net/Uri;
    const-string v8, "pkgname = ?"

    .line 135
    .local v8, "selection":Ljava/lang/String;
    const/4 v9, 0x1

    new-array v6, v9, [Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v0, v6, v2

    .line 136
    .local v6, "selectionArgs":[Ljava/lang/String;
    nop

    .line 137
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 138
    const/4 v4, 0x0

    const/4 v7, 0x0

    move-object v3, v1

    move-object v5, v8

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2

    .line 139
    .local v2, "cursor":Landroid/database/Cursor;
    if-eqz v2, :cond_2

    .line 140
    invoke-interface {v2}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 141
    const-string v3, "currentmode"

    invoke-interface {v2, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    .line 142
    .local v3, "columnIndex":I
    const/4 v4, 0x0

    .line 143
    .local v4, "currentmode":I
    const/4 v5, -0x1

    if-eq v3, v5, :cond_0

    .line 144
    invoke-interface {v2, v3}, Landroid/database/Cursor;->getInt(I)I

    .line 146
    :cond_0
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 147
    return v4

    .line 149
    .end local v3    # "columnIndex":I
    .end local v4    # "currentmode":I
    :cond_1
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 150
    return v9

    .line 153
    :cond_2
    return v9
.end method
