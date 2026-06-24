.class public Lcom/github/uiautomator/util/MemoryManager$Volume;
.super Ljava/lang/Object;
.source "MemoryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/github/uiautomator/util/MemoryManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Volume"
.end annotation


# instance fields
.field protected path:Ljava/lang/String;

.field removable:Z

.field protected state:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 163
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getPath()Ljava/lang/String;
    .locals 1

    .line 169
    iget-object v0, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->path:Ljava/lang/String;

    return-object v0
.end method

.method public getState()Ljava/lang/String;
    .locals 1

    .line 185
    iget-object v0, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->state:Ljava/lang/String;

    return-object v0
.end method

.method public isRemovable()Z
    .locals 1

    .line 177
    iget-boolean v0, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->removable:Z

    return v0
.end method

.method public setPath(Ljava/lang/String;)V
    .locals 0
    .param p1, "path"    # Ljava/lang/String;

    .line 173
    iput-object p1, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->path:Ljava/lang/String;

    .line 174
    return-void
.end method

.method setRemovable(Z)V
    .locals 0
    .param p1, "removable"    # Z

    .line 181
    iput-boolean p1, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->removable:Z

    .line 182
    return-void
.end method

.method public setState(Ljava/lang/String;)V
    .locals 0
    .param p1, "state"    # Ljava/lang/String;

    .line 189
    iput-object p1, p0, Lcom/github/uiautomator/util/MemoryManager$Volume;->state:Ljava/lang/String;

    .line 190
    return-void
.end method
