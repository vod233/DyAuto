.class Lcom/github/uiautomator/compat/WindowManagerWrapper$1;
.super Landroid/view/IRotationWatcher$Stub;
.source "WindowManagerWrapper.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/compat/WindowManagerWrapper;->watchRotation(Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)Ljava/lang/Object;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

.field final synthetic val$watcher:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/compat/WindowManagerWrapper;Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/compat/WindowManagerWrapper;

    .line 108
    iput-object p1, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$1;->this$0:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    iput-object p2, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$1;->val$watcher:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;

    invoke-direct {p0}, Landroid/view/IRotationWatcher$Stub;-><init>()V

    return-void
.end method


# virtual methods
.method public onRotationChanged(I)V
    .locals 1
    .param p1, "rotation"    # I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 111
    iget-object v0, p0, Lcom/github/uiautomator/compat/WindowManagerWrapper$1;->val$watcher:Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;

    invoke-interface {v0, p1}, Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;->onRotationChanged(I)V

    .line 112
    return-void
.end method
