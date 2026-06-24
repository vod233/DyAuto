.class public final enum Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
.super Ljava/lang/Enum;
.source "AdbKeyboard.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/AdbKeyboard;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "KeyboardAction"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_CLEAR_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_EDITOR_CODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_GET_CLIPBOARD:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_HIDE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_INPUT_KEYCODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_INPUT_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_SET_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_SHOW:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

.field public static final enum ADB_KEYBOARD_SMART_ENTER:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;


# direct methods
.method private static synthetic $values()[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    .locals 3

    .line 34
    const/16 v0, 0x9

    new-array v0, v0, [Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SMART_ENTER:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_INPUT_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_CLEAR_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SET_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x3

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_INPUT_KEYCODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x4

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_EDITOR_CODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x5

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_GET_CLIPBOARD:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x6

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_HIDE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/4 v2, 0x7

    aput-object v1, v0, v2

    sget-object v1, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SHOW:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const/16 v2, 0x8

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 35
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_SMART_ENTER"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SMART_ENTER:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 36
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_INPUT_TEXT"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_INPUT_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 37
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_CLEAR_TEXT"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_CLEAR_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 38
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_SET_TEXT"

    const/4 v2, 0x3

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SET_TEXT:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 39
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_INPUT_KEYCODE"

    const/4 v2, 0x4

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_INPUT_KEYCODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 40
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_EDITOR_CODE"

    const/4 v2, 0x5

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_EDITOR_CODE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 41
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_GET_CLIPBOARD"

    const/4 v2, 0x6

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_GET_CLIPBOARD:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 42
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_HIDE"

    const/4 v2, 0x7

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_HIDE:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 43
    new-instance v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    const-string v1, "ADB_KEYBOARD_SHOW"

    const/16 v2, 0x8

    invoke-direct {v0, v1, v2}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->ADB_KEYBOARD_SHOW:Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    .line 34
    invoke-static {}, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->$values()[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    move-result-object v0

    sput-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->$VALUES:[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 34
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    .locals 1
    .param p0, "name"    # Ljava/lang/String;

    .line 34
    const-class v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    return-object v0
.end method

.method public static values()[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;
    .locals 1

    .line 34
    sget-object v0, Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->$VALUES:[Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    invoke-virtual {v0}, [Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/github/uiautomator/AdbKeyboard$KeyboardAction;

    return-object v0
.end method
