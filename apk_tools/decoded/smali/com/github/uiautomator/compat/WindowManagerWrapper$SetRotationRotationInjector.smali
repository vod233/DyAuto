.class Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;
.super Ljava/lang/Object;
.source "WindowManagerWrapper.java"

# interfaces
.implements Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationInjector;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/compat/WindowManagerWrapper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "SetRotationRotationInjector"
.end annotation


# instance fields
.field private setRotationInjector:Ljava/lang/reflect/Method;

.field final synthetic this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;)V
    .locals 4

    .line 190
    iput-object p1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 192
    :try_start_0
    invoke-static {p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    const-string v0, "setRotation"

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v2

    const/4 v2, 0x1

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v2

    const/4 v2, 0x2

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v2

    .line 194
    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;->setRotationInjector:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 197
    nop

    .line 198
    return-void

    .line 195
    :catch_0
    move-exception p1

    .line 196
    .local p1, "e":Ljava/lang/NoSuchMethodException;
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    const-string v1, "InputManagerEventInjector is not supported"

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public freezeRotation(I)V
    .locals 6
    .param p1, "rotation"    # I

    .line 202
    :try_start_0
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;->setRotationInjector:Ljava/lang/reflect/Method;

    iget-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$SetRotationRotationInjector;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-static {v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x3

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const/4 v3, 0x1

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    aput-object v5, v2, v3

    const/4 v3, 0x2

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 205
    :catch_0
    move-exception v0

    .line 206
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 203
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 204
    .local v0, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 207
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :goto_0
    nop

    .line 208
    :goto_1
    return-void
.end method

.method public thawRotation()V
    .locals 0

    .line 211
    return-void
.end method
