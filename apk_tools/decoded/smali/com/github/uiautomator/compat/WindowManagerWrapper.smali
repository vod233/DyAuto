.class public Lcom/github/uiautomator/compat/WindowManagerWrapper;
.super Ljava/lang/Object;
.source "WindowManagerWrapper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;,
        Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;,
        Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;,
        Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;
    }
.end annotation


# instance fields
.field private rotationInjector:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;

.field private windowManager:Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 30
    invoke-static {}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->getWindowManager()Ljava/lang/Object;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    .line 33
    :try_start_0
    new-instance v0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;-><init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;)V

    iput-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->rotationInjector:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;
    :try_end_0
    .catch Ljava/lang/UnsupportedOperationException; {:try_start_0 .. :try_end_0} :catch_0

    .line 36
    goto :goto_0

    .line 34
    :catch_0
    move-exception v0

    .line 35
    .local v0, "e":Ljava/lang/UnsupportedOperationException;
    new-instance v1, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;-><init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;)V

    iput-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->rotationInjector:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;

    .line 37
    .end local v0    # "e":Ljava/lang/UnsupportedOperationException;
    :goto_0
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/compat/WindowManagerWrapper;

    .line 15
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    return-object v0
.end method

.method public static getWindowManager()Ljava/lang/Object;
    .locals 2

    .line 139
    const-string v0, "window"

    const-string v1, "android.view.IWindowManager$Stub"

    invoke-static {v0, v1}, Lcom/github/uiautomator/util/InternalApi;->getServiceAsInterface(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public freezeRotation(I)V
    .locals 1
    .param p1, "rotation"    # I

    .line 40
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->rotationInjector:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;

    invoke-interface {v0, p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;->freezeRotation(I)V

    .line 41
    return-void
.end method

.method public getDisplaySize()Landroid/graphics/Point;
    .locals 8

    .line 48
    const-string v0, "android.hardware.display.DisplayManagerGlobal"

    invoke-static {v0}, Lcom/github/uiautomator/util/InternalApi;->getSingleton(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 50
    .local v0, "displayManager":Ljava/lang/Object;
    :try_start_0
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "getDisplayInfo"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    sget-object v5, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    .line 51
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 52
    .local v1, "displayInfo":Ljava/lang/Object;
    if-eqz v1, :cond_1

    .line 53
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    .line 54
    .local v2, "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    const-string v4, "logicalWidth"

    invoke-virtual {v2, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v4

    .line 55
    .local v4, "width":I
    const-string v5, "logicalHeight"

    invoke-virtual {v2, v5}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v5

    .line 56
    .local v5, "height":I
    const-string v6, "rotation"

    invoke-virtual {v2, v6}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v6

    invoke-virtual {v6, v1}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v6

    .line 57
    .local v6, "rotation":I
    rem-int/lit8 v7, v6, 0x2

    if-ne v7, v3, :cond_0

    .line 58
    xor-int v3, v4, v5

    .line 59
    .end local v4    # "width":I
    .local v3, "width":I
    xor-int/2addr v5, v3

    .line 60
    xor-int v4, v3, v5

    .line 62
    .end local v3    # "width":I
    .restart local v4    # "width":I
    :cond_0
    new-instance v3, Landroid/graphics/Point;

    invoke-direct {v3, v4, v5}, Landroid/graphics/Point;-><init>(II)V
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v3

    .line 52
    .end local v1    # "displayInfo":Ljava/lang/Object;
    .end local v2    # "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    .end local v4    # "width":I
    .end local v5    # "height":I
    .end local v6    # "rotation":I
    :cond_1
    goto :goto_0

    .line 70
    :catch_0
    move-exception v1

    .line 71
    .local v1, "e":Ljava/lang/NoSuchFieldException;
    invoke-virtual {v1}, Ljava/lang/NoSuchFieldException;->printStackTrace()V

    goto :goto_1

    .line 68
    .end local v1    # "e":Ljava/lang/NoSuchFieldException;
    :catch_1
    move-exception v1

    .line 69
    .local v1, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {v1}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    .end local v1    # "e":Ljava/lang/NoSuchMethodException;
    goto :goto_0

    .line 66
    :catch_2
    move-exception v1

    .line 67
    .local v1, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v1}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    .end local v1    # "e":Ljava/lang/reflect/InvocationTargetException;
    goto :goto_0

    .line 64
    :catch_3
    move-exception v1

    .line 65
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 72
    .end local v1    # "e":Ljava/lang/IllegalAccessException;
    :goto_0
    nop

    .line 73
    :goto_1
    const/4 v1, 0x0

    return-object v1
.end method

.method public getRotation()I
    .locals 4

    .line 84
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "getDefaultDisplayRotation"

    new-array v3, v0, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 85
    .local v1, "getter":Ljava/lang/reflect/Method;
    iget-object v2, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    new-array v3, v0, [Ljava/lang/Object;

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    .line 89
    .end local v1    # "getter":Ljava/lang/reflect/Method;
    :catch_0
    move-exception v1

    .line 90
    .local v1, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v1}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 87
    .end local v1    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v1

    .line 88
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .end local v1    # "e":Ljava/lang/IllegalAccessException;
    goto :goto_0

    .line 86
    :catch_2
    move-exception v1

    .line 91
    :goto_0
    nop

    .line 94
    :goto_1
    :try_start_1
    iget-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "getRotation"

    new-array v3, v0, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 95
    .local v1, "getter":Ljava/lang/reflect/Method;
    iget-object v2, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    new-array v3, v0, [Ljava/lang/Object;

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/lang/IllegalAccessException; {:try_start_1 .. :try_end_1} :catch_4
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1 .. :try_end_1} :catch_3

    return v0

    .line 100
    .end local v1    # "getter":Ljava/lang/reflect/Method;
    :catch_3
    move-exception v1

    .line 101
    .local v1, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v1}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_3

    .line 98
    .end local v1    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_4
    move-exception v1

    .line 99
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .end local v1    # "e":Ljava/lang/IllegalAccessException;
    goto :goto_2

    .line 96
    :catch_5
    move-exception v1

    .line 97
    .local v1, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {v1}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    .line 102
    .end local v1    # "e":Ljava/lang/NoSuchMethodException;
    :goto_2
    nop

    .line 104
    :goto_3
    return v0
.end method

.method public thawRotation()V
    .locals 1

    .line 44
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->rotationInjector:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;

    invoke-interface {v0}, Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;->thawRotation()V

    .line 45
    return-void
.end method

.method public watchRotation(Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)Ljava/lang/Object;
    .locals 9
    .param p1, "watcher"    # Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;

    .line 108
    const-string v0, "watchRotation"

    const-string v1, "watchRotation is not supported: "

    new-instance v2, Lcom/github/uiautomator/compat/WindowManagerWrapper$1;

    invoke-direct {v2, p0, p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper$1;-><init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)V

    .line 116
    .local v2, "realWatcher":Landroid/view/IRotationWatcher;
    const/4 v3, 0x1

    const/4 v4, 0x0

    :try_start_0
    iget-object v5, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const/4 v6, 0x2

    new-array v7, v6, [Ljava/lang/Class;

    const-class v8, Landroid/view/IRotationWatcher;

    aput-object v8, v7, v4

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v8, v7, v3

    invoke-virtual {v5, v0, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 117
    .local v5, "getter":Ljava/lang/reflect/Method;
    iget-object v7, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    new-array v6, v6, [Ljava/lang/Object;

    aput-object v2, v6, v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    aput-object v8, v6, v3

    invoke-virtual {v5, v7, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    .line 118
    return-object v2

    .line 133
    .end local v5    # "getter":Ljava/lang/reflect/Method;
    :catch_0
    move-exception v0

    .line 134
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    new-instance v3, Ljava/lang/UnsupportedOperationException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v3, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 131
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 132
    .local v0, "e":Ljava/lang/IllegalAccessException;
    new-instance v3, Ljava/lang/UnsupportedOperationException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v3, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 119
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :catch_2
    move-exception v5

    .line 121
    .local v5, "e":Ljava/lang/NoSuchMethodException;
    :try_start_1
    iget-object v6, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    new-array v7, v3, [Ljava/lang/Class;

    const-class v8, Landroid/view/IRotationWatcher;

    aput-object v8, v7, v4

    invoke-virtual {v6, v0, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 122
    .local v0, "getter":Ljava/lang/reflect/Method;
    iget-object v6, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper;->windowManager:Ljava/lang/Object;

    new-array v3, v3, [Ljava/lang/Object;

    aput-object v2, v3, v4

    invoke-virtual {v0, v6, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_1 .. :try_end_1} :catch_5
    .catch Ljava/lang/IllegalAccessException; {:try_start_1 .. :try_end_1} :catch_4
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1 .. :try_end_1} :catch_3

    .line 123
    return-object v2

    .line 128
    .end local v0    # "getter":Ljava/lang/reflect/Method;
    :catch_3
    move-exception v0

    .line 129
    .local v0, "e2":Ljava/lang/reflect/InvocationTargetException;
    new-instance v3, Ljava/lang/UnsupportedOperationException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v3, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 126
    .end local v0    # "e2":Ljava/lang/reflect/InvocationTargetException;
    :catch_4
    move-exception v0

    .line 127
    .local v0, "e2":Ljava/lang/IllegalAccessException;
    new-instance v3, Ljava/lang/UnsupportedOperationException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v3, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v3

    .line 124
    .end local v0    # "e2":Ljava/lang/IllegalAccessException;
    :catch_5
    move-exception v0

    .line 125
    .local v0, "e2":Ljava/lang/NoSuchMethodException;
    new-instance v3, Ljava/lang/UnsupportedOperationException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/NoSuchMethodException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v3, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v3
.end method
