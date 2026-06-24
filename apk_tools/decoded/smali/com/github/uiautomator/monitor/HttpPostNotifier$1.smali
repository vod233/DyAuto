.class Lcom/github/uiautomator/monitor/HttpPostNotifier$1;
.super Ljava/lang/Object;
.source "HttpPostNotifier.java"

# interfaces
.implements Lokhttp3/Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/monitor/HttpPostNotifier;->Notify(Ljava/lang/String;Lokhttp3/RequestBody;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/monitor/HttpPostNotifier;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/monitor/HttpPostNotifier;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/monitor/HttpPostNotifier;

    .line 40
    iput-object p1, p0, Lcom/github/uiautomator/monitor/HttpPostNotifier$1;->this$0:Lcom/github/uiautomator/monitor/HttpPostNotifier;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFailure(Lokhttp3/Call;Ljava/io/IOException;)V
    .locals 0
    .param p1, "call"    # Lokhttp3/Call;
    .param p2, "e"    # Ljava/io/IOException;

    .line 43
    invoke-virtual {p2}, Ljava/io/IOException;->printStackTrace()V

    .line 44
    return-void
.end method

.method public onResponse(Lokhttp3/Call;Lokhttp3/Response;)V
    .locals 0
    .param p1, "call"    # Lokhttp3/Call;
    .param p2, "response"    # Lokhttp3/Response;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 49
    return-void
.end method
