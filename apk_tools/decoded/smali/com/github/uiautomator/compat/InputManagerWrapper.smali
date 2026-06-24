.class public Lcom/github/uiautomator/compat/InputManagerWrapper;
.super Ljava/lang/Object;
.source "InputManagerWrapper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;,
        Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;,
        Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;
    }
.end annotation


# instance fields
.field private eventInjector:Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 19
    :try_start_0
    new-instance v0, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;

    invoke-direct {v0, p0}, Lcom/github/uiautomator/compat/InputManagerWrapper$InputManagerEventInjector;-><init>(Lcom/github/uiautomator/compat/InputManagerWrapper;)V

    iput-object v0, p0, Lcom/github/uiautomator/compat/InputManagerWrapper;->eventInjector:Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;
    :try_end_0
    .catch Ljava/lang/UnsupportedOperationException; {:try_start_0 .. :try_end_0} :catch_0

    .line 23
    goto :goto_0

    .line 21
    :catch_0
    move-exception v0

    .line 22
    .local v0, "e":Ljava/lang/UnsupportedOperationException;
    new-instance v1, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/compat/InputManagerWrapper$WindowManagerEventInjector;-><init>(Lcom/github/uiautomator/compat/InputManagerWrapper;)V

    iput-object v1, p0, Lcom/github/uiautomator/compat/InputManagerWrapper;->eventInjector:Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;

    .line 24
    .end local v0    # "e":Ljava/lang/UnsupportedOperationException;
    :goto_0
    return-void
.end method


# virtual methods
.method public injectInputEvent(Landroid/view/InputEvent;)Z
    .locals 1
    .param p1, "event"    # Landroid/view/InputEvent;

    .line 31
    iget-object v0, p0, Lcom/github/uiautomator/compat/InputManagerWrapper;->eventInjector:Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;

    invoke-interface {v0, p1}, Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;->injectInputEvent(Landroid/view/InputEvent;)Z

    move-result v0

    return v0
.end method

.method public injectKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 1
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 27
    iget-object v0, p0, Lcom/github/uiautomator/compat/InputManagerWrapper;->eventInjector:Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;

    invoke-interface {v0, p1}, Lcom/github/uiautomator/compat/InputManagerWrapper$EventInjector;->injectKeyEvent(Landroid/view/KeyEvent;)Z

    move-result v0

    return v0
.end method
