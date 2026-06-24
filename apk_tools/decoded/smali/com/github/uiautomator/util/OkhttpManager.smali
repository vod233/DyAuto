.class public Lcom/github/uiautomator/util/OkhttpManager;
.super Ljava/lang/Object;
.source "OkhttpManager.java"


# static fields
.field private static final JSON:Lokhttp3/MediaType;

.field private static final TAG:Ljava/lang/String; = "OkhttpManager"

.field private static volatile singleton:Lcom/github/uiautomator/util/OkhttpManager;


# instance fields
.field private client:Lokhttp3/OkHttpClient;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 12
    nop

    .line 13
    const-string v0, "application/json; charset=utf-8"

    invoke-static {v0}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;

    move-result-object v0

    sput-object v0, Lcom/github/uiautomator/util/OkhttpManager;->JSON:Lokhttp3/MediaType;

    .line 12
    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 19
    new-instance v0, Lokhttp3/OkHttpClient;

    invoke-direct {v0}, Lokhttp3/OkHttpClient;-><init>()V

    iput-object v0, p0, Lcom/github/uiautomator/util/OkhttpManager;->client:Lokhttp3/OkHttpClient;

    .line 20
    return-void
.end method

.method public static getSingleton()Lcom/github/uiautomator/util/OkhttpManager;
    .locals 2

    .line 22
    sget-object v0, Lcom/github/uiautomator/util/OkhttpManager;->singleton:Lcom/github/uiautomator/util/OkhttpManager;

    if-nez v0, :cond_1

    .line 23
    const-class v0, Lcom/github/uiautomator/util/OkhttpManager;

    monitor-enter v0

    .line 24
    :try_start_0
    sget-object v1, Lcom/github/uiautomator/util/OkhttpManager;->singleton:Lcom/github/uiautomator/util/OkhttpManager;

    if-nez v1, :cond_0

    .line 25
    new-instance v1, Lcom/github/uiautomator/util/OkhttpManager;

    invoke-direct {v1}, Lcom/github/uiautomator/util/OkhttpManager;-><init>()V

    sput-object v1, Lcom/github/uiautomator/util/OkhttpManager;->singleton:Lcom/github/uiautomator/util/OkhttpManager;

    .line 27
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 29
    :cond_1
    :goto_0
    sget-object v0, Lcom/github/uiautomator/util/OkhttpManager;->singleton:Lcom/github/uiautomator/util/OkhttpManager;

    return-object v0
.end method


# virtual methods
.method public delete(Ljava/lang/String;Ljava/lang/String;Lokhttp3/Callback;)V
    .locals 3
    .param p1, "url"    # Ljava/lang/String;
    .param p2, "json"    # Ljava/lang/String;
    .param p3, "callback"    # Lokhttp3/Callback;

    .line 47
    sget-object v0, Lcom/github/uiautomator/util/OkhttpManager;->JSON:Lokhttp3/MediaType;

    invoke-static {v0, p2}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;

    move-result-object v0

    .line 48
    .local v0, "body":Lokhttp3/RequestBody;
    new-instance v1, Lokhttp3/Request$Builder;

    invoke-direct {v1}, Lokhttp3/Request$Builder;-><init>()V

    .line 49
    invoke-virtual {v1, p1}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v1

    .line 50
    invoke-virtual {v1, v0}, Lokhttp3/Request$Builder;->delete(Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;

    move-result-object v1

    .line 51
    invoke-virtual {v1}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v1

    .line 52
    .local v1, "request":Lokhttp3/Request;
    iget-object v2, p0, Lcom/github/uiautomator/util/OkhttpManager;->client:Lokhttp3/OkHttpClient;

    invoke-virtual {v2, v1}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v2

    .line 53
    .local v2, "call":Lokhttp3/Call;
    invoke-interface {v2, p3}, Lokhttp3/Call;->enqueue(Lokhttp3/Callback;)V

    .line 54
    return-void
.end method

.method public newCall(Lokhttp3/Request;Lokhttp3/Callback;)V
    .locals 1
    .param p1, "request"    # Lokhttp3/Request;
    .param p2, "callback"    # Lokhttp3/Callback;

    .line 33
    iget-object v0, p0, Lcom/github/uiautomator/util/OkhttpManager;->client:Lokhttp3/OkHttpClient;

    invoke-virtual {v0, p1}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v0

    invoke-interface {v0, p2}, Lokhttp3/Call;->enqueue(Lokhttp3/Callback;)V

    .line 34
    return-void
.end method

.method public post(Ljava/lang/String;Ljava/lang/String;Lokhttp3/Callback;)V
    .locals 3
    .param p1, "url"    # Ljava/lang/String;
    .param p2, "json"    # Ljava/lang/String;
    .param p3, "callback"    # Lokhttp3/Callback;

    .line 37
    sget-object v0, Lcom/github/uiautomator/util/OkhttpManager;->JSON:Lokhttp3/MediaType;

    invoke-static {v0, p2}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;

    move-result-object v0

    .line 38
    .local v0, "body":Lokhttp3/RequestBody;
    new-instance v1, Lokhttp3/Request$Builder;

    invoke-direct {v1}, Lokhttp3/Request$Builder;-><init>()V

    .line 39
    invoke-virtual {v1, p1}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v1

    .line 40
    invoke-virtual {v1, v0}, Lokhttp3/Request$Builder;->post(Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;

    move-result-object v1

    .line 41
    invoke-virtual {v1}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v1

    .line 42
    .local v1, "request":Lokhttp3/Request;
    iget-object v2, p0, Lcom/github/uiautomator/util/OkhttpManager;->client:Lokhttp3/OkHttpClient;

    invoke-virtual {v2, v1}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;

    move-result-object v2

    .line 43
    .local v2, "call":Lokhttp3/Call;
    invoke-interface {v2, p3}, Lokhttp3/Call;->enqueue(Lokhttp3/Callback;)V

    .line 44
    return-void
.end method
