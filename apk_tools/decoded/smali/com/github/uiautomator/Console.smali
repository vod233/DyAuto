.class public Lcom/github/uiautomator/Console;
.super Ljava/lang/Object;
.source "Console.java"


# static fields
.field static final PROCESS_NAME:Ljava/lang/String; = "apkagent.cli"

.field static final VERSION:Ljava/lang/String; = "1.0.0"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private listenAndServe()V
    .locals 5

    .line 74
    invoke-static {}, Landroid/os/Looper;->prepare()V

    .line 75
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    .line 77
    .local v0, "handler":Landroid/os/Handler;
    new-instance v1, Lcom/github/uiautomator/compat/WindowManagerWrapper;

    invoke-direct {v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;-><init>()V

    .line 78
    .local v1, "wm":Lcom/github/uiautomator/compat/WindowManagerWrapper;
    invoke-virtual {v1}, Lcom/github/uiautomator/compat/WindowManagerWrapper;->getDisplaySize()Landroid/graphics/Point;

    move-result-object v2

    .line 79
    .local v2, "size":Landroid/graphics/Point;
    if-nez v2, :cond_0

    .line 80
    sget-object v3, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v4, "Can not get device resolution"

    invoke-virtual {v3, v4}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 81
    const/4 v3, 0x1

    invoke-static {v3}, Ljava/lang/System;->exit(I)V

    .line 84
    :cond_0
    new-instance v3, Lcom/github/uiautomator/RotationAgent;

    const-string v4, "rotationagent"

    invoke-direct {v3, v4}, Lcom/github/uiautomator/RotationAgent;-><init>(Ljava/lang/String;)V

    .line 85
    .local v3, "rotation":Lcom/github/uiautomator/RotationAgent;
    invoke-virtual {v3}, Lcom/github/uiautomator/RotationAgent;->start()V

    .line 87
    invoke-static {}, Landroid/os/Looper;->loop()V

    .line 88
    return-void
.end method

.method public static main([Ljava/lang/String;)V
    .locals 8
    .param p0, "args"    # [Ljava/lang/String;

    .line 37
    const-string v0, "apkagent.cli"

    invoke-static {v0}, Lcom/github/uiautomator/Console;->setArgV0(Ljava/lang/String;)V

    .line 39
    new-instance v1, Lorg/apache/commons/cli/Options;

    invoke-direct {v1}, Lorg/apache/commons/cli/Options;-><init>()V

    .line 40
    .local v1, "options":Lorg/apache/commons/cli/Options;
    const-string v2, "v"

    const-string v3, "version"

    const/4 v4, 0x0

    const-string v5, "show current version"

    invoke-virtual {v1, v2, v3, v4, v5}, Lorg/apache/commons/cli/Options;->addOption(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Lorg/apache/commons/cli/Options;

    .line 41
    const-string v2, "h"

    const-string v5, "help"

    const-string v6, "show this message"

    invoke-virtual {v1, v2, v5, v4, v6}, Lorg/apache/commons/cli/Options;->addOption(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Lorg/apache/commons/cli/Options;

    .line 42
    const-string v2, "d"

    const-string v6, "debug-info"

    const-string v7, "show debug info"

    invoke-virtual {v1, v2, v6, v4, v7}, Lorg/apache/commons/cli/Options;->addOption(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Lorg/apache/commons/cli/Options;

    .line 44
    new-instance v2, Lorg/apache/commons/cli/DefaultParser;

    invoke-direct {v2}, Lorg/apache/commons/cli/DefaultParser;-><init>()V

    .line 45
    .local v2, "parser":Lorg/apache/commons/cli/CommandLineParser;
    new-instance v4, Lorg/apache/commons/cli/HelpFormatter;

    invoke-direct {v4}, Lorg/apache/commons/cli/HelpFormatter;-><init>()V

    .line 49
    .local v4, "formatter":Lorg/apache/commons/cli/HelpFormatter;
    :try_start_0
    invoke-interface {v2, v1, p0}, Lorg/apache/commons/cli/CommandLineParser;->parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;)Lorg/apache/commons/cli/CommandLine;

    move-result-object v7
    :try_end_0
    .catch Lorg/apache/commons/cli/ParseException; {:try_start_0 .. :try_end_0} :catch_0

    .line 55
    .local v7, "cmd":Lorg/apache/commons/cli/CommandLine;
    nop

    .line 57
    invoke-virtual {v7, v5}, Lorg/apache/commons/cli/CommandLine;->hasOption(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 58
    invoke-virtual {v4, v0, v1}, Lorg/apache/commons/cli/HelpFormatter;->printHelp(Ljava/lang/String;Lorg/apache/commons/cli/Options;)V

    .line 59
    return-void

    .line 61
    :cond_0
    invoke-virtual {v7, v3}, Lorg/apache/commons/cli/CommandLine;->hasOption(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 62
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v3, "1.0.0"

    invoke-virtual {v0, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 63
    return-void

    .line 65
    :cond_1
    invoke-virtual {v7, v6}, Lorg/apache/commons/cli/CommandLine;->hasOption(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 66
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v3, "Debug info is not ready yet."

    invoke-virtual {v0, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 67
    return-void

    .line 70
    :cond_2
    new-instance v0, Lcom/github/uiautomator/Console;

    invoke-direct {v0}, Lcom/github/uiautomator/Console;-><init>()V

    invoke-direct {v0}, Lcom/github/uiautomator/Console;->listenAndServe()V

    .line 71
    return-void

    .line 50
    .end local v7    # "cmd":Lorg/apache/commons/cli/CommandLine;
    :catch_0
    move-exception v3

    .line 51
    .local v3, "e":Lorg/apache/commons/cli/ParseException;
    sget-object v5, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v3}, Lorg/apache/commons/cli/ParseException;->getMessage()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 52
    invoke-virtual {v4, v0, v1}, Lorg/apache/commons/cli/HelpFormatter;->printHelp(Ljava/lang/String;Lorg/apache/commons/cli/Options;)V

    .line 53
    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 54
    return-void
.end method

.method private static setArgV0(Ljava/lang/String;)V
    .locals 6
    .param p0, "text"    # Ljava/lang/String;

    .line 25
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

    .line 26
    .local v0, "setter":Ljava/lang/reflect/Method;
    const-class v1, Landroid/os/Process;

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v5

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    .line 33
    nop

    .end local v0    # "setter":Ljava/lang/reflect/Method;
    goto :goto_1

    .line 31
    :catch_0
    move-exception v0

    .line 32
    .local v0, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_1

    .line 29
    .end local v0    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_1
    move-exception v0

    .line 30
    .local v0, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v0}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    .end local v0    # "e":Ljava/lang/IllegalAccessException;
    goto :goto_0

    .line 27
    :catch_2
    move-exception v0

    .line 28
    .local v0, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {v0}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    .line 33
    .end local v0    # "e":Ljava/lang/NoSuchMethodException;
    :goto_0
    nop

    .line 34
    :goto_1
    return-void
.end method
