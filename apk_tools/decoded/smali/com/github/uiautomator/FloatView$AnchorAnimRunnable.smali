.class Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;
.super Ljava/lang/Object;
.source "FloatView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/FloatView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "AnchorAnimRunnable"
.end annotation


# instance fields
.field private animTime:I

.field private currentStartTime:J

.field private interpolator:Landroid/view/animation/Interpolator;

.field private startX:I

.field private startY:I

.field final synthetic this$0:Lcom/github/uiautomator/FloatView;

.field private xDistance:I

.field private yDistance:I


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/FloatView;IIIJ)V
    .locals 1
    .param p2, "animTime"    # I
    .param p3, "xDistance"    # I
    .param p4, "yDistance"    # I
    .param p5, "currentStartTime"    # J

    .line 221
    iput-object p1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 222
    iput p2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->animTime:I

    .line 223
    iput-wide p5, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->currentStartTime:J

    .line 224
    new-instance v0, Landroid/view/animation/AccelerateDecelerateInterpolator;

    invoke-direct {v0}, Landroid/view/animation/AccelerateDecelerateInterpolator;-><init>()V

    iput-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->interpolator:Landroid/view/animation/Interpolator;

    .line 225
    iput p3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->xDistance:I

    .line 226
    iput p4, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->yDistance:I

    .line 227
    invoke-static {p1}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    iput v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startX:I

    .line 228
    invoke-static {p1}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object p1

    iget p1, p1, Landroid/view/WindowManager$LayoutParams;->y:I

    iput p1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startY:I

    .line 229
    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    .line 233
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->currentStartTime:J

    iget v4, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->animTime:I

    int-to-long v4, v4

    add-long/2addr v2, v4

    cmp-long v4, v0, v2

    if-ltz v4, :cond_2

    .line 234
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v0}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    iget v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startX:I

    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->xDistance:I

    add-int/2addr v1, v2

    if-ne v0, v1, :cond_0

    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v0}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    iget v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startY:I

    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->yDistance:I

    add-int/2addr v1, v2

    if-eq v0, v1, :cond_1

    .line 235
    :cond_0
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v0}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startX:I

    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->xDistance:I

    add-int/2addr v1, v2

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 236
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v0}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startY:I

    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->yDistance:I

    add-int/2addr v1, v2

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 237
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v0}, Lcom/github/uiautomator/FloatView;->access$100(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager;

    move-result-object v0

    iget-object v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v1}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 239
    :cond_1
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/github/uiautomator/FloatView;->access$202(Lcom/github/uiautomator/FloatView;Z)Z

    .line 240
    return-void

    .line 242
    :cond_2
    iget-object v0, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->interpolator:Landroid/view/animation/Interpolator;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    iget-wide v3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->currentStartTime:J

    sub-long/2addr v1, v3

    long-to-float v1, v1

    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->animTime:I

    int-to-float v2, v2

    div-float/2addr v1, v2

    invoke-interface {v0, v1}, Landroid/view/animation/Interpolator;->getInterpolation(F)F

    move-result v0

    .line 243
    .local v0, "delta":F
    iget v1, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->xDistance:I

    int-to-float v1, v1

    mul-float v1, v1, v0

    float-to-int v1, v1

    .line 244
    .local v1, "xMoveDistance":I
    iget v2, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->yDistance:I

    int-to-float v2, v2

    mul-float v2, v2, v0

    float-to-int v2, v2

    .line 245
    .local v2, "yMoveDistance":I
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "delta:  "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v4, "  xMoveDistance  "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, "   yMoveDistance  "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "FloatView"

    invoke-static {v4, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 246
    iget-object v3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v3}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v3

    iget v4, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startX:I

    add-int/2addr v4, v1

    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 247
    iget-object v3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v3}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v3

    iget v4, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->startY:I

    add-int/2addr v4, v2

    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 248
    iget-object v3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v3}, Lcom/github/uiautomator/FloatView;->access$100(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager;

    move-result-object v3

    iget-object v4, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    invoke-static {v4}, Lcom/github/uiautomator/FloatView;->access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;

    move-result-object v5

    invoke-interface {v3, v4, v5}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 249
    iget-object v3, p0, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;->this$0:Lcom/github/uiautomator/FloatView;

    const-wide/16 v4, 0x10

    invoke-virtual {v3, p0, v4, v5}, Lcom/github/uiautomator/FloatView;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 250
    return-void
.end method
