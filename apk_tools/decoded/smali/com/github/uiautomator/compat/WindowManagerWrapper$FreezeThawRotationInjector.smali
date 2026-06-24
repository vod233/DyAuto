.class Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;
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
    name = "FreezeThawRotationInjector"
.end annotation


# instance fields
.field private freezeRotationInjector:Ljava/lang/reflect/Method;

.field private thawRotationInjector:Ljava/lang/reflect/Method;

.field final synthetic this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;)V
    .locals 5

    .line 149
    iput-object p1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 151
    :try_start_0
    invoke-static {p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "freezeRotation"

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Class;

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    .line 153
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->freezeRotationInjector:Ljava/lang/reflect/Method;

    .line 155
    invoke-static {p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    const-string v0, "thawRotation"

    new-array v1, v4, [Ljava/lang/Class;

    .line 157
    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->thawRotationInjector:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 160
    nop

    .line 161
    return-void

    .line 158
    :catch_0
    move-exception p1

    .line 159
    .local p1, "e":Ljava/lang/NoSuchMethodException;
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    const-string v1, "InputManagerEventInjector is not supported"

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public freezeRotation(I)V
    .locals 5
    .param p1, "rotation"    # I

    .line 165
    :try_start_0
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->freezeRotationInjector:Ljava/lang/reflect/Method;

    iget-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-static {v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 168
    :catch_0
    move-exception v0

    .line 169
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 166
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 167
    .local v0, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 170
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :goto_0
    nop

    .line 171
    :goto_1
    return-void
.end method

.method public thawRotation()V
    .locals 3

    .line 175
    :try_start_0
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->thawRotationInjector:Ljava/lang/reflect/Method;

    iget-object v1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$FreezeThawRotationInjector;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-static {v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->access$000(Lcom/github/uiautomator/compat/WindowManagerWrapper;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 178
    :catch_0
    move-exception v0

    .line 179
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 176
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 177
    .local v0, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 180
    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    :goto_0
    nop

    .line 181
    :goto_1
    return-void
.end method
