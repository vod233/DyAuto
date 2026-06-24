.class public Lcom/github/uiautomator/monitor/HttpPostNotifier;
.super Ljava/lang/Object;
.source "HttpPostNotifier.java"


# instance fields
.field private okhttpManager:Lcom/github/uiautomator/util/OkhttpManager;

.field private reportUrl:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;)V
    .locals 1
    .param p1, "reportUrl"    # Ljava/lang/String;

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 25
    iput-object p1, p0, Lcom/github/uiautomator/monitor/HttpPostNotifier;->reportUrl:Ljava/lang/String;

    .line 26
    invoke-static {}, Lcom/github/uiautomator/util/OkhttpManager;->getSingleton()Lcom/github/uiautomator/util/OkhttpManager;

    move-result-object v0

    iput-object v0, p0, Lcom/github/uiautomator/monitor/HttpPostNotifier;->okhttpManager:Lcom/github/uiautomator/util/OkhttpManager;

    .line 27
    return-void
.end method


# virtual methods
.method public Notify(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p1, "baseUrl"    # Ljava/lang/String;
    .param p2, "content"    # Ljava/lang/String;

    .line 30
    const-string v0, "application/json; charset=utf-8"

    invoke-static {v0}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;

    move-result-object v0

    invoke-static {v0, p2}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;

    move-result-object v0

    .line 31
    .local v0, "body":Lokhttp3/RequestBody;
    invoke-virtual {p0, p1, v0}, Lcom/github/uiautomator/monitor/HttpPostNotifier;->Notify(Ljava/lang/String;Lokhttp3/RequestBody;)V

    .line 32
    return-void
.end method

.method public Notify(Ljava/lang/String;Lokhttp3/RequestBody;)V
    .locals 3
    .param p1, "baseUrl"    # Ljava/lang/String;
    .param p2, "body"    # Lokhttp3/RequestBody;

    .line 36
    new-instance v0, Lokhttp3/Request$Builder;

    invoke-direct {v0}, Lokhttp3/Request$Builder;-><init>()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/github/uiautomator/monitor/HttpPostNotifier;->reportUrl:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 37
    invoke-virtual {v0, v1}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    move-result-object v0

    .line 38
    invoke-virtual {v0, p2}, Lokhttp3/Request$Builder;->post(Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;

    move-result-object v0

    .line 39
    invoke-virtual {v0}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;

    move-result-object v0

    .line 40
    .local v0, "request":Lokhttp3/Request;
    iget-object v1, p0, Lcom/github/uiautomator/monitor/HttpPostNotifier;->okhttpManager:Lcom/github/uiautomator/util/OkhttpManager;

    new-instance v2, Lcom/github/uiautomator/monitor/HttpPostNotifier$1;

    invoke-direct {v2, p0}, Lcom/github/uiautomator/monitor/HttpPostNotifier$1;-><init>(Lcom/github/uiautomator/monitor/HttpPostNotifier;)V

    invoke-virtual {v1, v0, v2}, Lcom/github/uiautomator/util/OkhttpManager;->newCall(Lokhttp3/Request;Lokhttp3/Callback;)V

    .line 51
    return-void
.end method
