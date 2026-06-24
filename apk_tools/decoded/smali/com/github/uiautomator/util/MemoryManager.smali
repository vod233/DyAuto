.class public Lcom/github/uiautomator/util/MemoryManager;
.super Ljava/lang/Object;
.source "MemoryManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;,
        Lcom/github/uiautomator/util/MemoryManager$Volume;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getAvailableInternalMemorySize()J
    .locals 8

    .line 40
    invoke-static {}, Landroid/os/Environment;->getDataDirectory()Ljava/io/File;

    move-result-object v0

    .line 41
    .local v0, "path":Ljava/io/File;
    new-instance v1, Landroid/os/StatFs;

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 42
    .local v1, "stat":Landroid/os/StatFs;
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSize()I

    move-result v2

    int-to-long v2, v2

    .line 44
    .local v2, "blockSize":J
    invoke-virtual {v1}, Landroid/os/StatFs;->getAvailableBlocks()I

    move-result v4

    int-to-long v4, v4

    .line 45
    .local v4, "availableBlocks":J
    mul-long v6, v4, v2

    return-wide v6
.end method

.method public static getFreeSpace(Landroid/content/Context;)J
    .locals 8
    .param p0, "context"    # Landroid/content/Context;

    .line 87
    invoke-static {p0}, Lcom/github/uiautomator/util/MemoryManager;->getVolume(Landroid/content/Context;)Ljava/util/ArrayList;

    move-result-object v0

    .line 88
    .local v0, "volumes":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Lcom/github/uiautomator/util/MemoryManager$Volume;>;"
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    const/4 v2, 0x1

    if-le v1, v2, :cond_0

    .line 89
    new-instance v1, Landroid/os/StatFs;

    invoke-static {}, Lcom/github/uiautomator/util/MemoryManager;->getSDCardPath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 91
    .local v1, "stat":Landroid/os/StatFs;
    invoke-virtual {v1}, Landroid/os/StatFs;->getAvailableBlocksLong()J

    move-result-wide v2

    .line 92
    .local v2, "availableBlocks":J
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSizeLong()J

    move-result-wide v4

    .line 93
    .local v4, "blockSize":J
    mul-long v6, v2, v4

    return-wide v6

    .line 95
    .end local v1    # "stat":Landroid/os/StatFs;
    .end local v2    # "availableBlocks":J
    .end local v4    # "blockSize":J
    :cond_0
    const-wide/16 v1, -0x1

    return-wide v1
.end method

.method public static getSDCardInfo()Ljava/lang/String;
    .locals 4

    .line 106
    new-instance v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;

    invoke-direct {v0}, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;-><init>()V

    .line 107
    .local v0, "sd":Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;
    invoke-static {}, Lcom/github/uiautomator/util/MemoryManager;->isSDCardEnable()Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, "sdcard unable!"

    return-object v1

    .line 108
    :cond_0
    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->isExist:Z

    .line 109
    new-instance v1, Landroid/os/StatFs;

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 110
    .local v1, "sf":Landroid/os/StatFs;
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockCountLong()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->totalBlocks:J

    .line 111
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSizeLong()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->blockByteSize:J

    .line 112
    invoke-virtual {v1}, Landroid/os/StatFs;->getAvailableBlocksLong()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->availableBlocks:J

    .line 113
    invoke-virtual {v1}, Landroid/os/StatFs;->getAvailableBytes()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->availableBytes:J

    .line 114
    invoke-virtual {v1}, Landroid/os/StatFs;->getFreeBlocksLong()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->freeBlocks:J

    .line 115
    invoke-virtual {v1}, Landroid/os/StatFs;->getFreeBytes()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->freeBytes:J

    .line 116
    invoke-virtual {v1}, Landroid/os/StatFs;->getTotalBytes()J

    move-result-wide v2

    iput-wide v2, v0, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->totalBytes:J

    .line 117
    invoke-virtual {v0}, Lcom/github/uiautomator/util/MemoryManager$SDCardInfo;->toString()Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method private static getSDCardPath()Ljava/lang/String;
    .locals 2

    .line 76
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    .line 77
    .local v0, "path":Ljava/io/File;
    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method public static getTotalExternalMemorySize()J
    .locals 8

    .line 63
    invoke-static {}, Lcom/github/uiautomator/util/MemoryManager;->isSDCardEnable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 65
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    .line 66
    .local v0, "path":Ljava/io/File;
    new-instance v1, Landroid/os/StatFs;

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 67
    .local v1, "stat":Landroid/os/StatFs;
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSize()I

    move-result v2

    int-to-long v2, v2

    .line 68
    .local v2, "blockSize":J
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockCount()I

    move-result v4

    int-to-long v4, v4

    .line 69
    .local v4, "totalBlocks":J
    mul-long v6, v4, v2

    return-wide v6

    .line 71
    .end local v0    # "path":Ljava/io/File;
    .end local v1    # "stat":Landroid/os/StatFs;
    .end local v2    # "blockSize":J
    .end local v4    # "totalBlocks":J
    :cond_0
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method public static getTotalInternalMemorySize()J
    .locals 8

    .line 24
    invoke-static {}, Landroid/os/Environment;->getDataDirectory()Ljava/io/File;

    move-result-object v0

    .line 26
    .local v0, "path":Ljava/io/File;
    new-instance v1, Landroid/os/StatFs;

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 28
    .local v1, "stat":Landroid/os/StatFs;
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockSize()I

    move-result v2

    int-to-long v2, v2

    .line 30
    .local v2, "blockSize":J
    invoke-virtual {v1}, Landroid/os/StatFs;->getBlockCount()I

    move-result v4

    int-to-long v4, v4

    .line 31
    .local v4, "totalBlocks":J
    mul-long v6, v4, v2

    return-wide v6
.end method

.method private static getVolume(Landroid/content/Context;)Ljava/util/ArrayList;
    .locals 10
    .param p0, "context"    # Landroid/content/Context;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/github/uiautomator/util/MemoryManager$Volume;",
            ">;"
        }
    .end annotation

    .line 124
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 126
    .local v0, "list_storagevolume":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Lcom/github/uiautomator/util/MemoryManager$Volume;>;"
    const-string v1, "storage"

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/storage/StorageManager;

    .line 129
    .local v1, "storageManager":Landroid/os/storage/StorageManager;
    :try_start_0
    const-class v2, Landroid/os/storage/StorageManager;

    const-string v3, "getVolumeList"

    const/4 v4, 0x0

    new-array v5, v4, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    .line 131
    .local v2, "method_volumeList":Ljava/lang/reflect/Method;
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 133
    new-array v3, v4, [Ljava/lang/Object;

    invoke-virtual {v2, v1, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Ljava/lang/Object;

    .line 134
    .local v3, "volumeList":[Ljava/lang/Object;
    if-eqz v3, :cond_0

    .line 136
    const/4 v5, 0x0

    .local v5, "i":I
    :goto_0
    array-length v6, v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_3

    if-ge v5, v6, :cond_0

    .line 138
    :try_start_1
    new-instance v6, Lcom/github/uiautomator/util/MemoryManager$Volume;

    invoke-direct {v6}, Lcom/github/uiautomator/util/MemoryManager$Volume;-><init>()V

    .line 139
    .local v6, "volume":Lcom/github/uiautomator/util/MemoryManager$Volume;
    aget-object v7, v3, v5

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    const-string v8, "getPath"

    new-array v9, v4, [Ljava/lang/Class;

    invoke-virtual {v7, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    aget-object v8, v3, v5

    new-array v9, v4, [Ljava/lang/Object;

    invoke-virtual {v7, v8, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    invoke-virtual {v6, v7}, Lcom/github/uiautomator/util/MemoryManager$Volume;->setPath(Ljava/lang/String;)V

    .line 140
    aget-object v7, v3, v5

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    const-string v8, "isRemovable"

    new-array v9, v4, [Ljava/lang/Class;

    invoke-virtual {v7, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    aget-object v8, v3, v5

    new-array v9, v4, [Ljava/lang/Object;

    invoke-virtual {v7, v8, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Boolean;

    invoke-virtual {v7}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v7

    invoke-virtual {v6, v7}, Lcom/github/uiautomator/util/MemoryManager$Volume;->setRemovable(Z)V

    .line 141
    aget-object v7, v3, v5

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    const-string v8, "getState"

    new-array v9, v4, [Ljava/lang/Class;

    invoke-virtual {v7, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    aget-object v8, v3, v5

    new-array v9, v4, [Ljava/lang/Object;

    invoke-virtual {v7, v8, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    invoke-virtual {v6, v7}, Lcom/github/uiautomator/util/MemoryManager$Volume;->setState(Ljava/lang/String;)V

    .line 142
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3

    .line 149
    goto :goto_1

    .line 147
    .end local v6    # "volume":Lcom/github/uiautomator/util/MemoryManager$Volume;
    :catch_0
    move-exception v6

    .line 148
    .local v6, "e":Ljava/lang/NoSuchMethodException;
    :try_start_2
    invoke-virtual {v6}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    goto :goto_1

    .line 145
    .end local v6    # "e":Ljava/lang/NoSuchMethodException;
    :catch_1
    move-exception v6

    .line 146
    .local v6, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v6}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    .line 149
    .end local v6    # "e":Ljava/lang/reflect/InvocationTargetException;
    goto :goto_1

    .line 143
    :catch_2
    move-exception v6

    .line 144
    .local v6, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v6}, Ljava/lang/IllegalAccessException;->printStackTrace()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_3

    .line 149
    .end local v6    # "e":Ljava/lang/IllegalAccessException;
    nop

    .line 136
    :goto_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 155
    .end local v2    # "method_volumeList":Ljava/lang/reflect/Method;
    .end local v3    # "volumeList":[Ljava/lang/Object;
    .end local v5    # "i":I
    :cond_0
    goto :goto_2

    .line 153
    :catch_3
    move-exception v2

    .line 154
    .local v2, "e1":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 157
    .end local v2    # "e1":Ljava/lang/Exception;
    :goto_2
    return-object v0
.end method

.method private static isSDCardEnable()Z
    .locals 2

    .line 54
    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v0

    const-string v1, "mounted"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method
