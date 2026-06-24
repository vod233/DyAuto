.class public final synthetic Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/github/uiautomator/RotationAgent;

.field public final synthetic f$1:Ljava/io/PrintWriter;

.field public final synthetic f$2:Landroid/net/LocalSocket;


# direct methods
.method public synthetic constructor <init>(Lcom/github/uiautomator/RotationAgent;Ljava/io/PrintWriter;Landroid/net/LocalSocket;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$0:Lcom/github/uiautomator/RotationAgent;

    iput-object p2, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$1:Ljava/io/PrintWriter;

    iput-object p3, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$2:Landroid/net/LocalSocket;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$0:Lcom/github/uiautomator/RotationAgent;

    iget-object v1, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$1:Ljava/io/PrintWriter;

    iget-object v2, p0, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;->f$2:Landroid/net/LocalSocket;

    invoke-virtual {v0, v1, v2}, Lcom/github/uiautomator/RotationAgent;->lambda$manageClientConnection$0$com-github-uiautomator-RotationAgent(Ljava/io/PrintWriter;Landroid/net/LocalSocket;)V

    return-void
.end method
