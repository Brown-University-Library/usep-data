<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
        xmlns:t="http://www.tei-c.org/ns/1.0"
        exclude-result-prefixes="xs xd t"
        version="2.0">
        <xd:doc scope="stylesheet">
            <xd:desc>
                <xd:p><xd:b>Created on:</xd:b> Mar 20, 2021</xd:p>
                <xd:p><xd:b>Author:</xd:b> elli</xd:p>
                <xd:p>Convert inverted bibliography to more convetional bibliography</xd:p>
                <xd:p><xd:b>Input</xd:b>
                    These are the types of entry we have in the bibliography, and how to handle them:
                 Monographs:  360 @type=m, total.
                1. @type="m" with no child bibls (307): these are copied as is. OK
                2. @type="m" with child bibl @type="a" (47): copy the article info, add "in and short title of edited volume"
                    Note that there is a total of 55 articles in monographs. OK
                3. @type="m" with child bibl @type="v" (6): copy name of publication followed by volume number. 
                   Note that there is a total of 13 volumes in monographs This will be like corpora.
                4. @type="a" (inside journal with volumes) (286): journal type of citation . OK
                5. @type="v" (inside journals) but containing no article inside it (60) We may not need this in order to sort on the pubs page
                   as the volume is tagged separately. 
                6. @type="u" has xml:id xx, xml:id unpub. These are constants, should just copy out them out.  OK
                7. corpora... </xd:p>
             <xd:p><xd:b>Output</xd:b>
                 2 lists - one will represent each work, with its own ID and full bibliographic info in the bibl.
                 The other will be a list of top level publications, for the publications page. One way to connect all
                 the subordinate articles is to put a @ref into the name of the journal or monograph in the entry. This may not be necessary.
                 But we should see how long the processing is if we decide to create the pubs page in rea
                 
             </xd:p>   
             <xd:p><xd:b>Things to look for:</xd:b> There are 5 inscriptions with 2 author elements.
                 These look very garbled and repetitious. Also look at the way that multiple persNames are handled. In some cases, each of two authors
                 has their own persName, and the use of @type="sort" is unclear to me. It usually looks more presentable than the plain persName.
                 The entries with ref elements in them, jstor and others, repeat the title on some cases, and also
                 repeat the "external" link. Probably should just say [jstor] and link to it. 
             </xd:p>
                
            </xd:desc>
        </xd:doc>
        
        <xsl:output method="xml" version="1.1" indent="yes" />
        <xsl:strip-space elements="*"/>    
        
    <!-- setup (templates for elements that we don't want to copy, automatically. Make templates that do nothing. -->
   
    <xsl:template match="t:biblScope"/>
    
    <!--    ***********************   PAGE SETUP    ************************ -->
    
    <t:listBibl type="all-bibl">
        <!-- all the references, where encoders enter new references -->
        <xsl:apply-templates></xsl:apply-templates>
    </t:listBibl>
    
    <t:listBibl type="corpora">
        <!-- list of corpora -->
    </t:listBibl>
    
    <t:listBibl type="journals">
        <!-- list of corpora -->
    </t:listBibl>
    
    
 <!--   <xsl:template match="t:bibl[@type='m'][not(child::t:bibl)]">
        <xsl:copy-of select="."/>
    </xsl:template> this should be picked up in the general copy, now that we are handling the monographs with sub-bibls -->
    
    <!--    ***********************   CORPORA    ************************ -->
    <xsl:template match="t:bibl[@type='c']">
        <xsl:apply-templates select="t:bibl[@type='v']" mode="corpus"/>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='v']" mode="corpus">
        <bibl type="c-v" xml:id="{@xml:id}">
            <xsl:choose>
                <xsl:when test="child::bibl[@type='a']">
                    
                </xsl:when>
                <xsl:when test="child::title">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <title level="c" ref="#{parent::t:bibl[@type='c']/@xml:id}"><xsl:value-of select="parent::t:bibl[@type='c']/t:title"/></title>, <xsl:copy-of select="parent::t:bibl[@type='v']/t:biblScope"/>, <xsl:copy-of select="parent::t:bibl[@type='v']/t:date"/>.
                    <xsl:if test="t:biblScope"><xsl:copy-of select="t:biblScope"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <title level="c" ref="#{parent::t:bibl[@type='c']/@xml:id}"><xsl:value-of select="parent::t:bibl[@type='c']/t:title"/></title>, <xsl:copy-of select="parent::t:bibl[@type='c']/t:biblScope"/>, <xsl:copy-of select="parent::t:bibl[@type='c']/t:date"/>.
            Vol. 
            <xsl:if test="t:biblScope"><xsl:copy-of select="t:biblScope"/>.</xsl:if>
        </bibl>
    </xsl:template>
    
    
    <!--    ***********************   Journals    ************************ -->
    <xsl:template match="t:bibl[@type='j']">
        <xsl:apply-templates select="t:bibl[@type='v']" mode="journal"/>
    </xsl:template>
 
    <xsl:template match="t:bibl[@type='v']" mode="journal">
        <xsl:apply-templates select="t:bibl[@type='a']" mode="journal"/>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='a']" mode="journal">
        <bibl type="a-j" xml:id="{@xml:id}">
            <xsl:apply-templates/>. 
            <title level="j" ref="#{ancestor::t:bibl[@type='j']/@xml:id}"><xsl:value-of select="ancestor::t:bibl[@type='j']/t:title"/></title>, <xsl:copy-of select="parent::t:bibl[@type='v']/t:biblScope"/>, <xsl:copy-of select="parent::t:bibl[@type='v']/t:date"/>.
            <xsl:if test="t:biblScope"><xsl:copy-of select="t:biblScope"/>.</xsl:if>
        </bibl>
    </xsl:template>
    
    
    <!--    ***********************   MONOGRAPHS    ************************ -->
    <xsl:template match="t:bibl[@type='m'][child::t:bibl]">
        <xsl:choose>
            <xsl:when test="child::t:bibl[@type='a']">
                <xsl:apply-templates select="t:bibl[@type='a']" mode="monograph"/>
            </xsl:when>
            <xsl:when test="child::t:bibl[@type='v']">
                <xsl:apply-templates select="t:bibl" mode="monograph"/>                
            </xsl:when>
        </xsl:choose>
    </xsl:template>
     
    <xsl:template match="t:bibl[@type='a']" mode="monograph">
        <bibl type="a-m" xml:id="{@xml:id}">
            <xsl:apply-templates/> in  
            <title level="m" ref="#{parent::t:bibl[@type='m']/@xml:id}"><xsl:value-of select="parent::t:bibl[@type='m']/t:title"/></title>, <xsl:copy-of select="parent::t:bibl[@type='m']/t:pubPlace"/>: <xsl:copy-of select="parent::t:bibl[@type='m']/t:date"/>.
            <xsl:if test="t:biblScope"><xsl:copy-of select="t:biblScope"/>.</xsl:if>
        </bibl>
        
    </xsl:template>
    
   <!-- convert articles in journals. it's ok, to look for them as descendants of journals, as there 
       are no articles that are not contained in a volume. First pass - not trying to get the order of
       of the bibliographic information yet.
    -->
         
        <!--<xsl:template match="t:TEI">
    <xsl:copy>
        <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:copy>
  
</xsl:template>-->
        
        
        <xsl:template match="@*|node()" >
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:template>
    </xsl:stylesheet>
    