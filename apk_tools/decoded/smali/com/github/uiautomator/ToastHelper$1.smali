.class Lcom/github/uiautomator/ToastHelper$1;
.super Ljava/util/TimerTask;
.source "ToastHelper.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/github/uiautomator/ToastHelper;->show()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/ToastHelper;


# direct methods
.method constructor <init>(Lcom/github/uiautomator/ToastHelper;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/ToastHelper;

    .line 55
    iput-object p1, p0, Lcom/github/uiautomator/ToastHelper$1;->this$0:Lcom/github/uiautomator/ToastHelper;

    invoke-direct {p0}, Ljava/util/TimerTask;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 58
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper$1;->this$0:Lcom/github/uiautomator/ToastHelper;

    invoke-static {v0}, Lcom/github/uiautomator/ToastHelper;->access$100(Lcom/github/uiautomator/ToastHelper;)Landroid/view/WindowManager;

    move-result-object v0

    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper$1;->this$0:Lcom/github/uiautomator/ToastHelper;

    invoke-static {v1}, Lcom/github/uiautomator/ToastHelper;->access$000(Lcom/github/uiautomator/ToastHelper;)Landroid/view/View;

    move-result-object v1

    invoke-interface {v0, v1}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V

    .line 59
    return-void
.end method
