<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs xd t" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 20, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p>Convert inverted bibliography to more convetional bibliography</xd:p>
            <xd:p><xd:b>Input</xd:b> These are the types of entry we have in the bibliography, and
                how to handle them: Monographs: 360 @type=m, total. 1. @type="m" with no child bibls
                (307): these are copied as is. OK 2. @type="m" with child bibl @type="a" (47): copy
                the article info, add "in and short title of edited volume" Note that there is a
                total of 55 articles in monographs. OK 3. @type="m" with child bibl @type="v" (6):
                copy name of publication followed by volume number. Note that there is a total of 13
                volumes in monographs This will be like corpora. 4. @type="a" (inside journal with
                volumes) (286): journal type of citation . OK 5. @type="v" (inside journals) but
                containing no article inside it (60) We may not need this in order to sort on the
                pubs page as the volume is tagged separately. 6. @type="u" has xml:id xx, xml:id
                unpub. These are constants, should just copy out them out. OK 7. corpora... </xd:p>
            <xd:p><xd:b>Output</xd:b> 2 lists - one will represent each work, with its own ID and
                full bibliographic info in the bibl. The other will be a list of top level
                publications, for the publications page. One way to connect all the subordinate
                articles is to put a @ref into the name of the journal or monograph in the entry.
                This may not be necessary. But we should see how long the processing is if we decide
                to create the pubs page in rea </xd:p>
            <xd:p><xd:b>Things to look for:</xd:b> There are 5 inscriptions with 2 author elements.
                These look very garbled and repetitious. Also look at the way that multiple
                persNames are handled. In some cases, each of two authors has their own persName,
                and the use of @type="sort" is unclear to me. It usually looks more presentable than
                the plain persName. The entries with ref elements in them, jstor and others, repeat
                the title on some cases, and also repeat the "external" link. Probably should just
                say [jstor] and link to it. </xd:p>

        </xd:desc>
    </xd:doc>

    <xsl:output method="xml" version="1.1" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- setup (templates for elements that we don't want to copy automatically. Make templates that do nothing. -->

    <xsl:template match="t:biblScope"/>

    <!--    ***********************   PAGE SETUP    ************************ -->

    <t:listBibl type="all-bibl">
        <!-- all the references, where encoders enter new references -->
        <xsl:apply-templates/>
    </t:listBibl>
    
    <!-- these may not be necessary because each journal or corpus has a main entry that is copied below. -->
    <t:listBibl type="corpora">
        <!-- list of corpora -->
    </t:listBibl>

    <t:listBibl type="journals">
        <!-- list of corpora -->
    </t:listBibl>


    <!--    ***********************   CORPORA    ************************ -->
    <!-- When there are no child bibls, copy main corpus entries as is -->
    <xsl:template match="t:bibl[@type='c'][not(child::t:bibl)]">
        <bibl type="c" xml:id="{@xml:id}">
            <xsl:apply-templates/>
        </bibl>
    </xsl:template>
    
    <!-- When there are child bibls, copy corpus main entries and kick off volume processing-->
    <xsl:template match="t:bibl[@type='c'][child::t:bibl]">
        <bibl type="c" xml:id="{@xml:id}">
            <xsl:apply-templates mode="corpus-main-entry"/>
        </bibl>
        
        <xsl:apply-templates select="t:bibl[@type='v']" mode="corpus"/>
        
    </xsl:template>
    
    <!-- block copying of child bibls when we only want the main entry for a corpus -->
    <xsl:template match="t:bibl[parent::t:bibl[@type ='c']]" mode="corpus-main-entry"/>  
    
    <!-- Copy volumes when there child bibls -->
    <xsl:template match="t:bibl[@type = 'v']" mode="corpus">
        <xsl:choose>
            <xsl:when test="t:title">
                <bibl type="v-c" xml:id="{@xml:id}">
                    <xsl:copy-of select="t:author"/>, <xsl:copy-of select="t:title"/>. 
                    <title level="c" ref="#{parent::t:bibl[@type='c']/@xml:id}"><xsl:value-of select="parent::t:bibl/t:title"/></title>
                    <xsl:copy-of select="t:biblScope"/>. <xsl:copy-of select="t:pubPlace"/>, <xsl:copy-of select="t:date"/>
                </bibl>
            </xsl:when>
            <xsl:otherwise>
                <bibl type="v-c" xml:id="{@xml:id}">
                    <title level="c" ref="#{parent::t:bibl[@type='c']/@xml:id}"><xsl:value-of select="parent::t:bibl/t:title"/></title>,
                    <xsl:if test="t:date"><xsl:copy-of select="t:date"/>:</xsl:if> <xsl:copy-of select="t:biblScope"/>.
                </bibl>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>      

    <!--    ***********************   JOURNALS    ************************ -->
    <xsl:template match="t:bibl[@type = 'j']">
        <bibl type="j" xml:id="{@xml:id}">
            <xsl:apply-templates mode="journal-main-entry"/>
        </bibl>
        
        <xsl:apply-templates select="t:bibl[@type = 'v']" mode="journal"/>
    </xsl:template>
    
    <!-- block copying of child bibls when we only want the main entry for a journal -->
    <xsl:template match="t:bibl[parent::t:bibl[@type = 'j']]" mode="journal-main-entry"/>

    <xsl:template match="t:bibl[@type = 'v']" mode="journal">
        <xsl:choose>
            <xsl:when test="child::t:bibl[@type='a']">
                <xsl:apply-templates select="t:bibl[@type = 'a']" mode="journal"/>
            </xsl:when>
            <xsl:otherwise>
                <bibl type="v-j" xml:id="{@xml:id}">
                    <title level="j" ref="#{parent::t:bibl[@type='j']/@xml:id}"><xsl:value-of select="parent::t:bibl/t:title"/></title>,
                    <xsl:if test="t:author"><xsl:copy-of select="t:author"/>.</xsl:if> <xsl:copy-of select="t:biblScope"/>
                    <xsl:if test="t:date"> (<xsl:copy-of select="t:date"/>)</xsl:if>.
                </bibl>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>

    <xsl:template match="t:bibl[@type = 'a']" mode="journal">
        <bibl type="a-j" xml:id="{@xml:id}">
            <xsl:apply-templates/>. <title level="j" ref="#{ancestor::t:bibl[@type='j']/@xml:id}"
                    ><xsl:value-of select="ancestor::t:bibl[@type = 'j']/t:title"/></title>,
                <xsl:copy-of select="parent::t:bibl[@type = 'v']/t:biblScope"/>, <xsl:copy-of
                select="parent::t:bibl[@type = 'v']/t:date"/>. <xsl:if test="t:biblScope"
                    ><xsl:copy-of select="t:biblScope"/>.</xsl:if>
        </bibl>
    </xsl:template>


    <!--    ***********************   MONOGRAPHS    ************************ -->
    <!-- A monograph with no child bibls is copied by the identity template.  -->
    <xsl:template match="t:bibl[@type = 'm'][not(child::t:bibl)]">
        <bibl type="m" xml:id="{@xml:id}">
            <xsl:apply-templates/>
        </bibl>
    </xsl:template>

    <!-- Moographs with articles or volumes should first copy the main entry for the monograph itself. Then copy out an entry for each 
    article or volume. -->
    <xsl:template match="t:bibl[@type = 'm'][child::t:bibl]">

        <bibl type="m" xml:id="{@xml:id}">
            <xsl:apply-templates mode="monograph-main-entry"/>
        </bibl>

        <xsl:choose>
            <xsl:when test="child::t:bibl[@type = 'a']">
                <xsl:apply-templates select="t:bibl[@type = 'a']" mode="monograph"/>
            </xsl:when>
            <xsl:when test="child::t:bibl[@type = 'v']">
                <xsl:apply-templates select="t:bibl" mode="monograph"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Edited volumes with articles in them -->
    <xsl:template match="t:bibl[parent::t:bibl[@type = 'm']]" mode="monograph-main-entry"/>

    <!-- A monograph which has multiple volumes and has children of @type="v" - should generate an entry for each volume as well as an entry for the monograph itself-->
    <xsl:template match="t:bibl[@type = 'a']" mode="monograph">
        <bibl type="a-m" xml:id="{@xml:id}">
            <xsl:apply-templates/> in <title level="m" ref="#{parent::t:bibl[@type='m']/@xml:id}"
                    ><xsl:value-of select="parent::t:bibl[@type = 'm']/t:title"/></title>,
                <xsl:copy-of select="parent::t:bibl[@type = 'm']/t:pubPlace"/>: <xsl:copy-of
                select="parent::t:bibl[@type = 'm']/t:date"/>. <xsl:if test="t:biblScope"
                    ><xsl:copy-of select="t:biblScope"/>.</xsl:if>
        </bibl>
    </xsl:template>

    <!-- Monographs with volumes -->
    <xsl:template match="t:bibl[@type = 'v']" mode="monograph">
        <bibl type="v-m" xml:id="{@xml:id}">
            <title level="m" ref="#{parent::t:bibl[@type='m']/@xml:id}"><xsl:value-of
                    select="parent::t:bibl[@type = 'm']/t:title"/></title>, <xsl:copy-of
                select="parent::t:bibl[@type = 'm']/t:pubPlace"/>: <xsl:copy-of
                select="parent::t:bibl[@type = 'm']/t:date"/>. <xsl:copy-of
                select="t:biblScope"/>. </bibl>
    </xsl:template>


    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
