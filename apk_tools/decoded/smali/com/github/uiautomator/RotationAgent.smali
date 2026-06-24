.class public Lcom/github/uiautomator/RotationAgent;
.super Ljava/lang/Thread;
.source "RotationAgent.java"


# instance fields
.field private socketName:Ljava/lang/String;

.field private final wm:Lcom/github/uiautomator/compat/WindowManagerWrapper;

.field private writer:Ljava/io/PrintWriter;


# direct methods
.method constructor <init>(Ljava/lang/String;)V
    .locals 2
    .param p1, "socketName"    # Ljava/lang/String;

    .line 17
    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    .line 13
    new-instance v0, Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-direct {v0}, Lcom/github/uiautomator/compat/WindowManagerWrapper;-><init>()V

    iput-object v0, p0, Lcom/github/uiautomator/RotationAgent;->wm:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    .line 18
    iput-object p1, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    .line 19
    new-instance v1, Lcom/github/uiautomator/RotationAgent$1;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/RotationAgent$1;-><init>(Lcom/github/uiautomator/RotationAgent;)V

    invoke-virtual {v0, v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->watchRotation(Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)Ljava/lang/Object;

    .line 29
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/RotationAgent;)Ljava/io/PrintWriter;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/RotationAgent;

    .line 12
    iget-object v0, p0, Lcom/github/uiautomator/RotationAgent;->writer:Ljava/io/PrintWriter;

    return-object v0
.end method

.method public static main([Ljava/lang/String;)V
    .locals 2
    .param p0, "args"    # [Ljava/lang/String;

    .line 80
    new-instance v0, Lcom/github/uiautomator/RotationAgent;

    const-string v1, "rotation"

    invoke-direct {v0, v1}, Lcom/github/uiautomator/RotationAgent;-><init>(Ljava/lang/String;)V

    .line 81
    .local v0, "agent":Lcom/github/uiautomator/RotationAgent;
    invoke-virtual {v0}, Lcom/github/uiautomator/RotationAgent;->run()V

    .line 82
    return-void
.end method

.method private manageClientConnection(Landroid/net/LocalServerSocket;)V
    .locals 4
    .param p1, "serverSocket"    # Landroid/net/LocalServerSocket;

    .line 34
    :goto_0
    :try_start_0
    invoke-virtual {p1}, Landroid/net/LocalServerSocket;->accept()Landroid/net/LocalSocket;

    move-result-object v0

    .line 35
    .local v0, "socket":Landroid/net/LocalSocket;
    new-instance v1, Ljava/io/PrintWriter;

    invoke-virtual {v0}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/PrintWriter;-><init>(Ljava/io/OutputStream;)V

    .line 36
    .local v1, "writer":Ljava/io/PrintWriter;
    iget-object v2, p0, Lcom/github/uiautomator/RotationAgent;->wm:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-virtual {v2}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->getRotation()I

    move-result v2

    mul-int/lit8 v2, v2, 0x5a

    invoke-virtual {v1, v2}, Ljava/io/PrintWriter;->println(I)V

    .line 37
    invoke-virtual {v1}, Ljava/io/PrintWriter;->flush()V

    .line 38
    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0, v1, v0}, Lcom/github/uiautomator/RotationAgent$$ExternalSyntheticLambda0;-><init>(Lcom/github/uiautomator/RotationAgent;Ljava/io/PrintWriter;Landroid/net/LocalSocket;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 62
    invoke-virtual {v2}, Ljava/lang/Thread;->start()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "socket":Landroid/net/LocalSocket;
    .end local v1    # "writer":Ljava/io/PrintWriter;
    goto :goto_1

    .line 63
    :catch_0
    move-exception v0

    .line 64
    .local v0, "e":Ljava/io/IOException;
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    .line 65
    .end local v0    # "e":Ljava/io/IOException;
    :goto_1
    goto :goto_0
.end method


# virtual methods
.method synthetic lambda$manageClientConnection$0$com-github-uiautomator-RotationAgent(Ljava/io/PrintWriter;Landroid/net/LocalSocket;)V
    .locals 5
    .param p1, "writer"    # Ljava/io/PrintWriter;
    .param p2, "socket"    # Landroid/net/LocalSocket;

    .line 41
    const-string v0, " client connection closed"

    const-string v1, "@"

    :try_start_0
    iget-object v2, p0, Lcom/github/uiautomator/RotationAgent;->wm:Lcom/github/uiautomator/compat/WindowManagerWrapper;

    new-instance v3, Lcom/github/uiautomator/RotationAgent$2;

    invoke-direct {v3, p0, p1}, Lcom/github/uiautomator/RotationAgent$2;-><init>(Lcom/github/uiautomator/RotationAgent;Ljava/io/PrintWriter;)V

    invoke-virtual {v2, v3}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->watchRotation(Lcom/github/uiautomator/compat/WindowManagerWrapper$RotationWatcher;)Ljava/lang/Object;

    .line 49
    new-instance v2, Ljava/util/Scanner;

    invoke-virtual {p2}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/util/Scanner;-><init>(Ljava/io/InputStream;)V

    .line 50
    .local v2, "in":Ljava/util/Scanner;
    :goto_0
    invoke-virtual {v2}, Ljava/util/Scanner;->hasNextLine()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 51
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v2}, Ljava/util/Scanner;->nextLine()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 57
    .end local v2    # "in":Ljava/util/Scanner;
    :cond_0
    :try_start_1
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 58
    invoke-virtual {p2}, Landroid/net/LocalSocket;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 56
    :catchall_0
    move-exception v2

    goto :goto_3

    .line 53
    :catch_0
    move-exception v2

    .line 54
    .local v2, "e":Ljava/lang/Exception;
    :try_start_2
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 57
    .end local v2    # "e":Ljava/lang/Exception;
    :try_start_3
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 58
    invoke-virtual {p2}, Landroid/net/LocalSocket;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_1

    .line 60
    :goto_1
    goto :goto_2

    .line 59
    :catch_1
    move-exception v0

    .line 61
    nop

    .line 62
    :goto_2
    return-void

    .line 57
    :goto_3
    :try_start_4
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 58
    invoke-virtual {p2}, Landroid/net/LocalSocket;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2

    .line 60
    goto :goto_4

    .line 59
    :catch_2
    move-exception v0

    .line 61
    :goto_4
    goto :goto_6

    :goto_5
    throw v2

    :goto_6
    goto :goto_5
.end method

.method public run()V
    .locals 4

    .line 71
    :try_start_0
    new-instance v0, Landroid/net/LocalServerSocket;

    iget-object v1, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    invoke-direct {v0, v1}, Landroid/net/LocalServerSocket;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 72
    .local v0, "serverSocket":Landroid/net/LocalServerSocket;
    :try_start_1
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Listening on localabstract:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/github/uiautomator/RotationAgent;->socketName:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 73
    invoke-direct {p0, v0}, Lcom/github/uiautomator/RotationAgent;->manageClientConnection(Landroid/net/LocalServerSocket;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 74
    :try_start_2
    invoke-virtual {v0}, Landroid/net/LocalServerSocket;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    .line 76
    .end local v0    # "serverSocket":Landroid/net/LocalServerSocket;
    goto :goto_1

    .line 71
    .restart local v0    # "serverSocket":Landroid/net/LocalServerSocket;
    :catchall_0
    move-exception v1

    :try_start_3
    invoke-virtual {v0}, Landroid/net/LocalServerSocket;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception v2

    :try_start_4
    invoke-virtual {v1, v2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw v1
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    .line 74
    .end local v0    # "serverSocket":Landroid/net/LocalServerSocket;
    :catch_0
    move-exception v0

    .line 75
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 77
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_1
    return-void
.end method
