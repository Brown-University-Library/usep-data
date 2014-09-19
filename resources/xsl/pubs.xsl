<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd"
    version="2.0">

    <xsl:param name="url" />

    <xsl:output method="xhtml" encoding="UTF-8" />
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 11, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/t:listBibl">
        <xsl:result-document href="#container">
            <hr />
            <h2 style="text-align:center;">Corpora</h2>
                <xsl:apply-templates mode="corpus"/>
            <hr />
            <h2 style="text-align:center;">Journals</h2>
                <xsl:apply-templates mode="journal"/>
            <hr />
            <h2 style="text-align:center;">Monographs</h2>
                <xsl:apply-templates mode="monograph"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='c']" mode="corpus">
        <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='j']" mode="journal">
        <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='m']" mode="monograph">
        <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='v']"/>
    <xsl:template match="t:bibl[@type='a']"/>
    
    
    <xsl:template match="t:title" mode="#all">
        <i><xsl:value-of select="."/></i>.
    </xsl:template>
    
    <xsl:template match="t:abbr[@type='primary']" mode="corpus journal">
        <xsl:value-of select="concat('[',.,'] ')"/>
    </xsl:template>
    
    <xsl:template match="t:title" mode="#all">
        <i><xsl:value-of select="."/></i>.
    </xsl:template>
    
    <xsl:template match="t:date" mode="#all">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="*" mode="#all"/>
   
</xsl:stylesheet>