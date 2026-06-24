.class public Lcom/github/uiautomator/ScreenClient;
.super Ljava/lang/Object;
.source "ScreenClient.java"


# static fields
.field private static final PROCESS_NAME:Ljava/lang/String; = "screen.cli"

.field private static final VERSION:Ljava/lang/String; = "1.0"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static main([Ljava/lang/String;)V
    .locals 4
    .param p0, "args"    # [Ljava/lang/String;

    .line 16
    const-string v0, "Server stopped"

    const-string v1, "screen.cli"

    invoke-static {v1}, Lcom/github/uiautomator/ScreenClient;->setArgV0(Ljava/lang/String;)V

    .line 18
    new-instance v1, Lcom/github/uiautomator/ScreenHttpServer;

    const/16 v2, 0x2332

    invoke-direct {v1, v2}, Lcom/github/uiautomator/ScreenHttpServer;-><init>(I)V

    .line 20
    .local v1, "server":Lcom/github/uiautomator/ScreenHttpServer;
    :try_start_0
    invoke-virtual {v1}, Lcom/github/uiautomator/ScreenHttpServer;->initialize()V

    .line 21
    invoke-virtual {v1}, Lcom/github/uiautomator/ScreenHttpServer;->start()V

    .line 22
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v3, "Server started"

    invoke-virtual {v2, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 24
    :goto_0
    invoke-virtual {v1}, Lcom/github/uiautomator/ScreenHttpServer;->isAlive()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 25
    const-wide/16 v2, 0x64

    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 30
    :catchall_0
    move-exception v2

    goto :goto_1

    .line 27
    :catch_0
    move-exception v2

    .line 28
    .local v2, "e":Ljava/lang/Exception;
    :try_start_1
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 30
    .end local v2    # "e":Ljava/lang/Exception;
    :cond_0
    invoke-virtual {v1}, Lcom/github/uiautomator/ScreenHttpServer;->stop()V

    .line 31
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v2, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 32
    nop

    .line 33
    return-void

    .line 30
    :goto_1
    invoke-virtual {v1}, Lcom/github/uiautomator/ScreenHttpServer;->stop()V

    .line 31
    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v3, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 32
    goto :goto_3

    :goto_2
    throw v2

    :goto_3
    goto :goto_2
.end method

.method private static setArgV0(Ljava/lang/String;)V
    .locals 6
    .param p0, "text"    # Ljava/lang/String;

    .line 37
    :try_start_0
    const-class v0, Landroid/os/Process;

    const-string v1, "setArgV0"

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 38
    .local v0, "setter":Ljava/lang/reflect/Method;
    const-class v1, Landroid/os/Process;

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v5

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    .line 45
    nop

    .end local v0    # "setter":Ljava/lang/reflect/Method;
    goto :goto_1

    .line 43
    :catch_0
    move-exception v0

    .line 44
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 41
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 42
    .local v0, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    goto :goto_0

    .line 39
    :catch_2
    move-exception v0

    .line 40
    .local v0, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {v0}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    .line 45
    .end local v0    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    nop

    .line 46
    :goto_1
    return-void
.end method
