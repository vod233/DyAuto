.class public Lcom/android/permission/rom/RomUtils;
.super Ljava/lang/Object;
.source "RomUtils.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RomUtils"

.field private static is360:Ljava/lang/Boolean;

.field private static isGoogle:Ljava/lang/Boolean;

.field private static isMeizu:Ljava/lang/Boolean;

.field private static isMiui:Ljava/lang/Boolean;

.field private static isOppo:Ljava/lang/Boolean;

.field private static isSamSung:Ljava/lang/Boolean;

.field private static isSmartisan:Ljava/lang/Boolean;

.field private static isSony:Ljava/lang/Boolean;

.field private static isVivo:Ljava/lang/Boolean;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 38
    const/4 v0, 0x0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSony:Ljava/lang/Boolean;

    .line 50
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSamSung:Ljava/lang/Boolean;

    .line 64
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isOppo:Ljava/lang/Boolean;

    .line 76
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isVivo:Ljava/lang/Boolean;

    .line 84
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isGoogle:Ljava/lang/Boolean;

    .line 93
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSmartisan:Ljava/lang/Boolean;

    .line 145
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isMiui:Ljava/lang/Boolean;

    .line 157
    sput-object v0, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    .line 174
    sput-object v0, Lcom/android/permission/rom/RomUtils;->is360:Ljava/lang/Boolean;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static checkIs360Rom()Z
    .locals 2

    .line 177
    sget-object v0, Lcom/android/permission/rom/RomUtils;->is360:Ljava/lang/Boolean;

    if-nez v0, :cond_2

    .line 178
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    const-string v1, "QiKU"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    .line 179
    const-string v1, "360"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    .line 178
    :goto_1
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->is360:Ljava/lang/Boolean;

    .line 181
    :cond_2
    sget-object v0, Lcom/android/permission/rom/RomUtils;->is360:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static checkIsHuaweiRom()Z
    .locals 2

    .line 142
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    const-string v1, "HUAWEI"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    return v0
.end method

.method public static checkIsMeizuRom()Z
    .locals 4

    .line 160
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    if-nez v0, :cond_3

    .line 161
    const-string v0, "ro.build.display.id"

    invoke-static {v0}, Lcom/android/permission/rom/RomUtils;->getSystemProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 162
    .local v0, "meizuFlymeOSFlag":Ljava/lang/String;
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 163
    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    sput-object v1, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    goto :goto_1

    .line 164
    :cond_0
    const-string v1, "flyme"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_2

    invoke-virtual {v0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_0

    .line 167
    :cond_1
    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    sput-object v1, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    goto :goto_1

    .line 165
    :cond_2
    :goto_0
    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    sput-object v1, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    .line 171
    .end local v0    # "meizuFlymeOSFlag":Ljava/lang/String;
    :cond_3
    :goto_1
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isMeizu:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static checkIsMiuiRom()Z
    .locals 1

    .line 150
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isMiui:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 151
    const-string v0, "ro.miui.ui.version.name"

    invoke-static {v0}, Lcom/android/permission/rom/RomUtils;->getSystemProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isMiui:Ljava/lang/Boolean;

    .line 153
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isMiui:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static getDeviceSerialNO()Ljava/lang/String;
    .locals 3

    .line 186
    :try_start_0
    const-string v0, "ro.serialno"

    invoke-static {v0}, Lcom/android/permission/rom/RomUtils;->getSystemProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 187
    :catch_0
    move-exception v0

    .line 188
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 189
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    const-string v2, "SystemUtil"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 191
    .end local v0    # "e":Ljava/lang/Exception;
    const/4 v0, 0x0

    return-object v0
.end method

.method public static getEmuiVersion()D
    .locals 4

    .line 29
    :try_start_0
    const-string v0, "ro.build.version.emui"

    invoke-static {v0}, Lcom/android/permission/rom/RomUtils;->getSystemProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 30
    .local v0, "emuiVersion":Ljava/lang/String;
    const-string v1, "_"

    invoke-virtual {v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 31
    .local v1, "version":Ljava/lang/String;
    invoke-static {v1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v2

    .line 32
    .end local v0    # "emuiVersion":Ljava/lang/String;
    .end local v1    # "version":Ljava/lang/String;
    :catch_0
    move-exception v0

    .line 33
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 35
    .end local v0    # "e":Ljava/lang/Exception;
    const-wide/high16 v0, 0x4010000000000000L    # 4.0

    return-wide v0
.end method

.method public static getMiuiVersion()I
    .locals 4

    .line 108
    const-string v0, "ro.miui.ui.version.name"

    invoke-static {v0}, Lcom/android/permission/rom/RomUtils;->getSystemProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 109
    .local v0, "version":Ljava/lang/String;
    if-eqz v0, :cond_0

    .line 111
    const/4 v1, 0x1

    :try_start_0
    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    .line 112
    :catch_0
    move-exception v1

    .line 113
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "get miui version code error, version : "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "RomUtils"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 116
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_0
    const/4 v1, -0x1

    return v1
.end method

.method public static getSystemProperty(Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .param p0, "propName"    # Ljava/lang/String;

    .line 121
    const-string v0, "Exception while closing InputStream"

    const-string v1, "RomUtils"

    const/4 v2, 0x0

    .line 123
    .local v2, "input":Ljava/io/BufferedReader;
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "getprop "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v3

    .line 124
    .local v3, "p":Ljava/lang/Process;
    new-instance v4, Ljava/io/BufferedReader;

    new-instance v5, Ljava/io/InputStreamReader;

    invoke-virtual {v3}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    const/16 v6, 0x400

    invoke-direct {v4, v5, v6}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;I)V

    move-object v2, v4

    .line 125
    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    .line 126
    .local v4, "line":Ljava/lang/String;
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 131
    .end local v3    # "p":Ljava/lang/Process;
    nop

    .line 133
    :try_start_1
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 136
    :goto_0
    goto :goto_1

    .line 134
    :catch_0
    move-exception v3

    .line 135
    .local v3, "e":Ljava/io/IOException;
    invoke-static {v1, v0, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .end local v3    # "e":Ljava/io/IOException;
    goto :goto_0

    .line 139
    :goto_1
    return-object v4

    .line 131
    .end local v4    # "line":Ljava/lang/String;
    :catchall_0
    move-exception v3

    goto :goto_3

    .line 127
    :catch_1
    move-exception v3

    .line 128
    .local v3, "ex":Ljava/io/IOException;
    :try_start_2
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Unable to read sysprop "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 129
    const/4 v4, 0x0

    .line 131
    if-eqz v2, :cond_0

    .line 133
    :try_start_3
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_2

    .line 136
    goto :goto_2

    .line 134
    :catch_2
    move-exception v5

    .line 135
    .local v5, "e":Ljava/io/IOException;
    invoke-static {v1, v0, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 129
    .end local v5    # "e":Ljava/io/IOException;
    :cond_0
    :goto_2
    return-object v4

    .line 131
    .end local v3    # "ex":Ljava/io/IOException;
    :goto_3
    if-eqz v2, :cond_1

    .line 133
    :try_start_4
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_3

    .line 136
    goto :goto_4

    .line 134
    :catch_3
    move-exception v4

    .line 135
    .local v4, "e":Ljava/io/IOException;
    invoke-static {v1, v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 138
    .end local v4    # "e":Ljava/io/IOException;
    :cond_1
    :goto_4
    goto :goto_6

    :goto_5
    throw v3

    :goto_6
    goto :goto_5
.end method

.method public static isGoogleSystem()Z
    .locals 2

    .line 86
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isGoogle:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 87
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "GOOGLE"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isGoogle:Ljava/lang/Boolean;

    .line 90
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isGoogle:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static isOppoSystem()Z
    .locals 2

    .line 70
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isOppo:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 71
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "OPPO"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isOppo:Ljava/lang/Boolean;

    .line 73
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isOppo:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static isSamSungSystem()Z
    .locals 2

    .line 58
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSamSung:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 59
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SAMSUNG"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSamSung:Ljava/lang/Boolean;

    .line 61
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSamSung:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static isSmartisanSystem()Z
    .locals 2

    .line 95
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSmartisan:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 96
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SMARTISAN"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSmartisan:Ljava/lang/Boolean;

    .line 98
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSmartisan:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static isSonySystem()Z
    .locals 2

    .line 44
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSony:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 45
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SONY"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isSony:Ljava/lang/Boolean;

    .line 47
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isSony:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method

.method public static isVivoSystem()Z
    .locals 2

    .line 78
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isVivo:Ljava/lang/Boolean;

    if-nez v0, :cond_0

    .line 79
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "VIVO"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sput-object v0, Lcom/android/permission/rom/RomUtils;->isVivo:Ljava/lang/Boolean;

    .line 81
    :cond_0
    sget-object v0, Lcom/android/permission/rom/RomUtils;->isVivo:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    return v0
.end method
