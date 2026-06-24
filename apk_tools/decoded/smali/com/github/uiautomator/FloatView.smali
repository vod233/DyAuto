.class public Lcom/github/uiautomator/FloatView;
.super Landroid/widget/FrameLayout;
.source "FloatView.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "FloatView"


# instance fields
.field private context:Landroid/content/Context;

.field private isAnchoring:Z

.field private isShowing:Z

.field private mParams:Landroid/view/WindowManager$LayoutParams;

.field private windowManager:Landroid/view/WindowManager;

.field private xDownInScreen:F

.field private xInScreen:F

.field private xInView:F

.field private yDownInScreen:F

.field private yInScreen:F

.field private yInView:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 5
    .param p1, "context"    # Landroid/content/Context;

    .line 59
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 52
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/github/uiautomator/FloatView;->isAnchoring:Z

    .line 53
    iput-boolean v0, p0, Lcom/github/uiautomator/FloatView;->isShowing:Z

    .line 54
    const/4 v1, 0x0

    iput-object v1, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    .line 55
    iput-object v1, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    .line 60
    iput-object p1, p0, Lcom/github/uiautomator/FloatView;->context:Landroid/content/Context;

    .line 62
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "window"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    iput-object v1, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    .line 63
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v1

    .line 64
    .local v1, "inflater":Landroid/view/LayoutInflater;
    new-instance v2, Landroid/widget/ImageView;

    iget-object v3, p0, Lcom/github/uiautomator/FloatView;->context:Landroid/content/Context;

    invoke-direct {v2, v3}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 65
    .local v2, "imageView":Landroid/widget/ImageView;
    const v3, 0x7f060063

    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 66
    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    invoke-virtual {v2}, Landroid/widget/ImageView;->getWidth()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v0

    invoke-virtual {v2}, Landroid/widget/ImageView;->getHeight()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const/4 v4, 0x1

    aput-object v0, v3, v4

    const-string v0, "imageView size: %dx%d"

    invoke-static {v0, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v3, "FloatView"

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 67
    invoke-virtual {p0, v2}, Lcom/github/uiautomator/FloatView;->addView(Landroid/view/View;)V

    .line 68
    return-void
.end method

.method static synthetic access$000(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager$LayoutParams;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/FloatView;

    .line 20
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    return-object v0
.end method

.method static synthetic access$100(Lcom/github/uiautomator/FloatView;)Landroid/view/WindowManager;
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/FloatView;

    .line 20
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    return-object v0
.end method

.method static synthetic access$202(Lcom/github/uiautomator/FloatView;Z)Z
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/FloatView;
    .param p1, "x1"    # Z

    .line 20
    iput-boolean p1, p0, Lcom/github/uiautomator/FloatView;->isAnchoring:Z

    return p1
.end method

.method private anchorToSide()V
    .locals 19

    .line 168
    move-object/from16 v7, p0

    const/4 v0, 0x1

    iput-boolean v0, v7, Lcom/github/uiautomator/FloatView;->isAnchoring:Z

    .line 169
    new-instance v0, Landroid/graphics/Point;

    invoke-direct {v0}, Landroid/graphics/Point;-><init>()V

    move-object v8, v0

    .line 170
    .local v8, "size":Landroid/graphics/Point;
    iget-object v0, v7, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    invoke-virtual {v0, v8}, Landroid/view/Display;->getSize(Landroid/graphics/Point;)V

    .line 171
    iget v9, v8, Landroid/graphics/Point;->x:I

    .line 172
    .local v9, "screenWidth":I
    iget v10, v8, Landroid/graphics/Point;->y:I

    .line 173
    .local v10, "screenHeight":I
    iget-object v0, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getWidth()I

    move-result v1

    div-int/lit8 v1, v1, 0x2

    add-int v11, v0, v1

    .line 175
    .local v11, "middleX":I
    const/4 v0, 0x0

    .line 176
    .local v0, "animTime":I
    const/4 v1, 0x0

    .line 177
    .local v1, "xDistance":I
    const/4 v2, 0x0

    .line 179
    .local v2, "yDistance":I
    invoke-direct/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->sideGap()I

    move-result v12

    .line 181
    .local v12, "gap":I
    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getWidth()I

    move-result v3

    div-int/lit8 v3, v3, 0x2

    add-int/2addr v3, v12

    if-gt v11, v3, :cond_0

    .line 182
    iget-object v3, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v3, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    sub-int v1, v12, v3

    move v13, v1

    goto :goto_0

    .line 183
    :cond_0
    div-int/lit8 v3, v9, 0x2

    if-gt v11, v3, :cond_1

    .line 184
    iget-object v3, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v3, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    sub-int v1, v12, v3

    move v13, v1

    goto :goto_0

    .line 185
    :cond_1
    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getWidth()I

    move-result v3

    div-int/lit8 v3, v3, 0x2

    sub-int v3, v9, v3

    sub-int/2addr v3, v12

    if-lt v11, v3, :cond_2

    .line 186
    iget-object v3, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v3, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    sub-int v3, v9, v3

    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getWidth()I

    move-result v4

    sub-int/2addr v3, v4

    sub-int v1, v3, v12

    move v13, v1

    goto :goto_0

    .line 188
    :cond_2
    iget-object v3, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v3, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    sub-int v3, v9, v3

    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getWidth()I

    move-result v4

    sub-int/2addr v3, v4

    sub-int v1, v3, v12

    move v13, v1

    .line 192
    .end local v1    # "xDistance":I
    .local v13, "xDistance":I
    :goto_0
    iget-object v1, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    if-ge v1, v12, :cond_3

    .line 193
    iget-object v1, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    sub-int v2, v12, v1

    move v14, v2

    goto :goto_1

    .line 196
    :cond_3
    iget-object v1, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getHeight()I

    move-result v3

    add-int/2addr v1, v3

    add-int/2addr v1, v12

    if-lt v1, v10, :cond_4

    .line 197
    sub-int v1, v10, v12

    iget-object v3, v7, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v3, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    sub-int/2addr v1, v3

    invoke-virtual/range {p0 .. p0}, Lcom/github/uiautomator/FloatView;->getHeight()I

    move-result v3

    sub-int v2, v1, v3

    move v14, v2

    goto :goto_1

    .line 196
    :cond_4
    move v14, v2

    .line 199
    .end local v2    # "yDistance":I
    .local v14, "yDistance":I
    :goto_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "xDistance  "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "   yDistance"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v14}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "FloatView"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    invoke-static {v13}, Ljava/lang/Math;->abs(I)I

    move-result v1

    invoke-static {v14}, Ljava/lang/Math;->abs(I)I

    move-result v2

    if-le v1, v2, :cond_5

    int-to-float v1, v13

    int-to-float v2, v9

    div-float/2addr v1, v2

    const/high16 v2, 0x44160000    # 600.0f

    mul-float v1, v1, v2

    float-to-int v1, v1

    goto :goto_2

    .line 202
    :cond_5
    int-to-float v1, v14

    int-to-float v2, v10

    div-float/2addr v1, v2

    const/high16 v2, 0x44610000    # 900.0f

    mul-float v1, v1, v2

    float-to-int v1, v1

    :goto_2
    move v15, v1

    .line 203
    .end local v0    # "animTime":I
    .local v15, "animTime":I
    new-instance v5, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;

    invoke-static {v15}, Ljava/lang/Math;->abs(I)I

    move-result v2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v16

    move-object v0, v5

    move-object/from16 v1, p0

    move v3, v13

    move v4, v14

    move-object/from16 v18, v8

    move-object v8, v5

    .end local v8    # "size":Landroid/graphics/Point;
    .local v18, "size":Landroid/graphics/Point;
    move-wide/from16 v5, v16

    invoke-direct/range {v0 .. v6}, Lcom/github/uiautomator/FloatView$AnchorAnimRunnable;-><init>(Lcom/github/uiautomator/FloatView;IIIJ)V

    invoke-virtual {v7, v8}, Lcom/github/uiautomator/FloatView;->post(Ljava/lang/Runnable;)Z

    .line 204
    return-void
.end method

.method private dp2px(Landroid/content/Context;F)I
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "dp"    # F

    .line 119
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    .line 120
    .local v0, "scale":F
    mul-float v1, p2, v0

    const/high16 v2, 0x3f000000    # 0.5f

    add-float/2addr v1, v2

    float-to-int v1, v1

    return v1
.end method

.method private sideGap()I
    .locals 1

    .line 164
    const/high16 v0, 0x40a00000    # 5.0f

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/FloatView;->dp2px(F)I

    move-result v0

    return v0
.end method

.method private updateViewPosition()V
    .locals 3

    .line 255
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, p0, Lcom/github/uiautomator/FloatView;->xInScreen:F

    iget v2, p0, Lcom/github/uiautomator/FloatView;->xInView:F

    sub-float/2addr v1, v2

    float-to-int v1, v1

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 256
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, p0, Lcom/github/uiautomator/FloatView;->yInScreen:F

    iget v2, p0, Lcom/github/uiautomator/FloatView;->yInView:F

    sub-float/2addr v1, v2

    float-to-int v1, v1

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 257
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "x  "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, v1, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "   y  "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    iget v1, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FloatView"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 258
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    invoke-interface {v0, p0, v1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 259
    return-void
.end method


# virtual methods
.method public dp2px(F)I
    .locals 3
    .param p1, "dp"    # F

    .line 207
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    .line 208
    .local v0, "scale":F
    mul-float v1, p1, v0

    const/high16 v2, 0x3f000000    # 0.5f

    add-float/2addr v1, v2

    float-to-int v1, v1

    return v1
.end method

.method public hide()V
    .locals 1

    .line 113
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->isShown()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 114
    iget-object v0, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v0, p0}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V

    .line 116
    :cond_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4
    .param p1, "event"    # Landroid/view/MotionEvent;

    .line 129
    iget-boolean v0, p0, Lcom/github/uiautomator/FloatView;->isAnchoring:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    .line 130
    return v1

    .line 132
    :cond_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    .line 142
    :pswitch_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->xInScreen:F

    .line 143
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->yInScreen:F

    .line 145
    invoke-direct {p0}, Lcom/github/uiautomator/FloatView;->updateViewPosition()V

    .line 146
    goto :goto_0

    .line 148
    :pswitch_1
    iget v0, p0, Lcom/github/uiautomator/FloatView;->xDownInScreen:F

    iget v2, p0, Lcom/github/uiautomator/FloatView;->xInScreen:F

    sub-float/2addr v0, v2

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v2

    int-to-float v2, v2

    cmpg-float v0, v0, v2

    if-gtz v0, :cond_1

    iget v0, p0, Lcom/github/uiautomator/FloatView;->yDownInScreen:F

    iget v2, p0, Lcom/github/uiautomator/FloatView;->yInScreen:F

    sub-float/2addr v0, v2

    .line 149
    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v2

    int-to-float v2, v2

    cmpg-float v0, v0, v2

    if-gtz v0, :cond_1

    .line 151
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v2, 0x0

    const-string v3, "this float window is clicked"

    invoke-static {v0, v3, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 154
    :cond_1
    invoke-direct {p0}, Lcom/github/uiautomator/FloatView;->anchorToSide()V

    .line 156
    goto :goto_0

    .line 134
    :pswitch_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->xInView:F

    .line 135
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->yInView:F

    .line 136
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->xDownInScreen:F

    .line 137
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->yDownInScreen:F

    .line 138
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->xInScreen:F

    .line 139
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v0

    iput v0, p0, Lcom/github/uiautomator/FloatView;->yInScreen:F

    .line 140
    nop

    .line 160
    :goto_0
    return v1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public setParams(Landroid/view/WindowManager$LayoutParams;)V
    .locals 0
    .param p1, "params"    # Landroid/view/WindowManager$LayoutParams;

    .line 124
    iput-object p1, p0, Lcom/github/uiautomator/FloatView;->mParams:Landroid/view/WindowManager$LayoutParams;

    .line 125
    return-void
.end method

.method public show()V
    .locals 8

    .line 71
    invoke-virtual {p0}, Lcom/github/uiautomator/FloatView;->isShown()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 72
    const-string v0, "FloatView"

    const-string v1, "already shown"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 73
    return-void

    .line 75
    :cond_0
    new-instance v0, Landroid/graphics/Point;

    invoke-direct {v0}, Landroid/graphics/Point;-><init>()V

    .line 76
    .local v0, "size":Landroid/graphics/Point;
    iget-object v1, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/Display;->getSize(Landroid/graphics/Point;)V

    .line 77
    iget v1, v0, Landroid/graphics/Point;->x:I

    .line 78
    .local v1, "screenWidth":I
    iget v2, v0, Landroid/graphics/Point;->y:I

    .line 79
    .local v2, "screenHeight":I
    iget v3, v0, Landroid/graphics/Point;->x:I

    iget v4, v0, Landroid/graphics/Point;->y:I

    if-le v3, v4, :cond_1

    iget v3, v0, Landroid/graphics/Point;->y:I

    goto :goto_0

    :cond_1
    iget v3, v0, Landroid/graphics/Point;->x:I

    .line 81
    .local v3, "minWidthHeight":I
    :goto_0
    new-instance v4, Landroid/view/WindowManager$LayoutParams;

    invoke-direct {v4}, Landroid/view/WindowManager$LayoutParams;-><init>()V

    .line 82
    .local v4, "params":Landroid/view/WindowManager$LayoutParams;
    iget-object v5, p0, Lcom/github/uiautomator/FloatView;->context:Landroid/content/Context;

    invoke-virtual {v5}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v4, Landroid/view/WindowManager$LayoutParams;->packageName:Ljava/lang/String;

    .line 83
    const/4 v5, -0x2

    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 84
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->height:I

    .line 85
    const v5, 0x101a8

    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->flags:I

    .line 91
    iget v5, v4, Landroid/view/WindowManager$LayoutParams;->flags:I

    or-int/lit8 v5, v5, 0x10

    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->flags:I

    .line 92
    iget v5, v4, Landroid/view/WindowManager$LayoutParams;->flags:I

    and-int/lit8 v5, v5, -0x21

    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->flags:I

    .line 95
    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v6, 0x1a

    if-lt v5, v6, :cond_2

    .line 96
    const/16 v5, 0x7f6

    .local v5, "mType":I
    goto :goto_1

    .line 98
    .end local v5    # "mType":I
    :cond_2
    const/16 v5, 0x7da

    .line 100
    .restart local v5    # "mType":I
    :goto_1
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->type:I

    .line 101
    const/4 v6, 0x1

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->format:I

    .line 102
    const/16 v6, 0x33

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 103
    div-int/lit8 v6, v3, 0x14

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 104
    div-int/lit8 v6, v3, 0x14

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->height:I

    .line 105
    invoke-direct {p0}, Lcom/github/uiautomator/FloatView;->sideGap()I

    move-result v6

    sub-int v6, v1, v6

    iget v7, v4, Landroid/view/WindowManager$LayoutParams;->width:I

    sub-int/2addr v6, v7

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 106
    div-int/lit8 v6, v2, 0x3

    mul-int/lit8 v6, v6, 0x2

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 107
    const v6, 0x3e4ccccd    # 0.2f

    iput v6, v4, Landroid/view/WindowManager$LayoutParams;->alpha:F

    .line 108
    invoke-virtual {p0, v4}, Lcom/github/uiautomator/FloatView;->setParams(Landroid/view/WindowManager$LayoutParams;)V

    .line 109
    iget-object v6, p0, Lcom/github/uiautomator/FloatView;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v6, p0, v4}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 110
    return-void
.end method
