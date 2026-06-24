.class Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;
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
    name = "InputManagerEventInjector"
.end annotation


# static fields
.field public static final INJECT_INPUT_EVENT_MODE_ASYNC:I


# instance fields
.field private injector:Ljava/lang/reflect/Method;

.field private inputManager:Ljava/lang/Object;

.field final synthetic this$0:Lcom/github/uiautomator/compat/InputManagerWrapper;


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/compat/InputManagerWrapper;)V
    .locals 4

    .line 47
    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->this$0:Lcom/github/uiautomator/compat/InputManagerWrapper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 49
    :try_start_0
    const-string p1, "android.hardware.input.InputManager"

    invoke-static {p1}, Lcom/github/uiautomator/util/InternalApi;->getSingleton(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->inputManager:Ljava/lang/Object;

    .line 52
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    const-string v0, "injectInputEvent"

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    const-class v3, Landroid/view/InputEvent;

    aput-object v3, v1, v2

    const/4 v2, 0x1

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v2

    .line 54
    invoke-virtual {p1, v0, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    iput-object p1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->injector:Ljava/lang/reflect/Method;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    .line 58
    nop

    .line 59
    return-void

    .line 56
    :catch_0
    move-exception p1

    .line 57
    .local p1, "e":Ljava/lang/NoSuchMethodException;
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    const-string v1, "InputManagerEventInjector is not supported"

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public injectInputEvent(Landroid/view/InputEvent;)Z
    .locals 6
    .param p1, "event"    # Landroid/view/InputEvent;

    .line 68
    const/4 v0, 0x0

    :try_start_0
    iget-object v1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->injector:Ljava/lang/reflect/Method;

    iget-object v2, p0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->inputManager:Ljava/lang/Object;

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    aput-object p1, v3, v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x1

    aput-object v4, v3, v5

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    .line 69
    return v5

    .line 75
    :catch_0
    move-exception v1

    .line 76
    .local v1, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v1}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    .line 77
    return v0

    .line 71
    .end local v1    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v1

    .line 72
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .line 73
    return v0
.end method

.method public injectKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 1
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 62
    invoke-virtual {p0, p1}, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;->injectInputEvent(Landroid/view/InputEvent;)Z

    move-result v0

    return v0
.end method
