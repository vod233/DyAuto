.class Lcom/github/uiautomator/ScreenHttpServer$1;
.super Ljava/lang/Thread;
.source "ScreenHttpServer.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/ScreenHttpServer;->handlePostScreenrecord(Ljava/util/Map;)Lfi/iki/elonen/NanoHTTPD$Response;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/ScreenHttpServer;

.field final synthetic val$avc:Landroid/media/MediaCodec;

.field final synthetic val$finalVideoPath:Ljava/lang/String;

.field final synthetic val$muxer:Landroid/media/MediaMuxer;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/ScreenHttpServer;Ljava/lang/String;Landroid/media/MediaCodec;Landroid/media/MediaMuxer;Ljava/lang/String;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/ScreenHttpServer;
    .param p2, "arg0"    # Ljava/lang/String;

    .line 137
    iput-object p1, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->this$0:Lcom/github/uiautomator/ScreenHttpServer;

    iput-object p3, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$avc:Landroid/media/MediaCodec;

    iput-object p4, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$muxer:Landroid/media/MediaMuxer;

    iput-object p5, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$finalVideoPath:Ljava/lang/String;

    invoke-direct {p0, p2}, Ljava/lang/Thread;-><init>(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 140
    const-string v0, "> Recording finished, saved to "

    const/4 v1, 0x0

    .line 142
    .local v1, "virtualDisplay":Landroid/os/IBinder;
    :try_start_0
    iget-object v2, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->this$0:Lcom/github/uiautomator/ScreenHttpServer;

    iget-object v3, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$avc:Landroid/media/MediaCodec;

    invoke-static {v2, v3}, Lcom/github/uiautomator/ScreenHttpServer;->access$000(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;)Landroid/os/IBinder;

    move-result-object v2

    move-object v1, v2

    .line 143
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v3, "> Recording started"

    invoke-virtual {v2, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 144
    iget-object v2, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->this$0:Lcom/github/uiautomator/ScreenHttpServer;

    iget-object v3, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$avc:Landroid/media/MediaCodec;

    iget-object v4, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$muxer:Landroid/media/MediaMuxer;

    invoke-static {v2, v3, v4}, Lcom/github/uiautomator/ScreenHttpServer;->access$100(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;Landroid/media/MediaMuxer;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 148
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    goto :goto_0

    :catchall_0
    move-exception v2

    goto :goto_1

    .line 145
    :catch_0
    move-exception v2

    .line 146
    .local v2, "e":Ljava/lang/Exception;
    :try_start_1
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 148
    .end local v2    # "e":Ljava/lang/Exception;
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    :goto_0
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$finalVideoPath:Ljava/lang/String;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 149
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->this$0:Lcom/github/uiautomator/ScreenHttpServer;

    iget-object v2, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$avc:Landroid/media/MediaCodec;

    iget-object v3, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$muxer:Landroid/media/MediaMuxer;

    invoke-static {v0, v2, v1, v3}, Lcom/github/uiautomator/ScreenHttpServer;->access$200(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;Landroid/os/IBinder;Landroid/media/MediaMuxer;)V

    .line 150
    nop

    .line 151
    return-void

    .line 148
    :goto_1
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$finalVideoPath:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 149
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->this$0:Lcom/github/uiautomator/ScreenHttpServer;

    iget-object v3, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$avc:Landroid/media/MediaCodec;

    iget-object v4, p0, Lcom/github/uiautomator/ScreenHttpServer$1;->val$muxer:Landroid/media/MediaMuxer;

    invoke-static {v0, v3, v1, v4}, Lcom/github/uiautomator/ScreenHttpServer;->access$200(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;Landroid/os/IBinder;Landroid/media/MediaMuxer;)V

    .line 150
    throw v2
.end method
