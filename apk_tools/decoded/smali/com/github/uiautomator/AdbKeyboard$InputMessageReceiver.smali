.class public Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;
.super Landroid/content/BroadcastReceiver;
.source "AdbKeyboard.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/AdbKeyboard;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "InputMessageReceiver"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/github/uiautomator/AdbKeyboard;


# direct methods
.method public constructor <init>(Lcom/github/uiautomator/AdbKeyboard;)V
    .locals 0
    .param p1, "this$0"    # Lcom/github/uiautomator/AdbKeyboard;

    .line 85
    iput-object p1, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method

.method private charSequenceToString(Ljava/lang/CharSequence;)Ljava/lang/String;
    .locals 1
    .param p1, "input"    # Ljava/lang/CharSequence;

    .line 87
    if-nez p1, :cond_0

    const-string v0, ""

    goto :goto_0

    :cond_0
    invoke-interface {p1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0
.end method

.method private getClipboardText(Landroid/content/Context;)Ljava/lang/String;
    .locals 4
    .param p1, "context"    # Landroid/content/Context;

    .line 90
    nop

    .line 91
    const-string v0, "clipboard"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    .line 92
    .local v0, "cm":Landroid/content/ClipboardManager;
    if-nez v0, :cond_0

    .line 93
    const-string v1, "AdbKeyboard"

    const-string v2, "Cannot get an instance of ClipboardManager"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 94
    const/4 v1, 0x0

    return-object v1

    .line 96
    :cond_0
    invoke-virtual {v0}, Landroid/content/ClipboardManager;->hasPrimaryClip()Z

    move-result v1

    const-string v2, ""

    if-nez v1, :cond_1

    .line 97
    return-object v2

    .line 99
    :cond_1
    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getPrimaryClip()Landroid/content/ClipData;

    move-result-object v1

    .line 100
    .local v1, "cd":Landroid/content/ClipData;
    if-eqz v1, :cond_3

    invoke-virtual {v1}, Landroid/content/ClipData;->getItemCount()I

    move-result v3

    if-nez v3, :cond_2

    goto :goto_0

    .line 103
    :cond_2
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/content/ClipData;->getItemAt(I)Landroid/content/ClipData$Item;

    move-result-object v2

    invoke-virtual {v2, p1}, Landroid/content/ClipData$Item;->coerceToText(Landroid/content/Context;)Ljava/lang/CharSequence;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->charSequenceToString(Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v2

    return-object v2

    .line 101
    :cond_3
    :goto_0
    return-object v2
.end method


# virtual methods
.method public handleAction(Landroid/content/Context;Landroid/content/Intent;)Ljava/lang/String;
    .locals 8
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 118
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    .line 121
    .local v0, "action":Ljava/lang/String;
    iget-object v1, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-virtual {v1}, Lcom/github/uiautomator/AdbKeyboard;->getCurrentInputConnection()Landroid/view/inputmethod/InputConnection;

    move-result-object v1

    .line 122
    .local v1, "ic":Landroid/view/inputmethod/InputConnection;
    if-nez v1, :cond_0

    .line 123
    return-object v0

    .line 125
    :cond_0
    invoke-static {v0}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->valueOf(Ljava/lang/String;)Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    move-result-object v2

    .line 126
    .local v2, "keyAction":Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "KeyboardAction received:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "AdbKeyboard"

    invoke-static {v4, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    sget-object v3, Lcom/github/uiautomator/AdbKeyboard$1;->$SwitchMap$com$github$uiautomator$AdbKeyboard$KeyboardAction:[I

    invoke-virtual {v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ordinal()I

    move-result v5

    aget v3, v3, v5

    const-string v5, "code"

    const-string v6, "text"

    const/4 v7, -0x1

    packed-switch v3, :pswitch_data_0

    goto/16 :goto_0

    .line 185
    :pswitch_0
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3}, Lcom/github/uiautomator/AdbKeyboard;->access$500(Lcom/github/uiautomator/AdbKeyboard;)I

    move-result v3

    packed-switch v3, :pswitch_data_1

    .line 195
    const/16 v3, 0x42

    invoke-interface {v1, v3}, Landroid/view/inputmethod/InputConnection;->performEditorAction(I)Z

    .line 196
    const-string v3, "Enter"

    return-object v3

    .line 192
    :pswitch_1
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3}, Lcom/github/uiautomator/AdbKeyboard;->access$500(Lcom/github/uiautomator/AdbKeyboard;)I

    move-result v3

    invoke-interface {v1, v3}, Landroid/view/inputmethod/InputConnection;->performEditorAction(I)Z

    .line 193
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3}, Lcom/github/uiautomator/AdbKeyboard;->access$500(Lcom/github/uiautomator/AdbKeyboard;)I

    move-result v3

    invoke-static {v3}, Lcom/github/uiautomator/AdbKeyboard;->convertActionToString(I)Ljava/lang/String;

    move-result-object v3

    return-object v3

    .line 182
    :pswitch_2
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3, p1}, Lcom/github/uiautomator/AdbKeyboard;->access$400(Lcom/github/uiautomator/AdbKeyboard;Landroid/content/Context;)V

    .line 183
    goto :goto_0

    .line 179
    :pswitch_3
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3, p1}, Lcom/github/uiautomator/AdbKeyboard;->access$300(Lcom/github/uiautomator/AdbKeyboard;Landroid/content/Context;)V

    .line 180
    goto :goto_0

    .line 169
    :pswitch_4
    const-string v3, "Getting current clipboard content"

    invoke-static {v4, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 170
    invoke-direct {p0, p1}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->getClipboardText(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    .line 171
    .local v3, "clipboardContent":Ljava/lang/String;
    if-eqz v3, :cond_1

    .line 174
    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    .line 175
    invoke-virtual {v3, v4}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v4

    const/4 v5, 0x2

    .line 174
    invoke-static {v4, v5}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v4

    return-object v4

    .line 172
    :cond_1
    new-instance v4, Ljava/lang/Exception;

    const-string v5, "clipboard empty"

    invoke-direct {v4, v5}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v4

    .line 163
    .end local v3    # "clipboardContent":Ljava/lang/String;
    :pswitch_5
    invoke-virtual {p2, v5, v7}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v3

    .line 164
    .local v3, "code":I
    if-eq v3, v7, :cond_4

    .line 165
    invoke-interface {v1, v3}, Landroid/view/inputmethod/InputConnection;->performEditorAction(I)Z

    goto :goto_0

    .line 153
    .end local v3    # "code":I
    :pswitch_6
    invoke-virtual {p2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 154
    .local v3, "msgText":Ljava/lang/String;
    if-nez v3, :cond_2

    .line 155
    const-string v3, ""

    .line 157
    :cond_2
    invoke-interface {v1}, Landroid/view/inputmethod/InputConnection;->beginBatchEdit()Z

    .line 158
    iget-object v4, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v4}, Lcom/github/uiautomator/AdbKeyboard;->access$200(Lcom/github/uiautomator/AdbKeyboard;)V

    .line 159
    iget-object v4, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v4, v3}, Lcom/github/uiautomator/AdbKeyboard;->access$100(Lcom/github/uiautomator/AdbKeyboard;Ljava/lang/String;)V

    .line 160
    invoke-interface {v1}, Landroid/view/inputmethod/InputConnection;->endBatchEdit()Z

    .line 161
    goto :goto_0

    .line 150
    .end local v3    # "msgText":Ljava/lang/String;
    :pswitch_7
    iget-object v3, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v3}, Lcom/github/uiautomator/AdbKeyboard;->access$200(Lcom/github/uiautomator/AdbKeyboard;)V

    .line 151
    goto :goto_0

    .line 144
    :pswitch_8
    invoke-virtual {p2, v5, v7}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v3

    .line 145
    .local v3, "code":I
    if-eq v3, v7, :cond_4

    .line 146
    new-instance v4, Landroid/view/KeyEvent;

    const/4 v5, 0x0

    invoke-direct {v4, v5, v3}, Landroid/view/KeyEvent;-><init>(II)V

    invoke-interface {v1, v4}, Landroid/view/inputmethod/InputConnection;->sendKeyEvent(Landroid/view/KeyEvent;)Z

    goto :goto_0

    .line 133
    .end local v3    # "code":I
    :pswitch_9
    invoke-virtual {p2, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 134
    .local v3, "msgText":Ljava/lang/String;
    if-nez v3, :cond_3

    .line 135
    return-object v0

    .line 137
    :cond_3
    iget-object v4, p0, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->this$0:Lcom/github/uiautomator/AdbKeyboard;

    invoke-static {v4, v3}, Lcom/github/uiautomator/AdbKeyboard;->access$100(Lcom/github/uiautomator/AdbKeyboard;Ljava/lang/String;)V

    .line 138
    nop

    .line 199
    .end local v3    # "msgText":Ljava/lang/String;
    :cond_4
    :goto_0
    const/4 v3, 0x0

    return-object v3

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
    .end packed-switch
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 109
    :try_start_0
    invoke-virtual {p0, p1, p2}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->handleAction(Landroid/content/Context;Landroid/content/Intent;)Ljava/lang/String;

    move-result-object v0

    .line 110
    .local v0, "resultData":Ljava/lang/String;
    const/4 v1, -0x1

    invoke-virtual {p0, v1}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->setResultCode(I)V

    .line 111
    invoke-virtual {p0, v0}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->setResultData(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 114
    .end local v0    # "resultData":Ljava/lang/String;
    goto :goto_0

    .line 112
    :catch_0
    move-exception v0

    .line 113
    .local v0, "ex":Ljava/lang/Exception;
    const/4 v1, 0x0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "error:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {p0, v1, v2, v3}, Lcom/github/uiautomator/AdbKeyboard$InputMessageReceiver;->setResult(ILjava/lang/String;Landroid/os/Bundle;)V

    .line 115
    .end local v0    # "ex":Ljava/lang/Exception;
    :goto_0
    return-void
.end method
