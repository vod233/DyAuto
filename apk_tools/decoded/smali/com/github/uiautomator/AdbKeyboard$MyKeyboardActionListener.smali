.class Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;
.super Ljava/lang/Object;
.source "AdbKeyboard.java"

# interfaces
.implements Landroid/inputmethodservice/KeyboardView$OnKeyboardActionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/AdbKeyboard;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MyKeyboardActionListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/AdbKeyboard;


# direct methods
.method private constructor <init>(Lcom/github/uiautomator/AdbKeyboard;)V
    .locals 0

    .line 223
    iput-object p1, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/github/uiautomator/AdbKeyboard;Lcom/github/uiautomator/AdbKeyboard$1;)V
    .locals 0
    .param p1, "x0"    # Lcom/github/uiautomator/AdbKeyboard;
    .param p2, "x1"    # Lcom/github/uiautomator/AdbKeyboard$1;

    .line 223
    invoke-direct {p0, p1}, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;-><init>(Lcom/github/uiautomator/AdbKeyboard;)V

    return-void
.end method


# virtual methods
.method public onKey(I[I)V
    .locals 4
    .param p1, "primaryCode"    # I
    .param p2, "keyCodes"    # [I

    .line 232
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-virtual {v0}, Lcom/github/uiautomator/AdbKeyboard;->getCurrentInputConnection()Landroid/view/inputmethod/InputConnection;

    move-result-object v0

    .line 233
    .local v0, "ic":Landroid/view/inputmethod/InputConnection;
    const-string v1, "AdbKeyboard"

    const/4 v2, -0x3

    if-ne p1, v2, :cond_0

    .line 234
    const-string v2, "Keyboard CANCEL not implemented"

    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 235
    :cond_0
    const/16 v2, -0xa

    if-ne p1, v2, :cond_1

    .line 236
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v1}, Lcom/github/uiautomator/AdbKeyboard;->access$200(Lcom/github/uiautomator/AdbKeyboard;)V

    goto :goto_0

    .line 237
    :cond_1
    const/4 v2, -0x5

    if-ne p1, v2, :cond_2

    .line 238
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v1}, Lcom/github/uiautomator/AdbKeyboard;->access$600(Lcom/github/uiautomator/AdbKeyboard;)V

    goto :goto_0

    .line 240
    :cond_2
    const/4 v2, -0x7

    if-ne p1, v2, :cond_3

    .line 241
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Lcom/github/uiautomator/AdbKeyboard;->randomString(I)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, v2}, Landroid/view/inputmethod/InputConnection;->commitText(Ljava/lang/CharSequence;I)Z

    goto :goto_0

    .line 242
    :cond_3
    const/4 v2, -0x8

    if-ne p1, v2, :cond_4

    .line 243
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v1}, Lcom/github/uiautomator/AdbKeyboard;->access$500(Lcom/github/uiautomator/AdbKeyboard;)I

    move-result v1

    invoke-interface {v0, v1}, Landroid/view/inputmethod/InputConnection;->performEditorAction(I)Z

    goto :goto_0

    .line 245
    :cond_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unknown primaryCode "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 247
    :goto_0
    return-void
.end method

.method public onPress(I)V
    .locals 0
    .param p1, "i"    # I

    .line 225
    return-void
.end method

.method public onRelease(I)V
    .locals 0
    .param p1, "i"    # I

    .line 228
    return-void
.end method

.method public onText(Ljava/lang/CharSequence;)V
    .locals 0
    .param p1, "charSequence"    # Ljava/lang/CharSequence;

    .line 250
    return-void
.end method

.method public swipeDown()V
    .locals 0

    .line 259
    return-void
.end method

.method public swipeLeft()V
    .locals 0

    .line 253
    return-void
.end method

.method public swipeRight()V
    .locals 0

    .line 256
    return-void
.end method

.method public swipeUp()V
    .locals 0

    .line 262
    return-void
.end method
