.class Lcom/github/uiautomator/RotationAgent$2;
.super Ljava/lang/Object;
.source "RotationAgent.java"

# interfaces
.implements Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/RotationAgent;->manageClientConnection(Landroid/net/LocalServerSocket;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/RotationAgent;

.field final synthetic val$writer:Ljava/io/PrintWriter;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/RotationAgent;Ljava/io/PrintWriter;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/RotationAgent;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 41
    iput-object p1, p0, Lcom/github/uiautomator/RotationAgent$2;->this$0:Lcom/github/uiautomator/RotationAgent;

    iput-object p2, p0, Lcom/github/uiautomator/RotationAgent$2;->val$writer:Ljava/io/PrintWriter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onRotationChanged(I)V
    .locals 2
    .param p1, "rotation"    # I

    .line 44
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$2;->val$writer:Ljava/io/PrintWriter;

    mul-int/lit8 v1, p1, 0x5a

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(I)V

    .line 45
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$2;->val$writer:Ljava/io/PrintWriter;

    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    .line 46
    return-void
.end method
