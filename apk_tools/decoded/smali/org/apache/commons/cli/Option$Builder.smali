.class public final Lorg/apache/commons/cli/Option$Builder;
.super Ljava/lang/Object;
.source "Option.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/apache/commons/cli/Option;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation


# instance fields
.field private argName:Ljava/lang/String;

.field private description:Ljava/lang/String;

.field private longOpt:Ljava/lang/String;

.field private numberOfArgs:I

.field private final opt:Ljava/lang/String;

.field private optionalArg:Z

.field private required:Z

.field private type:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private valuesep:C


# direct methods
.method private constructor <init>(Ljava/lang/String;)V
    .locals 1
    .param p1, "opt"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 820
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 804
    const/4 v0, -0x1

    iput v0, p0, Lorg/apache/commons/cli/Option$Builder;->numberOfArgs:I

    .line 807
    const-class v0, Ljava/lang/String;

    iput-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->type:Ljava/lang/Class;

    .line 821
    invoke-static {p1}, Lorg/apache/commons/cli/OptionValidator;->validateOption(Ljava/lang/String;)V

    .line 822
    iput-object p1, p0, Lorg/apache/commons/cli/Option$Builder;->opt:Ljava/lang/String;

    .line 823
    return-void
.end method

.method synthetic constructor <init>(Ljava/lang/String;Lorg/apache/commons/cli/Option$1;)V
    .locals 0
    .param p1, "x0"    # Ljava/lang/String;
    .param p2, "x1"    # Lorg/apache/commons/cli/Option$1;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 783
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/Option$Builder;-><init>(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$000(Lorg/apache/commons/cli/Option$Builder;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->argName:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$100(Lorg/apache/commons/cli/Option$Builder;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->description:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$200(Lorg/apache/commons/cli/Option$Builder;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->longOpt:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$300(Lorg/apache/commons/cli/Option$Builder;)I
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget v0, p0, Lorg/apache/commons/cli/Option$Builder;->numberOfArgs:I

    return v0
.end method

.method static synthetic access$400(Lorg/apache/commons/cli/Option$Builder;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->opt:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$500(Lorg/apache/commons/cli/Option$Builder;)Z
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-boolean v0, p0, Lorg/apache/commons/cli/Option$Builder;->optionalArg:Z

    return v0
.end method

.method static synthetic access$600(Lorg/apache/commons/cli/Option$Builder;)Z
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-boolean v0, p0, Lorg/apache/commons/cli/Option$Builder;->required:Z

    return v0
.end method

.method static synthetic access$700(Lorg/apache/commons/cli/Option$Builder;)Ljava/lang/Class;
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->type:Ljava/lang/Class;

    return-object v0
.end method

.method static synthetic access$800(Lorg/apache/commons/cli/Option$Builder;)C
    .locals 1
    .param p0, "x0"    # Lorg/apache/commons/cli/Option$Builder;

    .line 783
    iget-char v0, p0, Lorg/apache/commons/cli/Option$Builder;->valuesep:C

    return v0
.end method


# virtual methods
.method public argName(Ljava/lang/String;)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "argName"    # Ljava/lang/String;

    .line 833
    iput-object p1, p0, Lorg/apache/commons/cli/Option$Builder;->argName:Ljava/lang/String;

    .line 834
    return-object p0
.end method

.method public build()Lorg/apache/commons/cli/Option;
    .locals 2

    .line 999
    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->opt:Ljava/lang/String;

    if-nez v0, :cond_1

    iget-object v0, p0, Lorg/apache/commons/cli/Option$Builder;->longOpt:Ljava/lang/String;

    if-eqz v0, :cond_0

    goto :goto_0

    .line 1001
    :cond_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "Either opt or longOpt must be specified"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1003
    :cond_1
    :goto_0
    new-instance v0, Lorg/apache/commons/cli/Option;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lorg/apache/commons/cli/Option;-><init>(Lorg/apache/commons/cli/Option$Builder;Lorg/apache/commons/cli/Option$1;)V

    return-object v0
.end method

.method public desc(Ljava/lang/String;)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "description"    # Ljava/lang/String;

    .line 845
    iput-object p1, p0, Lorg/apache/commons/cli/Option$Builder;->description:Ljava/lang/String;

    .line 846
    return-object p0
.end method

.method public hasArg()Lorg/apache/commons/cli/Option$Builder;
    .locals 1

    .line 964
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/apache/commons/cli/Option$Builder;->hasArg(Z)Lorg/apache/commons/cli/Option$Builder;

    move-result-object v0

    return-object v0
.end method

.method public hasArg(Z)Lorg/apache/commons/cli/Option$Builder;
    .locals 1
    .param p1, "hasArg"    # Z

    .line 976
    if-eqz p1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, -0x1

    :goto_0
    iput v0, p0, Lorg/apache/commons/cli/Option$Builder;->numberOfArgs:I

    .line 977
    return-object p0
.end method

.method public hasArgs()Lorg/apache/commons/cli/Option$Builder;
    .locals 1

    .line 987
    const/4 v0, -0x2

    iput v0, p0, Lorg/apache/commons/cli/Option$Builder;->numberOfArgs:I

    .line 988
    return-object p0
.end method

.method public longOpt(Ljava/lang/String;)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "longOpt"    # Ljava/lang/String;

    .line 857
    iput-object p1, p0, Lorg/apache/commons/cli/Option$Builder;->longOpt:Ljava/lang/String;

    .line 858
    return-object p0
.end method

.method public numberOfArgs(I)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "numberOfArgs"    # I

    .line 869
    iput p1, p0, Lorg/apache/commons/cli/Option$Builder;->numberOfArgs:I

    .line 870
    return-object p0
.end method

.method public optionalArg(Z)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "isOptional"    # Z

    .line 882
    iput-boolean p1, p0, Lorg/apache/commons/cli/Option$Builder;->optionalArg:Z

    .line 883
    return-object p0
.end method

.method public required()Lorg/apache/commons/cli/Option$Builder;
    .locals 1

    .line 893
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/apache/commons/cli/Option$Builder;->required(Z)Lorg/apache/commons/cli/Option$Builder;

    move-result-object v0

    return-object v0
.end method

.method public required(Z)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "required"    # Z

    .line 904
    iput-boolean p1, p0, Lorg/apache/commons/cli/Option$Builder;->required:Z

    .line 905
    return-object p0
.end method

.method public type(Ljava/lang/Class;)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Lorg/apache/commons/cli/Option$Builder;"
        }
    .end annotation

    .line 916
    .local p1, "type":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    iput-object p1, p0, Lorg/apache/commons/cli/Option$Builder;->type:Ljava/lang/Class;

    .line 917
    return-object p0
.end method

.method public valueSeparator()Lorg/apache/commons/cli/Option$Builder;
    .locals 1

    .line 927
    const/16 v0, 0x3d

    invoke-virtual {p0, v0}, Lorg/apache/commons/cli/Option$Builder;->valueSeparator(C)Lorg/apache/commons/cli/Option$Builder;

    move-result-object v0

    return-object v0
.end method

.method public valueSeparator(C)Lorg/apache/commons/cli/Option$Builder;
    .locals 0
    .param p1, "sep"    # C

    .line 953
    iput-char p1, p0, Lorg/apache/commons/cli/Option$Builder;->valuesep:C

    .line 954
    return-object p0
.end method
