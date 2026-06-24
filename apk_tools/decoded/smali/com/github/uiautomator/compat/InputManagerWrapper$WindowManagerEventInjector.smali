.class Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;
.super Ljava/lang/Object;
.source "InputManagerWrapper.java"

# interfaces
.implements Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/compat/InputManagerWrapper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "WindowManagerEventInjector"
.end annotation


# instance fields
.field private keyInjector:Ljava/lang/reflect/Method;

.field final synthetic this$0:Lcom/github/uiautomator/compat/InputManagerWrapper;

.field private windowManager:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/compat/InputManagerWrapper;)V
    .locals 4

    .line 89
    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;->this$0:Lcom/github/uiautomator/compat/InputManagerWrapper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 91
    :try_start_0
    invoke-static {}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->getWindowManager()Ljava/lang/Object;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;->windowManager:Ljava/lang/Object;

    .line 93
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    const-string v0, "injectKeyEvent"

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    const-class v3, Landroid/view/KeyEvent;

    aput-object v3, v1, v2

    const/4 v2, 0x1

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v2

    .line 96
    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;->keyInjector:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 101
    nop

    .line 102
    return-void

    .line 98
    :catch_0
    move-exception p1

    .line 99
    .local p1, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {p1}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    .line 100
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    const-string v1, "WindowManagerEventInjector is not supported"

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public injectInputEvent(Landroid/view/InputEvent;)Z
    .locals 1
    .param p1, "event"    # Landroid/view/InputEvent;

    .line 121
    const/4 v0, 0x0

    return v0
.end method

.method public injectKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 6
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 106
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;->keyInjector:Ljava/lang/reflect/Method;

    iget-object v2, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;->windowManager:Ljava/lang/Object;

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    aput-object p1, v3, v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v4

    const/4 v5, 0x1

    aput-object v4, v3, v5

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    .line 107
    return v5

    .line 113
    :catch_0
    move-exception v1

    .line 114
    .local v1, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v1}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    .line 115
    return v0

    .line 109
    .end local v1    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v1

    .line 110
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 111
    return v0
.end method
