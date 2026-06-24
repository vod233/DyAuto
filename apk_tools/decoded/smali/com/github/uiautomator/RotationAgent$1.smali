.class Lcom/github/uiautomator/RotationAgent$1;
.super Ljava/lang/Object;
.source "RotationAgent.java"

# interfaces
.implements Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/RotationAgent;-><init>(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/RotationAgent;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/RotationAgent;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/RotationAgent;

    .line 19
    iput-object p1, p0, Lcom/github/uiautomator/RotationAgent$1;->this$0:Lcom/github/uiautomator/RotationAgent;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onRotationChanged(I)V
    .locals 3
    .param p1, "rotation"    # I

    .line 22
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/github/uiautomator/RotationAgent$1;->this$0:Lcom/github/uiautomator/RotationAgent;

    invoke-static {v2}, Lcom/github/uiautomator/RotationAgent;->access$000(Lcom/github/uiautomator/RotationAgent;)Ljava/io/PrintWriter;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 23
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$1;->this$0:Lcom/github/uiautomator/RotationAgent;

    invoke-static {v0}, Lcom/github/uiautomator/RotationAgent;->access$000(Lcom/github/uiautomator/RotationAgent;)Ljava/io/PrintWriter;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 24
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$1;->this$0:Lcom/github/uiautomator/RotationAgent;

    invoke-static {v0}, Lcom/github/uiautomator/RotationAgent;->access$000(Lcom/github/uiautomator/RotationAgent;)Ljava/io/PrintWriter;

    move-result-object v0

    mul-int/lit8 v1, p1, 0x5a

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(I)V

    .line 25
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent$1;->this$0:Lcom/github/uiautomator/RotationAgent;

    invoke-static {v0}, Lcom/github/uiautomator/RotationAgent;->access$000(Lcom/github/uiautomator/RotationAgent;)Ljava/io/PrintWriter;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    .line 27
    :cond_0
    return-void
.end method
