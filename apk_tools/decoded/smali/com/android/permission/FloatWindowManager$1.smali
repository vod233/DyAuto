.class Lcom/android/permission/FloatWindowManager$1;
.super Ljava/lang/Object;
.source "FloatWindowManager.java"

# interfaces
.implements Lcom/android/permission/FloatWindowManager$OnConfirmResult;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/permission/FloatWindowManager;->ROM360PermissionApply(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/permission/FloatWindowManager;

.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Lcom/android/permission/FloatWindowManager;Landroid/content/Context;)V
    .locals 0
    .param p1, "this$0"    # Lcom/android/permission/FloatWindowManager;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 186
    iput-object p1, p0, Lcom/android/permission/FloatWindowManager$1;->this$0:Lcom/android/permission/FloatWindowManager;

    iput-object p2, p0, Lcom/android/permission/FloatWindowManager$1;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public confirmResult(Z)V
    .locals 2
    .param p1, "confirm"    # Z

    .line 189
    if-eqz p1, :cond_0

    .line 190
    iget-object v0, p0, Lcom/android/permission/FloatWindowManager$1;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/android/permission/rom/QikuUtils;->applyPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 192
    :cond_0
    const-string v0, "FloatWindowManager"

    const-string v1, "ROM:360, user manually refuse OVERLAY_PERMISSION"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 194
    :goto_0
    return-void
.end method
