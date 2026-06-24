.class Lcom/android/permission/FloatWindowManager$8;
.super Ljava/lang/Object;
.source "FloatWindowManager.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/permission/FloatWindowManager;->showConfirmDialog(Landroid/content/Context;Ljava/lang/String;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/permission/FloatWindowManager;

.field final synthetic val$result:Lcom/android/permission/FloatWindowManager$OnConfirmResult;


# direct methods
.method constructor <init>(Lcom/android/permission/FloatWindowManager;Lcom/android/permission/FloatWindowManager$OnConfirmResult;)V
    .locals 0
    .param p1, "this$0"    # Lcom/android/permission/FloatWindowManager;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 303
    iput-object p1, p0, Lcom/android/permission/FloatWindowManager$8;->this$0:Lcom/android/permission/FloatWindowManager;

    iput-object p2, p0, Lcom/android/permission/FloatWindowManager$8;->val$result:Lcom/android/permission/FloatWindowManager$OnConfirmResult;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 2
    .param p1, "dialog"    # Landroid/content/DialogInterface;
    .param p2, "which"    # I

    .line 306
    iget-object v0, p0, Lcom/android/permission/FloatWindowManager$8;->val$result:Lcom/android/permission/FloatWindowManager$OnConfirmResult;

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Lcom/android/permission/FloatWindowManager$OnConfirmResult;->confirmResult(Z)V

    .line 307
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 308
    return-void
.end method
