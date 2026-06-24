.class public Lcom/github/uiautomator/ToastHelper;
.super Ljava/lang/Object;
.source "ToastHelper.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "ToastHelper"


# instance fields
.field private duration:I

.field private params:Landroid/view/WindowManager$LayoutParams;

.field private timer:Ljava/util/Timer;

.field private toastView:Landroid/view/View;

.field private windowManager:Landroid/view/WindowManager;


# direct methods
.method private constructor <init>(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "text"    # Ljava/lang/String;
    .param p3, "duration"    # I

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    iput p3, p0, Lcom/github/uiautomator/ToastHelper;->duration:I

    .line 28
    new-instance v0, Ljava/util/Timer;

    invoke-direct {v0}, Ljava/util/Timer;-><init>()V

    iput-object v0, p0, Lcom/github/uiautomator/ToastHelper;->timer:Ljava/util/Timer;

    .line 29
    const/4 v0, 0x1

    invoke-static {p1, p2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    .line 30
    .local v0, "toast":Landroid/widget/Toast;
    const-string v1, "window"

    invoke-virtual {p1, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    iput-object v1, p0, Lcom/github/uiautomator/ToastHelper;->windowManager:Landroid/view/WindowManager;

    .line 31
    invoke-virtual {v0}, Landroid/widget/Toast;->getView()Landroid/view/View;

    move-result-object v1

    iput-object v1, p0, Lcom/github/uiautomator/ToastHelper;->toastView:Landroid/view/View;

    .line 32
    new-instance v1, Landroid/view/WindowManager$LayoutParams;

    invoke-direct {v1}, Landroid/view/WindowManager$LayoutParams;-><init>()V

    iput-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    .line 33
    const/4 v2, -0x2

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->height:I

    .line 34
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 35
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/4 v2, -0x3

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->format:I

    .line 36
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/4 v2, -0x1

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->windowAnimations:I

    .line 37
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/16 v2, 0x7d5

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->type:I

    .line 38
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const-string v2, "Toast"

    invoke-virtual {v1, v2}, Landroid/view/WindowManager$LayoutParams;->setTitle(Ljava/lang/CharSequence;)V

    .line 39
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/16 v2, 0x98

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->flags:I

    .line 42
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/16 v2, 0x51

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 43
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const v2, 0x3e4ccccd    # 0.2f

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->verticalMargin:F

    .line 44
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const v2, 0x3f4ccccd    # 0.8f

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->alpha:F

    .line 45
    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    const/16 v2, -0x1e

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 46
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/ToastHelper;)Landroid/view/View;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/ToastHelper;

    .line 16
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->toastView:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$100(Lcom/github/uiautomator/ToastHelper;)Landroid/view/WindowManager;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/ToastHelper;

    .line 16
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->windowManager:Landroid/view/WindowManager;

    return-object v0
.end method

.method public static makeText(Landroid/content/Context;Ljava/lang/String;I)Lcom/github/uiautomator/ToastHelper;
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "text"    # Ljava/lang/String;
    .param p2, "duration"    # I

    .line 50
    new-instance v0, Lcom/github/uiautomator/ToastHelper;

    invoke-direct {v0, p0, p1, p2}, Lcom/github/uiautomator/ToastHelper;-><init>(Landroid/content/Context;Ljava/lang/String;I)V

    return-object v0
.end method


# virtual methods
.method public cancel()V
    .locals 2

    .line 64
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->windowManager:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->toastView:Landroid/view/View;

    invoke-interface {v0, v1}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V

    .line 65
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->timer:Ljava/util/Timer;

    invoke-virtual {v0}, Ljava/util/Timer;->cancel()V

    .line 66
    return-void
.end method

.method public show()V
    .locals 4

    .line 54
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->windowManager:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/github/uiautomator/ToastHelper;->toastView:Landroid/view/View;

    iget-object v2, p0, Lcom/github/uiautomator/ToastHelper;->params:Landroid/view/WindowManager$LayoutParams;

    invoke-interface {v0, v1, v2}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 55
    iget-object v0, p0, Lcom/github/uiautomator/ToastHelper;->timer:Ljava/util/Timer;

    new-instance v1, Lcom/github/uiautomator/ToastHelper$1;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/ToastHelper$1;-><init>(Lcom/github/uiautomator/ToastHelper;)V

    iget v2, p0, Lcom/github/uiautomator/ToastHelper;->duration:I

    int-to-long v2, v2

    invoke-virtual {v0, v1, v2, v3}, Ljava/util/Timer;->schedule(Ljava/util/TimerTask;J)V

    .line 61
    return-void
.end method
