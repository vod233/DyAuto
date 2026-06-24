.class public Lcom/github/uiautomator/ScreenHttpServer;
.super Lfi/iki/elonen/NanoHTTPD;
.source "ScreenHttpServer.java"


# static fields
.field private static final MIME_TYPE:Ljava/lang/String; = "video/avc"

.field private static final TAG:Ljava/lang/String; = "ScreenHttpServer"

.field protected static final TIMEOUT_USEC:I = 0x2710


# instance fields
.field private landscape:Z

.field private mHeight:I

.field private mWidth:I

.field private rCloseTransaction:Ljava/lang/reflect/Method;

.field private rCreateDisplay:Ljava/lang/reflect/Method;

.field private rDestroyDisplay:Ljava/lang/reflect/Method;

.field private rOpenTransaction:Ljava/lang/reflect/Method;

.field private recording:Ljava/lang/Boolean;

.field private surfaceControl:Ljava/lang/Class;


# direct methods
.method public constructor <init>(I)V
    .locals 1
    .param p1, "port"    # I

    .line 47
    invoke-direct {p0, p1}, Lfi/iki/elonen/NanoHTTPD;-><init>(I)V

    .line 33
    const/16 v0, 0x438

    iput v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    .line 34
    const/16 v0, 0x780

    iput v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I

    .line 35
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->landscape:Z

    .line 36
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->recording:Ljava/lang/Boolean;

    .line 48
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;)Landroid/os/IBinder;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/ScreenHttpServer;
    .param p1, "x1"    # Landroid/media/MediaCodec;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 29
    invoke-direct {p0, p1}, Lcom/github/uiautomator/ScreenHttpServer;->createVirtualDisplay(Landroid/media/MediaCodec;)Landroid/os/IBinder;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$100(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;Landroid/media/MediaMuxer;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/ScreenHttpServer;
    .param p1, "x1"    # Landroid/media/MediaCodec;
    .param p2, "x2"    # Landroid/media/MediaMuxer;

    .line 29
    invoke-direct {p0, p1, p2}, Lcom/github/uiautomator/ScreenHttpServer;->startRecording(Landroid/media/MediaCodec;Landroid/media/MediaMuxer;)V

    return-void
.end method

.method static synthetic access$200(Lcom/github/uiautomator/ScreenHttpServer;Landroid/media/MediaCodec;Landroid/os/IBinder;Landroid/media/MediaMuxer;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/ScreenHttpServer;
    .param p1, "x1"    # Landroid/media/MediaCodec;
    .param p2, "x2"    # Landroid/os/IBinder;
    .param p3, "x3"    # Landroid/media/MediaMuxer;

    .line 29
    invoke-direct {p0, p1, p2, p3}, Lcom/github/uiautomator/ScreenHttpServer;->releaseRecording(Landroid/media/MediaCodec;Landroid/os/IBinder;Landroid/media/MediaMuxer;)V

    return-void
.end method

.method private createAVC()Landroid/media/MediaCodec;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 253
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->getCurrentDisplayRect()Landroid/graphics/Rect;

    move-result-object v0

    .line 254
    .local v0, "display":Landroid/graphics/Rect;
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v1

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v2

    const-string v3, "video/avc"

    invoke-static {v3, v1, v2}, Landroid/media/MediaFormat;->createVideoFormat(Ljava/lang/String;II)Landroid/media/MediaFormat;

    move-result-object v1

    .line 256
    .local v1, "format":Landroid/media/MediaFormat;
    const-string v2, "color-format"

    const v4, 0x7f000789

    invoke-virtual {v1, v2, v4}, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V

    .line 258
    const-string v2, "bitrate"

    const v4, 0x16e360

    invoke-virtual {v1, v2, v4}, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V

    .line 259
    const-string v2, "frame-rate"

    const/16 v4, 0x14

    invoke-virtual {v1, v2, v4}, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V

    .line 260
    const-string v2, "i-frame-interval"

    const/16 v4, 0xa

    invoke-virtual {v1, v2, v4}, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V

    .line 261
    invoke-static {v3}, Landroid/media/MediaCodec;->createEncoderByType(Ljava/lang/String;)Landroid/media/MediaCodec;

    move-result-object v2

    .line 262
    .local v2, "mMediaCodec":Landroid/media/MediaCodec;
    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-virtual {v2, v1, v3, v3, v4}, Landroid/media/MediaCodec;->configure(Landroid/media/MediaFormat;Landroid/view/Surface;Landroid/media/MediaCrypto;I)V

    .line 263
    return-object v2
.end method

.method private createVirtualDisplay(Landroid/media/MediaCodec;)Landroid/os/IBinder;
    .locals 13
    .param p1, "mediaCodec"    # Landroid/media/MediaCodec;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 210
    :try_start_0
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v1, "createDisplay"

    const/4 v2, 0x2

    new-array v3, v2, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/4 v6, 0x1

    aput-object v4, v3, v6

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rCreateDisplay:Ljava/lang/reflect/Method;

    .line 211
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v1, "openTransaction"

    new-array v3, v5, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rOpenTransaction:Ljava/lang/reflect/Method;

    .line 212
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v1, "closeTransaction"

    new-array v3, v5, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rCloseTransaction:Ljava/lang/reflect/Method;

    .line 213
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v1, "destroyDisplay"

    new-array v3, v6, [Ljava/lang/Class;

    const-class v4, Landroid/os/IBinder;

    aput-object v4, v3, v5

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rDestroyDisplay:Ljava/lang/reflect/Method;

    .line 215
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rCreateDisplay:Ljava/lang/reflect/Method;

    new-array v1, v2, [Ljava/lang/Object;

    const-string v3, "UIAutomatorDisplay"

    aput-object v3, v1, v5

    invoke-static {v5}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    aput-object v3, v1, v6

    const/4 v3, 0x0

    invoke-virtual {v0, v3, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/IBinder;

    .line 216
    .local v0, "mDisplay":Landroid/os/IBinder;
    iget-object v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v4, "setDisplaySurface"

    new-array v7, v2, [Ljava/lang/Class;

    const-class v8, Landroid/os/IBinder;

    aput-object v8, v7, v5

    const-class v8, Landroid/view/Surface;

    aput-object v8, v7, v6

    invoke-virtual {v1, v4, v7}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 217
    .local v1, "setDisplaySurface":Ljava/lang/reflect/Method;
    iget-object v4, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v7, "setDisplayProjection"

    const/4 v8, 0x4

    new-array v9, v8, [Ljava/lang/Class;

    const-class v10, Landroid/os/IBinder;

    aput-object v10, v9, v5

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v6

    const-class v10, Landroid/graphics/Rect;

    aput-object v10, v9, v2

    const-class v10, Landroid/graphics/Rect;

    const/4 v11, 0x3

    aput-object v10, v9, v11

    invoke-virtual {v4, v7, v9}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    .line 218
    .local v4, "setDisplayProjection":Ljava/lang/reflect/Method;
    iget-object v7, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v9, "setDisplayLayerStack"

    new-array v10, v2, [Ljava/lang/Class;

    const-class v12, Landroid/os/IBinder;

    aput-object v12, v10, v5

    sget-object v12, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v12, v10, v6

    invoke-virtual {v7, v9, v10}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    .line 220
    .local v7, "setDisplayLayerStack":Ljava/lang/reflect/Method;
    invoke-virtual {p1}, Landroid/media/MediaCodec;->createInputSurface()Landroid/view/Surface;

    move-result-object v9

    .line 221
    .local v9, "surface":Landroid/view/Surface;
    invoke-virtual {p1}, Landroid/media/MediaCodec;->start()V

    .line 223
    iget-object v10, p0, Lcom/github/uiautomator/ScreenHttpServer;->rOpenTransaction:Ljava/lang/reflect/Method;

    new-array v12, v5, [Ljava/lang/Object;

    invoke-virtual {v10, v3, v12}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 224
    new-array v10, v2, [Ljava/lang/Object;

    aput-object v0, v10, v5

    aput-object v9, v10, v6

    invoke-virtual {v1, v3, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 225
    new-array v8, v8, [Ljava/lang/Object;

    aput-object v0, v8, v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v8, v6

    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->getCurrentDisplayRect()Landroid/graphics/Rect;

    move-result-object v10

    aput-object v10, v8, v2

    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->getCurrentDisplayRect()Landroid/graphics/Rect;

    move-result-object v10

    aput-object v10, v8, v11

    invoke-virtual {v4, v3, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 226
    new-array v2, v2, [Ljava/lang/Object;

    aput-object v0, v2, v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    aput-object v8, v2, v6

    invoke-virtual {v7, v3, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 227
    iget-object v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->rCloseTransaction:Ljava/lang/reflect/Method;

    new-array v5, v5, [Ljava/lang/Object;

    invoke-virtual {v2, v3, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 229
    return-object v0

    .line 230
    .end local v0    # "mDisplay":Landroid/os/IBinder;
    .end local v1    # "setDisplaySurface":Ljava/lang/reflect/Method;
    .end local v4    # "setDisplayProjection":Ljava/lang/reflect/Method;
    .end local v7    # "setDisplayLayerStack":Ljava/lang/reflect/Method;
    .end local v9    # "surface":Landroid/view/Surface;
    :catch_0
    move-exception v0

    .line 231
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 232
    new-instance v1, Ljava/lang/Exception;

    const-string v2, "virtual display"

    invoke-direct {v1, v2, v0}, Ljava/lang/Exception;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method private getCurrentDisplayRect()Landroid/graphics/Rect;
    .locals 4

    .line 267
    iget-boolean v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->landscape:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 268
    new-instance v0, Landroid/graphics/Rect;

    iget v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I

    iget v3, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    invoke-direct {v0, v1, v1, v2, v3}, Landroid/graphics/Rect;-><init>(IIII)V

    return-object v0

    .line 270
    :cond_0
    new-instance v0, Landroid/graphics/Rect;

    iget v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    iget v3, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I

    invoke-direct {v0, v1, v1, v2, v3}, Landroid/graphics/Rect;-><init>(IIII)V

    return-object v0
.end method

.method private handleGetScreenshot()Lfi/iki/elonen/NanoHTTPD$Response;
    .locals 7

    .line 90
    const/4 v0, 0x0

    .line 92
    .local v0, "injector":Ljava/lang/reflect/Method;
    :try_start_0
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->takeScreenshot()Landroid/graphics/Bitmap;

    move-result-object v1

    .line 93
    .local v1, "bmp":Landroid/graphics/Bitmap;
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 94
    .local v2, "bout":Ljava/io/ByteArrayOutputStream;
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v4, 0x4b

    invoke-virtual {v1, v3, v4, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 95
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    .line 96
    sget-object v3, Lfi/iki/elonen/NanoHTTPD$Response$Status;->OK:Lfi/iki/elonen/NanoHTTPD$Response$Status;

    const-string v4, "image/jpeg"

    new-instance v5, Ljava/io/ByteArrayInputStream;

    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-static {v3, v4, v5}, Lcom/github/uiautomator/ScreenHttpServer;->newChunkedResponse(Lfi/iki/elonen/NanoHTTPD$Response$IStatus;Ljava/lang/String;Ljava/io/InputStream;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v3

    .line 97
    .end local v1    # "bmp":Landroid/graphics/Bitmap;
    .end local v2    # "bout":Ljava/io/ByteArrayOutputStream;
    :catch_0
    move-exception v1

    .line 98
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 99
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Screenshot exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v2

    return-object v2
.end method

.method private handlePostScreenrecord(Ljava/util/Map;)Lfi/iki/elonen/NanoHTTPD$Response;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Lfi/iki/elonen/NanoHTTPD$Response;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 118
    .local p1, "params":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-ge v0, v1, :cond_0

    .line 119
    const-string v0, "Screenrecord require SDK >= 21"

    invoke-static {v0}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 121
    :cond_0
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->recording:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 122
    const-string v0, "Already started record!"

    invoke-static {v0}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 124
    :cond_1
    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    iput-object v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->recording:Ljava/lang/Boolean;

    .line 125
    const-string v1, "landscape"

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    const-string v3, "true"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_3

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const-string v2, "1"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :cond_3
    :goto_0
    iput-boolean v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->landscape:Z

    .line 127
    const-string v0, "path"

    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 128
    .local v0, "videoPath":Ljava/lang/String;
    if-eqz v0, :cond_4

    const-string v1, ""

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 129
    :cond_4
    const-string v0, "/sdcard/video.mp4"

    .line 131
    :cond_5
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 133
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->createAVC()Landroid/media/MediaCodec;

    move-result-object v1

    .line 134
    .local v1, "avc":Landroid/media/MediaCodec;
    new-instance v8, Landroid/media/MediaMuxer;

    invoke-direct {v8, v0, v3}, Landroid/media/MediaMuxer;-><init>(Ljava/lang/String;I)V

    .line 136
    .local v8, "muxer":Landroid/media/MediaMuxer;
    move-object v9, v0

    .line 137
    .local v9, "finalVideoPath":Ljava/lang/String;
    new-instance v2, Lcom/github/uiautomator/ScreenHttpServer$1;

    const-string v6, "ScreenRecord"

    move-object v4, v2

    move-object v5, p0

    move-object v7, v1

    invoke-direct/range {v4 .. v9}, Lcom/github/uiautomator/ScreenHttpServer$1;-><init>(Lcom/github/uiautomator/ScreenHttpServer;Ljava/lang/String;Landroid/media/MediaCodec;Landroid/media/MediaMuxer;Ljava/lang/String;)V

    .line 152
    invoke-virtual {v2}, Lcom/github/uiautomator/ScreenHttpServer$1;->start()V

    .line 154
    const-string v2, "OK"

    invoke-static {v2}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v2

    return-object v2
.end method

.method private handlePutScreenrecord()Lfi/iki/elonen/NanoHTTPD$Response;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 159
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->recording:Ljava/lang/Boolean;

    .line 160
    const-string v0, "OK"

    invoke-static {v0}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0
.end method

.method private releaseRecording(Landroid/media/MediaCodec;Landroid/os/IBinder;Landroid/media/MediaMuxer;)V
    .locals 4
    .param p1, "avc"    # Landroid/media/MediaCodec;
    .param p2, "bDisplay"    # Landroid/os/IBinder;
    .param p3, "muxer"    # Landroid/media/MediaMuxer;

    .line 239
    :try_start_0
    invoke-virtual {p1}, Landroid/media/MediaCodec;->stop()V

    .line 240
    invoke-virtual {p1}, Landroid/media/MediaCodec;->release()V

    .line 241
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->rDestroyDisplay:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p2, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 242
    invoke-virtual {p3}, Landroid/media/MediaMuxer;->stop()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 248
    goto :goto_0

    .line 246
    :catch_0
    move-exception v0

    .line 247
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 249
    .end local v0    # "ex":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method private startRecording(Landroid/media/MediaCodec;Landroid/media/MediaMuxer;)V
    .locals 7
    .param p1, "avc"    # Landroid/media/MediaCodec;
    .param p2, "muxer"    # Landroid/media/MediaMuxer;

    .line 165
    new-instance v0, Landroid/media/MediaCodec$BufferInfo;

    invoke-direct {v0}, Landroid/media/MediaCodec$BufferInfo;-><init>()V

    .line 166
    .local v0, "bufferInfo":Landroid/media/MediaCodec$BufferInfo;
    const/4 v1, -0x1

    .line 168
    .local v1, "track":I
    :goto_0
    :try_start_0
    iget-object v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->recording:Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    if-eqz v2, :cond_8

    .line 170
    const-wide/16 v2, 0x2710

    invoke-virtual {p1, v0, v2, v3}, Landroid/media/MediaCodec;->dequeueOutputBuffer(Landroid/media/MediaCodec$BufferInfo;J)I

    move-result v2

    .line 171
    .local v2, "index":I
    const/4 v3, -0x1

    if-ne v2, v3, :cond_0

    goto/16 :goto_1

    .line 173
    :cond_0
    const/4 v4, -0x2

    if-ne v2, v4, :cond_3

    .line 174
    if-ne v1, v3, :cond_2

    .line 178
    invoke-virtual {p1}, Landroid/media/MediaCodec;->getOutputFormat()Landroid/media/MediaFormat;

    move-result-object v3

    .line 179
    .local v3, "format":Landroid/media/MediaFormat;
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Output format changed to "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Landroid/media/MediaFormat;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 180
    invoke-virtual {p2, v3}, Landroid/media/MediaMuxer;->addTrack(Landroid/media/MediaFormat;)I

    move-result v4

    move v1, v4

    .line 181
    invoke-virtual {p2}, Landroid/media/MediaMuxer;->start()V

    .line 182
    .end local v3    # "format":Landroid/media/MediaFormat;
    :cond_1
    goto :goto_1

    .line 175
    :cond_2
    new-instance v3, Ljava/lang/RuntimeException;

    const-string v4, "format changed twice"

    invoke-direct {v3, v4}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    .end local v0    # "bufferInfo":Landroid/media/MediaCodec$BufferInfo;
    .end local v1    # "track":I
    .end local p1    # "avc":Landroid/media/MediaCodec;
    .end local p2    # "muxer":Landroid/media/MediaMuxer;
    throw v3

    .line 182
    .restart local v0    # "bufferInfo":Landroid/media/MediaCodec$BufferInfo;
    .restart local v1    # "track":I
    .restart local p1    # "avc":Landroid/media/MediaCodec;
    .restart local p2    # "muxer":Landroid/media/MediaMuxer;
    :cond_3
    if-ltz v2, :cond_1

    .line 183
    if-eq v1, v3, :cond_6

    .line 186
    invoke-virtual {p1, v2}, Landroid/media/MediaCodec;->getOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v3

    .line 187
    .local v3, "data":Ljava/nio/ByteBuffer;
    iget v4, v0, Landroid/media/MediaCodec$BufferInfo;->flags:I

    and-int/lit8 v4, v4, 0x2

    const/4 v5, 0x0

    if-eqz v4, :cond_4

    .line 188
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v6, "ignoring BUFFER_FLAG_CODEC_CONFIG"

    invoke-virtual {v4, v6}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 189
    iput v5, v0, Landroid/media/MediaCodec$BufferInfo;->size:I

    .line 191
    :cond_4
    iget v4, v0, Landroid/media/MediaCodec$BufferInfo;->size:I

    if-nez v4, :cond_5

    .line 192
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v6, "Ignore data(size=0)"

    invoke-virtual {v4, v6}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 193
    const/4 v3, 0x0

    .line 195
    :cond_5
    if-eqz v3, :cond_7

    .line 196
    iget v4, v0, Landroid/media/MediaCodec$BufferInfo;->offset:I

    invoke-virtual {v3, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 197
    iget v4, v0, Landroid/media/MediaCodec$BufferInfo;->offset:I

    iget v6, v0, Landroid/media/MediaCodec$BufferInfo;->size:I

    add-int/2addr v4, v6

    invoke-virtual {v3, v4}, Ljava/nio/ByteBuffer;->limit(I)Ljava/nio/Buffer;

    .line 198
    invoke-virtual {p2, v1, v3, v0}, Landroid/media/MediaMuxer;->writeSampleData(ILjava/nio/ByteBuffer;Landroid/media/MediaCodec$BufferInfo;)V

    .line 199
    invoke-virtual {p1, v2, v5}, Landroid/media/MediaCodec;->releaseOutputBuffer(IZ)V

    goto :goto_1

    .line 184
    .end local v3    # "data":Ljava/nio/ByteBuffer;
    :cond_6
    new-instance v3, Ljava/lang/Exception;

    const-string v4, "MediaCodec track index is not setted!"

    invoke-direct {v3, v4}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    .end local v0    # "bufferInfo":Landroid/media/MediaCodec$BufferInfo;
    .end local v1    # "track":I
    .end local p1    # "avc":Landroid/media/MediaCodec;
    .end local p2    # "muxer":Landroid/media/MediaMuxer;
    throw v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 202
    .end local v2    # "index":I
    .restart local v0    # "bufferInfo":Landroid/media/MediaCodec$BufferInfo;
    .restart local v1    # "track":I
    .restart local p1    # "avc":Landroid/media/MediaCodec;
    .restart local p2    # "muxer":Landroid/media/MediaMuxer;
    :cond_7
    :goto_1
    goto/16 :goto_0

    .line 205
    :cond_8
    goto :goto_2

    .line 203
    :catch_0
    move-exception v2

    .line 204
    .local v2, "ex":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 206
    .end local v2    # "ex":Ljava/lang/Exception;
    :goto_2
    return-void
.end method

.method private takeScreenshot()Landroid/graphics/Bitmap;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 105
    :try_start_0
    iget-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    const-string v1, "screenshot"

    const/4 v2, 0x2

    new-array v3, v2, [Ljava/lang/Class;

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v6, 0x1

    aput-object v4, v3, v6

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 106
    .local v0, "rScreenshot":Ljava/lang/reflect/Method;
    const/4 v1, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v2, v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v2, v6

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/Bitmap;

    .line 108
    .local v1, "bmp":Landroid/graphics/Bitmap;
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    iput v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    .line 109
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    iput v2, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 110
    return-object v1

    .line 111
    .end local v0    # "rScreenshot":Ljava/lang/reflect/Method;
    .end local v1    # "bmp":Landroid/graphics/Bitmap;
    :catch_0
    move-exception v0

    .line 112
    .local v0, "e":Ljava/lang/Exception;
    new-instance v1, Ljava/lang/Exception;

    const-string v2, "Inject SurfaceControl fail"

    invoke-direct {v1, v2, v0}, Ljava/lang/Exception;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method


# virtual methods
.method public initialize()V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 51
    const-string v0, "android.view.SurfaceControl"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/ScreenHttpServer;->surfaceControl:Ljava/lang/Class;

    .line 52
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->takeScreenshot()Landroid/graphics/Bitmap;

    move-result-object v0

    .line 53
    .local v0, "bmp":Landroid/graphics/Bitmap;
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v1

    iput v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    .line 54
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v1

    iput v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I

    .line 55
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->landscape:Z

    .line 56
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 58
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "System info:\n"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v4, 0x3

    new-array v4, v4, [Ljava/lang/Object;

    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v1

    iget v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->mWidth:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v5, 0x1

    aput-object v1, v4, v5

    iget v1, p0, Lcom/github/uiautomator/ScreenHttpServer;->mHeight:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v5, 0x2

    aput-object v1, v4, v5

    const-string v1, "\tSDK: %d\n\tDisplay: %dx%d"

    invoke-static {v1, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 59
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-ge v1, v2, :cond_0

    .line 60
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v2, "Screenrecord require SDK >= 21"

    invoke-virtual {v1, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 62
    :cond_0
    return-void
.end method

.method public serve(Ljava/lang/String;Lfi/iki/elonen/NanoHTTPD$Method;Ljava/util/Map;Ljava/util/Map;Ljava/util/Map;)Lfi/iki/elonen/NanoHTTPD$Response;
    .locals 4
    .param p1, "uri"    # Ljava/lang/String;
    .param p2, "method"    # Lfi/iki/elonen/NanoHTTPD$Method;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Lfi/iki/elonen/NanoHTTPD$Method;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Lfi/iki/elonen/NanoHTTPD$Response;"
        }
    .end annotation

    .line 68
    .local p3, "headers":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    .local p4, "params":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    .local p5, "files":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v0, "/screenrecord"

    const/4 v1, 0x4

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const/4 v2, 0x1

    aput-object p2, v1, v2

    const/4 v2, 0x2

    aput-object p4, v1, v2

    const/4 v2, 0x3

    aput-object p5, v1, v2

    const-string v2, "URI: %s, Method: %s, params, %s, files: %s"

    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "ScreenHttpServer"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 70
    :try_start_0
    const-string v1, "/stop"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 71
    invoke-virtual {p0}, Lcom/github/uiautomator/ScreenHttpServer;->stop()V

    .line 72
    const-string v0, "Server stopped"

    invoke-static {v0}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 73
    :cond_0
    const-string v1, "/screenshot"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 74
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->handleGetScreenshot()Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 75
    :cond_1
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    sget-object v1, Lfi/iki/elonen/NanoHTTPD$Method;->POST:Lfi/iki/elonen/NanoHTTPD$Method;

    if-ne v1, p2, :cond_2

    .line 76
    invoke-direct {p0, p4}, Lcom/github/uiautomator/ScreenHttpServer;->handlePostScreenrecord(Ljava/util/Map;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 77
    :cond_2
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    sget-object v0, Lfi/iki/elonen/NanoHTTPD$Method;->PUT:Lfi/iki/elonen/NanoHTTPD$Method;

    if-ne v0, p2, :cond_3

    .line 78
    invoke-direct {p0}, Lcom/github/uiautomator/ScreenHttpServer;->handlePutScreenrecord()Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 84
    :cond_3
    nop

    .line 85
    const-string v0, "404 Not found"

    invoke-static {v0}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v0

    return-object v0

    .line 80
    :catch_0
    move-exception v0

    .line 81
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 82
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Internal Error: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 83
    sget-object v1, Lfi/iki/elonen/NanoHTTPD$Response$Status;->INTERNAL_ERROR:Lfi/iki/elonen/NanoHTTPD$Response$Status;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v2

    const-string v3, "text/plain"

    invoke-static {v1, v3, v2}, Lcom/github/uiautomator/ScreenHttpServer;->newFixedLengthResponse(Lfi/iki/elonen/NanoHTTPD$Response$IStatus;Ljava/lang/String;Ljava/lang/String;)Lfi/iki/elonen/NanoHTTPD$Response;

    move-result-object v1

    return-object v1
.end method
