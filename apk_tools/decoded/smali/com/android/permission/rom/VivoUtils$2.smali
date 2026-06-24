.class Lcom/android/permission/rom/VivoUtils$2;
.super Ljava/lang/Object;
.source "VivoUtils.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/permission/rom/VivoUtils;->applyPermission(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 68
    iput-object p1, p0, Lcom/android/permission/rom/VivoUtils$2;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 71
    iget-object v0, p0, Lcom/android/permission/rom/VivoUtils$2;->val$context:Landroid/content/Context;

    const-string v1, "\u8bf7\u624b\u52a8\u5f00\u542fi\u7ba1\u5bb6\uff0c\u8fdb\u5165\"\u5e94\u7528\u7ba1\u7406->\u6743\u9650\u7ba1\u7406->\u60ac\u6d6e\u7a97\"\u9875\u9762\u5f00\u542f\u6743\u9650"

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 72
    return-void
.end method
