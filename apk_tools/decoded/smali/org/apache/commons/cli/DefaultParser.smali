.class public Lorg/apache/commons/cli/DefaultParser;
.super Ljava/lang/Object;
.source "DefaultParser.java"

# interfaces
.implements Lorg/apache/commons/cli/CommandLineParser;


# instance fields
.field protected cmd:Lorg/apache/commons/cli/CommandLine;

.field protected currentOption:Lorg/apache/commons/cli/Option;

.field protected currentToken:Ljava/lang/String;

.field protected expectedOpts:Ljava/util/List;

.field protected options:Lorg/apache/commons/cli/Options;

.field protected skipParsing:Z

.field protected stopAtNonOption:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private checkRequiredArgs()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 209
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Lorg/apache/commons/cli/Option;->requiresArg()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 211
    :cond_0
    new-instance v0, Lorg/apache/commons/cli/MissingArgumentException;

    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-direct {v0, v1}, Lorg/apache/commons/cli/MissingArgumentException;-><init>(Lorg/apache/commons/cli/Option;)V

    throw v0

    .line 213
    :cond_1
    :goto_0
    return-void
.end method

.method private checkRequiredOptions()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/MissingOptionException;
        }
    .end annotation

    .line 197
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->expectedOpts:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 201
    return-void

    .line 199
    :cond_0
    new-instance v0, Lorg/apache/commons/cli/MissingOptionException;

    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->expectedOpts:Ljava/util/List;

    invoke-direct {v0, v1}, Lorg/apache/commons/cli/MissingOptionException;-><init>(Ljava/util/List;)V

    throw v0
.end method

.method private getLongPrefix(Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p1, "token"    # Ljava/lang/String;

    .line 568
    invoke-static {p1}, Lorg/apache/commons/cli/Util;->stripLeadingHyphens(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 571
    .local v0, "t":Ljava/lang/String;
    const/4 v1, 0x0

    .line 572
    .local v1, "opt":Ljava/lang/String;
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    add-int/lit8 v2, v2, -0x2

    .local v2, "i":I
    :goto_0
    const/4 v3, 0x1

    if-le v2, v3, :cond_1

    .line 574
    const/4 v3, 0x0

    invoke-virtual {v0, v3, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    .line 575
    .local v3, "prefix":Ljava/lang/String;
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v4, v3}, Lorg/apache/commons/cli/Options;->hasLongOption(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 577
    move-object v1, v3

    .line 578
    goto :goto_1

    .line 572
    .end local v3    # "prefix":Ljava/lang/String;
    :cond_0
    add-int/lit8 v2, v2, -0x1

    goto :goto_0

    .line 582
    :cond_1
    :goto_1
    return-object v1
.end method

.method private handleLongOption(Ljava/lang/String;)V
    .locals 2
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 369
    const/16 v0, 0x3d

    invoke-virtual {p1, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    .line 371
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleLongOptionWithoutEqual(Ljava/lang/String;)V

    goto :goto_0

    .line 375
    :cond_0
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleLongOptionWithEqual(Ljava/lang/String;)V

    .line 377
    :goto_0
    return-void
.end method

.method private handleLongOptionWithEqual(Ljava/lang/String;)V
    .locals 7
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 418
    const/16 v0, 0x3d

    invoke-virtual {p1, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    .line 420
    .local v0, "pos":I
    add-int/lit8 v1, v0, 0x1

    invoke-virtual {p1, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 422
    .local v1, "value":Ljava/lang/String;
    const/4 v2, 0x0

    invoke-virtual {p1, v2, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    .line 424
    .local v3, "opt":Ljava/lang/String;
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v4, v3}, Lorg/apache/commons/cli/Options;->getMatchingOptions(Ljava/lang/String;)Ljava/util/List;

    move-result-object v4

    .line 425
    .local v4, "matchingOpts":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_0

    .line 427
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->currentToken:Ljava/lang/String;

    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    goto :goto_0

    .line 429
    :cond_0
    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v5

    const/4 v6, 0x1

    if-gt v5, v6, :cond_2

    .line 435
    iget-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-interface {v4, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v5, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v2

    .line 437
    .local v2, "option":Lorg/apache/commons/cli/Option;
    invoke-virtual {v2}, Lorg/apache/commons/cli/Option;->acceptsArg()Z

    move-result v5

    if-eqz v5, :cond_1

    .line 439
    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 440
    iget-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v5, v1}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 441
    const/4 v5, 0x0

    iput-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_0

    .line 445
    :cond_1
    iget-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentToken:Ljava/lang/String;

    invoke-direct {p0, v5}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    .line 448
    .end local v2    # "option":Lorg/apache/commons/cli/Option;
    :goto_0
    return-void

    .line 431
    :cond_2
    new-instance v2, Lorg/apache/commons/cli/AmbiguousOptionException;

    invoke-direct {v2, v3, v4}, Lorg/apache/commons/cli/AmbiguousOptionException;-><init>(Ljava/lang/String;Ljava/util/Collection;)V

    throw v2
.end method

.method private handleLongOptionWithoutEqual(Ljava/lang/String;)V
    .locals 3
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 391
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/Options;->getMatchingOptions(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    .line 392
    .local v0, "matchingOpts":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 394
    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->currentToken:Ljava/lang/String;

    invoke-direct {p0, v1}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    goto :goto_0

    .line 396
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-gt v1, v2, :cond_1

    .line 402
    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    const/4 v2, 0x0

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v1

    invoke-direct {p0, v1}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 404
    :goto_0
    return-void

    .line 398
    :cond_1
    new-instance v1, Lorg/apache/commons/cli/AmbiguousOptionException;

    invoke-direct {v1, p1, v0}, Lorg/apache/commons/cli/AmbiguousOptionException;-><init>(Ljava/lang/String;Ljava/util/Collection;)V

    throw v1
.end method

.method private handleOption(Lorg/apache/commons/cli/Option;)V
    .locals 1
    .param p1, "option"    # Lorg/apache/commons/cli/Option;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 599
    invoke-direct {p0}, Lorg/apache/commons/cli/DefaultParser;->checkRequiredArgs()V

    .line 601
    invoke-virtual {p1}, Lorg/apache/commons/cli/Option;->clone()Ljava/lang/Object;

    move-result-object v0

    move-object p1, v0

    check-cast p1, Lorg/apache/commons/cli/Option;

    .line 603
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->updateRequiredOptions(Lorg/apache/commons/cli/Option;)V

    .line 605
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/CommandLine;->addOption(Lorg/apache/commons/cli/Option;)V

    .line 607
    invoke-virtual {p1}, Lorg/apache/commons/cli/Option;->hasArg()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 609
    iput-object p1, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_0

    .line 613
    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    .line 615
    :goto_0
    return-void
.end method

.method private handleProperties(Ljava/util/Properties;)V
    .locals 7
    .param p1, "properties"    # Ljava/util/Properties;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 142
    if-nez p1, :cond_0

    .line 144
    return-void

    .line 147
    :cond_0
    invoke-virtual {p1}, Ljava/util/Properties;->propertyNames()Ljava/util/Enumeration;

    move-result-object v0

    .local v0, "e":Ljava/util/Enumeration;, "Ljava/util/Enumeration<*>;"
    :goto_0
    invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v1

    if-eqz v1, :cond_7

    .line 149
    invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    .line 151
    .local v1, "option":Ljava/lang/String;
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v1}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v2

    .line 152
    .local v2, "opt":Lorg/apache/commons/cli/Option;
    if-eqz v2, :cond_6

    .line 158
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v3, v2}, Lorg/apache/commons/cli/Options;->getOptionGroup(Lorg/apache/commons/cli/Option;)Lorg/apache/commons/cli/OptionGroup;

    move-result-object v3

    .line 159
    .local v3, "group":Lorg/apache/commons/cli/OptionGroup;
    if-eqz v3, :cond_1

    invoke-virtual {v3}, Lorg/apache/commons/cli/OptionGroup;->getSelected()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_1

    const/4 v4, 0x1

    goto :goto_1

    :cond_1
    const/4 v4, 0x0

    .line 161
    .local v4, "selected":Z
    :goto_1
    iget-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    invoke-virtual {v5, v1}, Lorg/apache/commons/cli/CommandLine;->hasOption(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_5

    if-nez v4, :cond_5

    .line 164
    invoke-virtual {p1, v1}, Ljava/util/Properties;->getProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 166
    .local v5, "value":Ljava/lang/String;
    invoke-virtual {v2}, Lorg/apache/commons/cli/Option;->hasArg()Z

    move-result v6

    if-eqz v6, :cond_3

    .line 168
    invoke-virtual {v2}, Lorg/apache/commons/cli/Option;->getValues()[Ljava/lang/String;

    move-result-object v6

    if-eqz v6, :cond_2

    invoke-virtual {v2}, Lorg/apache/commons/cli/Option;->getValues()[Ljava/lang/String;

    move-result-object v6

    array-length v6, v6

    if-nez v6, :cond_4

    .line 170
    :cond_2
    invoke-virtual {v2, v5}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    goto :goto_2

    .line 173
    :cond_3
    const-string v6, "yes"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_4

    .line 174
    const-string v6, "true"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_4

    .line 175
    const-string v6, "1"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_4

    .line 178
    goto :goto_0

    .line 181
    :cond_4
    :goto_2
    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 182
    const/4 v6, 0x0

    iput-object v6, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    .line 184
    .end local v1    # "option":Ljava/lang/String;
    .end local v2    # "opt":Lorg/apache/commons/cli/Option;
    .end local v3    # "group":Lorg/apache/commons/cli/OptionGroup;
    .end local v4    # "selected":Z
    .end local v5    # "value":Ljava/lang/String;
    :cond_5
    goto :goto_0

    .line 154
    .restart local v1    # "option":Ljava/lang/String;
    .restart local v2    # "opt":Lorg/apache/commons/cli/Option;
    :cond_6
    new-instance v3, Lorg/apache/commons/cli/UnrecognizedOptionException;

    const-string v4, "Default option wasn\'t defined"

    invoke-direct {v3, v4, v1}, Lorg/apache/commons/cli/UnrecognizedOptionException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v3

    .line 185
    .end local v0    # "e":Ljava/util/Enumeration;, "Ljava/util/Enumeration<*>;"
    .end local v1    # "option":Ljava/lang/String;
    .end local v2    # "opt":Lorg/apache/commons/cli/Option;
    :cond_7
    return-void
.end method

.method private handleShortAndLongOption(Ljava/lang/String;)V
    .locals 8
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 471
    invoke-static {p1}, Lorg/apache/commons/cli/Util;->stripLeadingHyphens(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 473
    .local v0, "t":Ljava/lang/String;
    const/16 v1, 0x3d

    invoke-virtual {v0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    .line 475
    .local v1, "pos":I
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_1

    .line 478
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v0}, Lorg/apache/commons/cli/Options;->hasShortOption(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 480
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v0}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v2

    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    goto/16 :goto_2

    .line 484
    :cond_0
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    goto/16 :goto_2

    .line 487
    :cond_1
    const/4 v2, -0x1

    const/4 v4, 0x0

    const/4 v5, 0x0

    if-ne v1, v2, :cond_6

    .line 490
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v0}, Lorg/apache/commons/cli/Options;->hasShortOption(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 492
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v0}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v2

    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    goto/16 :goto_2

    .line 494
    :cond_2
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v0}, Lorg/apache/commons/cli/Options;->getMatchingOptions(Ljava/lang/String;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_3

    .line 497
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleLongOptionWithoutEqual(Ljava/lang/String;)V

    goto/16 :goto_2

    .line 502
    :cond_3
    invoke-direct {p0, v0}, Lorg/apache/commons/cli/DefaultParser;->getLongPrefix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 504
    .local v2, "opt":Ljava/lang/String;
    if-eqz v2, :cond_4

    iget-object v6, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v6, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v6

    invoke-virtual {v6}, Lorg/apache/commons/cli/Option;->acceptsArg()Z

    move-result v6

    if-eqz v6, :cond_4

    .line 506
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v3, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v3

    invoke-direct {p0, v3}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 507
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v0, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 508
    iput-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_0

    .line 510
    :cond_4
    invoke-direct {p0, v0}, Lorg/apache/commons/cli/DefaultParser;->isJavaProperty(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_5

    .line 513
    iget-object v6, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v0, v4, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v6, v4}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v4

    invoke-direct {p0, v4}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 514
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v0, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 515
    iput-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_0

    .line 520
    :cond_5
    invoke-virtual {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleConcatenatedOptions(Ljava/lang/String;)V

    .line 522
    .end local v2    # "opt":Ljava/lang/String;
    :goto_0
    goto :goto_2

    .line 527
    :cond_6
    invoke-virtual {v0, v4, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 528
    .restart local v2    # "opt":Ljava/lang/String;
    add-int/lit8 v6, v1, 0x1

    invoke-virtual {v0, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 530
    .local v6, "value":Ljava/lang/String;
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v7

    if-ne v7, v3, :cond_8

    .line 533
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v3, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v3

    .line 534
    .local v3, "option":Lorg/apache/commons/cli/Option;
    if-eqz v3, :cond_7

    invoke-virtual {v3}, Lorg/apache/commons/cli/Option;->acceptsArg()Z

    move-result v4

    if-eqz v4, :cond_7

    .line 536
    invoke-direct {p0, v3}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 537
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v4, v6}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 538
    iput-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_1

    .line 542
    :cond_7
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    .line 544
    .end local v3    # "option":Lorg/apache/commons/cli/Option;
    :goto_1
    goto :goto_2

    .line 545
    :cond_8
    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->isJavaProperty(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_9

    .line 548
    iget-object v7, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v4, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v7, v4}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v4

    invoke-direct {p0, v4}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 549
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 550
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-virtual {v3, v6}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 551
    iput-object v5, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    goto :goto_2

    .line 556
    :cond_9
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleLongOptionWithEqual(Ljava/lang/String;)V

    .line 559
    .end local v2    # "opt":Ljava/lang/String;
    .end local v6    # "value":Ljava/lang/String;
    :goto_2
    return-void
.end method

.method private handleToken(Ljava/lang/String;)V
    .locals 2
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 223
    iput-object p1, p0, Lorg/apache/commons/cli/DefaultParser;->currentToken:Ljava/lang/String;

    .line 225
    iget-boolean v0, p0, Lorg/apache/commons/cli/DefaultParser;->skipParsing:Z

    if-eqz v0, :cond_0

    .line 227
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/CommandLine;->addArg(Ljava/lang/String;)V

    goto :goto_0

    .line 229
    :cond_0
    const-string v0, "--"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 231
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/apache/commons/cli/DefaultParser;->skipParsing:Z

    goto :goto_0

    .line 233
    :cond_1
    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    if-eqz v1, :cond_2

    invoke-virtual {v1}, Lorg/apache/commons/cli/Option;->acceptsArg()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->isArgument(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 235
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    invoke-static {p1}, Lorg/apache/commons/cli/Util;->stripLeadingAndTrailingQuotes(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    goto :goto_0

    .line 237
    :cond_2
    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 239
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleLongOption(Ljava/lang/String;)V

    goto :goto_0

    .line 241
    :cond_3
    const-string v0, "-"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 243
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleShortAndLongOption(Ljava/lang/String;)V

    goto :goto_0

    .line 247
    :cond_4
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    .line 250
    :goto_0
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Lorg/apache/commons/cli/Option;->acceptsArg()Z

    move-result v0

    if-nez v0, :cond_5

    .line 252
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    .line 254
    :cond_5
    return-void
.end method

.method private handleUnknownToken(Ljava/lang/String;)V
    .locals 3
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 345
    const-string v0, "-"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, v1, :cond_1

    iget-boolean v0, p0, Lorg/apache/commons/cli/DefaultParser;->stopAtNonOption:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 347
    :cond_0
    new-instance v0, Lorg/apache/commons/cli/UnrecognizedOptionException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unrecognized option: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Lorg/apache/commons/cli/UnrecognizedOptionException;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    throw v0

    .line 350
    :cond_1
    :goto_0
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/CommandLine;->addArg(Ljava/lang/String;)V

    .line 351
    iget-boolean v0, p0, Lorg/apache/commons/cli/DefaultParser;->stopAtNonOption:Z

    if-eqz v0, :cond_2

    .line 353
    iput-boolean v1, p0, Lorg/apache/commons/cli/DefaultParser;->skipParsing:Z

    .line 355
    :cond_2
    return-void
.end method

.method private isArgument(Ljava/lang/String;)Z
    .locals 1
    .param p1, "token"    # Ljava/lang/String;

    .line 263
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->isOption(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->isNegativeNumber(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method private isJavaProperty(Ljava/lang/String;)Z
    .locals 6
    .param p1, "token"    # Ljava/lang/String;

    .line 590
    const/4 v0, 0x0

    const/4 v1, 0x1

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 591
    .local v2, "opt":Ljava/lang/String;
    iget-object v3, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v3, v2}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v3

    .line 593
    .local v3, "option":Lorg/apache/commons/cli/Option;
    if-eqz v3, :cond_1

    invoke-virtual {v3}, Lorg/apache/commons/cli/Option;->getArgs()I

    move-result v4

    const/4 v5, 0x2

    if-ge v4, v5, :cond_0

    invoke-virtual {v3}, Lorg/apache/commons/cli/Option;->getArgs()I

    move-result v4

    const/4 v5, -0x2

    if-ne v4, v5, :cond_1

    :cond_0
    const/4 v0, 0x1

    :cond_1
    return v0
.end method

.method private isLongOption(Ljava/lang/String;)Z
    .locals 5
    .param p1, "token"    # Ljava/lang/String;

    .line 312
    const-string v0, "-"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    goto :goto_1

    .line 317
    :cond_0
    const-string v0, "="

    invoke-virtual {p1, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 318
    .local v0, "pos":I
    const/4 v3, -0x1

    if-ne v0, v3, :cond_1

    move-object v3, p1

    goto :goto_0

    :cond_1
    invoke-virtual {p1, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    .line 320
    .local v3, "t":Ljava/lang/String;
    :goto_0
    iget-object v4, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v4, v3}, Lorg/apache/commons/cli/Options;->getMatchingOptions(Ljava/lang/String;)Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_2

    .line 323
    return v2

    .line 325
    :cond_2
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->getLongPrefix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_3

    const-string v4, "--"

    invoke-virtual {p1, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_3

    .line 328
    return v2

    .line 331
    :cond_3
    return v1

    .line 314
    .end local v0    # "pos":I
    .end local v3    # "t":Ljava/lang/String;
    :cond_4
    :goto_1
    return v1
.end method

.method private isNegativeNumber(Ljava/lang/String;)Z
    .locals 2
    .param p1, "token"    # Ljava/lang/String;

    .line 275
    :try_start_0
    invoke-static {p1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    .line 276
    const/4 v0, 0x1

    return v0

    .line 278
    :catch_0
    move-exception v0

    .line 280
    .local v0, "e":Ljava/lang/NumberFormatException;
    const/4 v1, 0x0

    return v1
.end method

.method private isOption(Ljava/lang/String;)Z
    .locals 1
    .param p1, "token"    # Ljava/lang/String;

    .line 291
    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->isLongOption(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0, p1}, Lorg/apache/commons/cli/DefaultParser;->isShortOption(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method private isShortOption(Ljava/lang/String;)Z
    .locals 3
    .param p1, "token"    # Ljava/lang/String;

    .line 302
    const-string v0, "-"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v2, 0x2

    if-lt v0, v2, :cond_0

    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {p1, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lorg/apache/commons/cli/Options;->hasShortOption(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method private updateRequiredOptions(Lorg/apache/commons/cli/Option;)V
    .locals 2
    .param p1, "option"    # Lorg/apache/commons/cli/Option;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/AlreadySelectedException;
        }
    .end annotation

    .line 624
    invoke-virtual {p1}, Lorg/apache/commons/cli/Option;->isRequired()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 626
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->expectedOpts:Ljava/util/List;

    invoke-virtual {p1}, Lorg/apache/commons/cli/Option;->getKey()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 630
    :cond_0
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/Options;->getOptionGroup(Lorg/apache/commons/cli/Option;)Lorg/apache/commons/cli/OptionGroup;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 632
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/Options;->getOptionGroup(Lorg/apache/commons/cli/Option;)Lorg/apache/commons/cli/OptionGroup;

    move-result-object v0

    .line 634
    .local v0, "group":Lorg/apache/commons/cli/OptionGroup;
    invoke-virtual {v0}, Lorg/apache/commons/cli/OptionGroup;->isRequired()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 636
    iget-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->expectedOpts:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 639
    :cond_1
    invoke-virtual {v0, p1}, Lorg/apache/commons/cli/OptionGroup;->setSelected(Lorg/apache/commons/cli/Option;)V

    .line 641
    .end local v0    # "group":Lorg/apache/commons/cli/OptionGroup;
    :cond_2
    return-void
.end method


# virtual methods
.method protected handleConcatenatedOptions(Ljava/lang/String;)V
    .locals 4
    .param p1, "token"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 672
    const/4 v0, 0x1

    .local v0, "i":I
    :goto_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_3

    .line 674
    invoke-virtual {p1, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v1

    .line 676
    .local v1, "ch":Ljava/lang/String;
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v1}, Lorg/apache/commons/cli/Options;->hasOption(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 678
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    invoke-virtual {v2, v1}, Lorg/apache/commons/cli/Options;->getOption(Ljava/lang/String;)Lorg/apache/commons/cli/Option;

    move-result-object v2

    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleOption(Lorg/apache/commons/cli/Option;)V

    .line 680
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    if-eqz v2, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    add-int/lit8 v3, v0, 0x1

    if-eq v2, v3, :cond_0

    .line 683
    iget-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    add-int/lit8 v3, v0, 0x1

    invoke-virtual {p1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lorg/apache/commons/cli/Option;->addValueForProcessing(Ljava/lang/String;)V

    .line 684
    goto :goto_2

    .line 672
    .end local v1    # "ch":Ljava/lang/String;
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 689
    .restart local v1    # "ch":Ljava/lang/String;
    :cond_1
    iget-boolean v2, p0, Lorg/apache/commons/cli/DefaultParser;->stopAtNonOption:Z

    if-eqz v2, :cond_2

    const/4 v2, 0x1

    if-le v0, v2, :cond_2

    invoke-virtual {p1, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_2
    move-object v2, p1

    :goto_1
    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleUnknownToken(Ljava/lang/String;)V

    .line 693
    .end local v0    # "i":I
    .end local v1    # "ch":Ljava/lang/String;
    :cond_3
    :goto_2
    return-void
.end method

.method public parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;)Lorg/apache/commons/cli/CommandLine;
    .locals 1
    .param p1, "options"    # Lorg/apache/commons/cli/Options;
    .param p2, "arguments"    # [Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 60
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0}, Lorg/apache/commons/cli/DefaultParser;->parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Ljava/util/Properties;)Lorg/apache/commons/cli/CommandLine;

    move-result-object v0

    return-object v0
.end method

.method public parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Ljava/util/Properties;)Lorg/apache/commons/cli/CommandLine;
    .locals 1
    .param p1, "options"    # Lorg/apache/commons/cli/Options;
    .param p2, "arguments"    # [Ljava/lang/String;
    .param p3, "properties"    # Ljava/util/Properties;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 76
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, p3, v0}, Lorg/apache/commons/cli/DefaultParser;->parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Ljava/util/Properties;Z)Lorg/apache/commons/cli/CommandLine;

    move-result-object v0

    return-object v0
.end method

.method public parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Ljava/util/Properties;Z)Lorg/apache/commons/cli/CommandLine;
    .locals 4
    .param p1, "options"    # Lorg/apache/commons/cli/Options;
    .param p2, "arguments"    # [Ljava/lang/String;
    .param p3, "properties"    # Ljava/util/Properties;
    .param p4, "stopAtNonOption"    # Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 102
    iput-object p1, p0, Lorg/apache/commons/cli/DefaultParser;->options:Lorg/apache/commons/cli/Options;

    .line 103
    iput-boolean p4, p0, Lorg/apache/commons/cli/DefaultParser;->stopAtNonOption:Z

    .line 104
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/apache/commons/cli/DefaultParser;->skipParsing:Z

    .line 105
    const/4 v1, 0x0

    iput-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->currentOption:Lorg/apache/commons/cli/Option;

    .line 106
    new-instance v2, Ljava/util/ArrayList;

    invoke-virtual {p1}, Lorg/apache/commons/cli/Options;->getRequiredOptions()Ljava/util/List;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    iput-object v2, p0, Lorg/apache/commons/cli/DefaultParser;->expectedOpts:Ljava/util/List;

    .line 109
    invoke-virtual {p1}, Lorg/apache/commons/cli/Options;->getOptionGroups()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lorg/apache/commons/cli/OptionGroup;

    .line 111
    .local v3, "group":Lorg/apache/commons/cli/OptionGroup;
    invoke-virtual {v3, v1}, Lorg/apache/commons/cli/OptionGroup;->setSelected(Lorg/apache/commons/cli/Option;)V

    .line 112
    .end local v3    # "group":Lorg/apache/commons/cli/OptionGroup;
    goto :goto_0

    .line 114
    :cond_0
    new-instance v1, Lorg/apache/commons/cli/CommandLine;

    invoke-direct {v1}, Lorg/apache/commons/cli/CommandLine;-><init>()V

    iput-object v1, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    .line 116
    if-eqz p2, :cond_1

    .line 118
    array-length v1, p2

    :goto_1
    if-ge v0, v1, :cond_1

    aget-object v2, p2, v0

    .line 120
    .local v2, "argument":Ljava/lang/String;
    invoke-direct {p0, v2}, Lorg/apache/commons/cli/DefaultParser;->handleToken(Ljava/lang/String;)V

    .line 118
    .end local v2    # "argument":Ljava/lang/String;
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 125
    :cond_1
    invoke-direct {p0}, Lorg/apache/commons/cli/DefaultParser;->checkRequiredArgs()V

    .line 128
    invoke-direct {p0, p3}, Lorg/apache/commons/cli/DefaultParser;->handleProperties(Ljava/util/Properties;)V

    .line 130
    invoke-direct {p0}, Lorg/apache/commons/cli/DefaultParser;->checkRequiredOptions()V

    .line 132
    iget-object v0, p0, Lorg/apache/commons/cli/DefaultParser;->cmd:Lorg/apache/commons/cli/CommandLine;

    return-object v0
.end method

.method public parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Z)Lorg/apache/commons/cli/CommandLine;
    .locals 1
    .param p1, "options"    # Lorg/apache/commons/cli/Options;
    .param p2, "arguments"    # [Ljava/lang/String;
    .param p3, "stopAtNonOption"    # Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/apache/commons/cli/ParseException;
        }
    .end annotation

    .line 81
    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0, p3}, Lorg/apache/commons/cli/DefaultParser;->parse(Lorg/apache/commons/cli/Options;[Ljava/lang/String;Ljava/util/Properties;Z)Lorg/apache/commons/cli/CommandLine;

    move-result-object v0

    return-object v0
.end method
