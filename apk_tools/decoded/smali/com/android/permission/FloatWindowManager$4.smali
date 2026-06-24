.class Lcom/android/permission/FloatWindowManager$4;
.super Ljava/lang/Object;
.source "FloatWindowManager.java"

# interfaces
.implements Lcom/android/permission/FloatWindowManager$OnConfirmResult;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/permission/FloatWindowManager;->miuiROMPermissionApply(Landroid/content/Context;)V
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

    .line 228
    iput-object p1, p0, Lcom/android/permission/FloatWindowManager$4;->this$0:Lcom/android/permission/FloatWindowManager;

    iput-object p2, p0, Lcom/android/permission/FloatWindowManager$4;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public confirmResult(Z)V
    .locals 2
    .param p1, "confirm"    # Z

    .line 231
    if-eqz p1, :cond_0

    .line 232
    iget-object v0, p0, Lcom/android/permission/FloatWindowManager$4;->val$context:Landroid/content/Context;

    invoke-static {v0}, Lcom/android/permission/rom/MiuiUtils;->applyMiuiPermission(Landroid/content/Context;)V

    goto :goto_0

    .line 234
    :cond_0
    const-string v0, "FloatWindowManager"

    const-string v1, "ROM:miui, user manually refuse OVERLAY_PERMISSION"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 236
    :goto_0
    return-void
.end method
