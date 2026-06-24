.class public Lcom/github/uiautomator/AdbKeyboard;
.super Landroid/inputmethodservice/InputMethodService;
.source "AdbKeyboard.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;,
        Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;,
        Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "AdbKeyboard"


# instance fields
.field private imeAction:I

.field private inputView:Landroid/inputmethodservice/KeyboardView;

.field private keyboard:Landroid/inputmethodservice/Keyboard;

.field private mReceiver:Landroid/content/BroadcastReceiver;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 27
    invoke-direct {p0}, Landroid/inputmethodservice/InputMethodService;-><init>()V

    .line 29
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->mReceiver:Landroid/content/BroadcastReceiver;

    return-void
.end method

.method static synthetic access$100(Lcom/github/uiautomator/AdbKeyboard;Ljava/lang/String;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;
    .param p1, "x1"    # Ljava/lang/String;

    .line 27
    invoke-direct {p0, p1}, Lcom/github/uiautomator/AdbKeyboard;->inputTextBase64(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$200(Lcom/github/uiautomator/AdbKeyboard;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;

    .line 27
    invoke-direct {p0}, Lcom/github/uiautomator/AdbKeyboard;->clearText()V

    return-void
.end method

.method static synthetic access$300(Lcom/github/uiautomator/AdbKeyboard;Landroid/content/Context;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;
    .param p1, "x1"    # Landroid/content/Context;

    .line 27
    invoke-direct {p0, p1}, Lcom/github/uiautomator/AdbKeyboard;->hideInputMethod(Landroid/content/Context;)V

    return-void
.end method

.method static synthetic access$400(Lcom/github/uiautomator/AdbKeyboard;Landroid/content/Context;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;
    .param p1, "x1"    # Landroid/content/Context;

    .line 27
    invoke-direct {p0, p1}, Lcom/github/uiautomator/AdbKeyboard;->showInputMethod(Landroid/content/Context;)V

    return-void
.end method

.method static synthetic access$500(Lcom/github/uiautomator/AdbKeyboard;)I
    .locals 1
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;

    .line 27
    iget v0, p0, Lcom/github/uiautomator/AdbKeyboard;->imeAction:I

    return v0
.end method

.method static synthetic access$600(Lcom/github/uiautomator/AdbKeyboard;)V
    .locals 0
    .param p0, "x0"    # Lcom/github/uiautomator/AdbKeyboard;

    .line 27
    invoke-direct {p0}, Lcom/github/uiautomator/AdbKeyboard;->changeInputMethod()V

    return-void
.end method

.method private changeInputMethod()V
    .locals 1

    .line 297
    const-string v0, "input_method"

    invoke-virtual {p0, v0}, Lcom/github/uiautomator/AdbKeyboard;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    .line 298
    .local v0, "imm":Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual {v0}, Landroid/view/inputmethod/InputMethodManager;->showInputMethodPicker()V

    .line 299
    return-void
.end method

.method private clearText()V
    .locals 6

    .line 274
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getCurrentInputConnection()Landroid/view/inputmethod/InputConnection;

    move-result-object v0

    .line 275
    .local v0, "ic":Landroid/view/inputmethod/InputConnection;
    new-instance v1, Landroid/view/inputmethod/ExtractedTextRequest;

    invoke-direct {v1}, Landroid/view/inputmethod/ExtractedTextRequest;-><init>()V

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/view/inputmethod/InputConnection;->getExtractedText(Landroid/view/inputmethod/ExtractedTextRequest;I)Landroid/view/inputmethod/ExtractedText;

    move-result-object v1

    iget-object v1, v1, Landroid/view/inputmethod/ExtractedText;->text:Ljava/lang/CharSequence;

    .line 276
    .local v1, "currentText":Ljava/lang/CharSequence;
    invoke-interface {v1}, Ljava/lang/CharSequence;->length()I

    move-result v3

    invoke-interface {v0, v3, v2}, Landroid/view/inputmethod/InputConnection;->getTextBeforeCursor(II)Ljava/lang/CharSequence;

    move-result-object v3

    .line 277
    .local v3, "beforCursorText":Ljava/lang/CharSequence;
    invoke-interface {v1}, Ljava/lang/CharSequence;->length()I

    move-result v4

    invoke-interface {v0, v4, v2}, Landroid/view/inputmethod/InputConnection;->getTextAfterCursor(II)Ljava/lang/CharSequence;

    move-result-object v2

    .line 278
    .local v2, "afterCursorText":Ljava/lang/CharSequence;
    invoke-interface {v3}, Ljava/lang/CharSequence;->length()I

    move-result v4

    invoke-interface {v2}, Ljava/lang/CharSequence;->length()I

    move-result v5

    invoke-interface {v0, v4, v5}, Landroid/view/inputmethod/InputConnection;->deleteSurroundingText(II)Z

    .line 279
    return-void
.end method

.method public static convertActionToString(I)Ljava/lang/String;
    .locals 1
    .param p0, "action"    # I

    .line 323
    packed-switch p0, :pswitch_data_0

    .line 337
    const-string v0, "Enter"

    return-object v0

    .line 335
    :pswitch_0
    const-string v0, "Done"

    return-object v0

    .line 333
    :pswitch_1
    const-string v0, "Next"

    return-object v0

    .line 331
    :pswitch_2
    const-string v0, "Send"

    return-object v0

    .line 329
    :pswitch_3
    const-string v0, "Search"

    return-object v0

    .line 327
    :pswitch_4
    const-string v0, "Go"

    return-object v0

    .line 325
    :pswitch_5
    const-string v0, "None"

    return-object v0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private getText()Ljava/lang/String;
    .locals 4

    .line 282
    const-string v0, ""

    .line 284
    .local v0, "text":Ljava/lang/String;
    :try_start_0
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getCurrentInputConnection()Landroid/view/inputmethod/InputConnection;

    move-result-object v1

    .line 285
    .local v1, "ic":Landroid/view/inputmethod/InputConnection;
    new-instance v2, Landroid/view/inputmethod/ExtractedTextRequest;

    invoke-direct {v2}, Landroid/view/inputmethod/ExtractedTextRequest;-><init>()V

    .line 286
    .local v2, "req":Landroid/view/inputmethod/ExtractedTextRequest;
    const v3, 0x186a0

    iput v3, v2, Landroid/view/inputmethod/ExtractedTextRequest;->hintMaxChars:I

    .line 287
    const/16 v3, 0x2710

    iput v3, v2, Landroid/view/inputmethod/ExtractedTextRequest;->hintMaxLines:I

    .line 288
    const/4 v3, 0x0

    iput v3, v2, Landroid/view/inputmethod/ExtractedTextRequest;->flags:I

    .line 289
    iput v3, v2, Landroid/view/inputmethod/ExtractedTextRequest;->token:I

    .line 290
    invoke-interface {v1, v2, v3}, Landroid/view/inputmethod/InputConnection;->getExtractedText(Landroid/view/inputmethod/ExtractedTextRequest;I)Landroid/view/inputmethod/ExtractedText;

    move-result-object v3

    iget-object v3, v3, Landroid/view/inputmethod/ExtractedText;->text:Ljava/lang/CharSequence;

    invoke-interface {v3}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-object v0, v3

    .line 292
    .end local v1    # "ic":Landroid/view/inputmethod/InputConnection;
    .end local v2    # "req":Landroid/view/inputmethod/ExtractedTextRequest;
    goto :goto_0

    .line 291
    :catchall_0
    move-exception v1

    .line 293
    :goto_0
    return-object v0
.end method

.method private hideInputMethod(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .line 318
    const-string v0, "input_method"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    .line 319
    .local v0, "imm":Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getWindow()Landroid/app/Dialog;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    move-object v2, v1

    check-cast v2, Landroid/view/Window;

    invoke-virtual {v1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    iget-object v1, v1, Landroid/view/WindowManager$LayoutParams;->token:Landroid/os/IBinder;

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromInputMethod(Landroid/os/IBinder;I)V

    .line 320
    return-void
.end method

.method private inputTextBase64(Ljava/lang/String;)V
    .locals 4
    .param p1, "base64text"    # Ljava/lang/String;

    .line 266
    const/4 v0, 0x0

    invoke-static {p1, v0}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v0

    .line 267
    .local v0, "data":[B
    new-instance v1, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 268
    .local v1, "text":Ljava/lang/String;
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getCurrentInputConnection()Landroid/view/inputmethod/InputConnection;

    move-result-object v2

    .line 269
    .local v2, "ic":Landroid/view/inputmethod/InputConnection;
    const/4 v3, 0x1

    invoke-interface {v2, v1, v3}, Landroid/view/inputmethod/InputConnection;->commitText(Ljava/lang/CharSequence;I)Z

    .line 270
    return-void
.end method

.method private setEnterKeyLabel(Ljava/lang/String;)V
    .locals 5
    .param p1, "label"    # Ljava/lang/String;

    .line 214
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->keyboard:Landroid/inputmethodservice/Keyboard;

    invoke-virtual {v0}, Landroid/inputmethodservice/Keyboard;->getKeys()Ljava/util/List;

    move-result-object v0

    .line 215
    .local v0, "keys":Ljava/util/List;, "Ljava/util/List<Landroid/inputmethodservice/Keyboard$Key;>;"
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/inputmethodservice/Keyboard$Key;

    .line 216
    .local v2, "key":Landroid/inputmethodservice/Keyboard$Key;
    iget-object v3, v2, Landroid/inputmethodservice/Keyboard$Key;->codes:[I

    const/4 v4, 0x0

    aget v3, v3, v4

    const/4 v4, -0x8

    if-ne v3, v4, :cond_0

    .line 217
    iput-object p1, v2, Landroid/inputmethodservice/Keyboard$Key;->label:Ljava/lang/CharSequence;

    .line 219
    .end local v2    # "key":Landroid/inputmethodservice/Keyboard$Key;
    :cond_0
    goto :goto_0

    .line 220
    :cond_1
    return-void
.end method

.method private showInputMethod(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .line 313
    const-string v0, "input_method"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    .line 314
    .local v0, "imm":Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getWindow()Landroid/app/Dialog;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    move-object v2, v1

    check-cast v2, Landroid/view/Window;

    invoke-virtual {v1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    iget-object v1, v1, Landroid/view/WindowManager$LayoutParams;->token:Landroid/os/IBinder;

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/inputmethod/InputMethodManager;->showSoftInputFromInputMethod(Landroid/os/IBinder;I)V

    .line 315
    return-void
.end method


# virtual methods
.method public onCreate()V
    .locals 6

    .line 58
    invoke-super {p0}, Landroid/inputmethodservice/InputMethodService;->onCreate()V

    .line 59
    const-string v0, "AdbKeyboard"

    const-string v1, "Input created"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 61
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->mReceiver:Landroid/content/BroadcastReceiver;

    if-nez v0, :cond_1

    .line 62
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 63
    .local v0, "filter":Landroid/content/IntentFilter;
    invoke-static {}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->values()[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 64
    .local v4, "ka":Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    invoke-virtual {v4}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 63
    .end local v4    # "ka":Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 66
    :cond_0
    new-instance v1, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;

    invoke-direct {v1, p0}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;-><init>(Lcom/github/uiautomator/AdbKeyboard;)V

    iput-object v1, p0, Lcom/github/uiautomator/AdbKeyboard;->mReceiver:Landroid/content/BroadcastReceiver;

    .line 67
    invoke-virtual {p0, v1, v0}, Lcom/github/uiautomator/AdbKeyboard;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 69
    .end local v0    # "filter":Landroid/content/IntentFilter;
    :cond_1
    return-void
.end method

.method public onCreateInputView()Landroid/view/View;
    .locals 3

    .line 48
    invoke-virtual {p0}, Lcom/github/uiautomator/AdbKeyboard;->getLayoutInflater()Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0a001e

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/inputmethodservice/KeyboardView;

    iput-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->inputView:Landroid/inputmethodservice/KeyboardView;

    .line 49
    new-instance v0, Landroid/inputmethodservice/Keyboard;

    const/high16 v1, 0x7f0f0000

    invoke-direct {v0, p0, v1}, Landroid/inputmethodservice/Keyboard;-><init>(Landroid/content/Context;I)V

    iput-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->keyboard:Landroid/inputmethodservice/Keyboard;

    .line 50
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard;->inputView:Landroid/inputmethodservice/KeyboardView;

    invoke-virtual {v1, v0}, Landroid/inputmethodservice/KeyboardView;->setKeyboard(Landroid/inputmethodservice/Keyboard;)V

    .line 51
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->inputView:Landroid/inputmethodservice/KeyboardView;

    new-instance v1, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;

    invoke-direct {v1, p0, v2}, Lcom/github/uiautomator/AdbKeyboard$MyKeyboardActionListener;-><init>(Lcom/github/uiautomator/AdbKeyboard;Lcom/github/uiautomator/AdbKeyboard$1;)V

    invoke-virtual {v0, v1}, Landroid/inputmethodservice/KeyboardView;->setOnKeyboardActionListener(Landroid/inputmethodservice/KeyboardView$OnKeyboardActionListener;)V

    .line 53
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->inputView:Landroid/inputmethodservice/KeyboardView;

    return-object v0
.end method

.method public onDestroy()V
    .locals 2

    .line 73
    invoke-super {p0}, Landroid/inputmethodservice/InputMethodService;->onDestroy()V

    .line 74
    const-string v0, "AdbKeyboard"

    const-string v1, "Input destroyed"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 75
    iget-object v0, p0, Lcom/github/uiautomator/AdbKeyboard;->mReceiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    .line 76
    invoke-virtual {p0, v0}, Lcom/github/uiautomator/AdbKeyboard;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 78
    :cond_0
    return-void
.end method

.method public onEvaluateFullscreenMode()Z
    .locals 1

    .line 82
    const/4 v0, 0x0

    return v0
.end method

.method public onStartInputView(Landroid/view/inputmethod/EditorInfo;Z)V
    .locals 3
    .param p1, "attribute"    # Landroid/view/inputmethod/EditorInfo;
    .param p2, "restarting"    # Z

    .line 205
    invoke-super {p0, p1, p2}, Landroid/inputmethodservice/InputMethodService;->onStartInput(Landroid/view/inputmethod/EditorInfo;Z)V

    .line 206
    iget v0, p1, Landroid/view/inputmethod/EditorInfo;->imeOptions:I

    and-int/lit16 v0, v0, 0xff

    iput v0, p0, Lcom/github/uiautomator/AdbKeyboard;->imeAction:I

    .line 207
    invoke-static {v0}, Lcom/github/uiautomator/AdbKeyboard;->convertActionToString(I)Ljava/lang/String;

    move-result-object v0

    .line 208
    .local v0, "actionName":Ljava/lang/String;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "imeAction: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/github/uiautomator/AdbKeyboard;->imeAction:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "AdbKeyboard"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 209
    invoke-direct {p0, v0}, Lcom/github/uiautomator/AdbKeyboard;->setEnterKeyLabel(Ljava/lang/String;)V

    .line 210
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard;->inputView:Landroid/inputmethodservice/KeyboardView;

    invoke-virtual {v1}, Landroid/inputmethodservice/KeyboardView;->invalidateAllKeys()V

    .line 211
    return-void
.end method

.method public randomString(I)Ljava/lang/String;
    .locals 6
    .param p1, "length"    # I

    .line 302
    const-string v0, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    .line 303
    .local v0, "str":Ljava/lang/String;
    new-instance v1, Ljava/util/Random;

    invoke-direct {v1}, Ljava/util/Random;-><init>()V

    .line 304
    .local v1, "random":Ljava/util/Random;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 305
    .local v2, "buf":Ljava/lang/StringBuilder;
    const/4 v3, 0x0

    .local v3, "i":I
    :goto_0
    if-ge v3, p1, :cond_0

    .line 306
    const/16 v4, 0x3e

    invoke-virtual {v1, v4}, Ljava/util/Random;->nextInt(I)I

    move-result v4

    .line 307
    .local v4, "num":I
    invoke-virtual {v0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 305
    .end local v4    # "num":I
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 309
    .end local v3    # "i":I
    :cond_0
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    return-object v3
.end method
