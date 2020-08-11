<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 10, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p></xd:p>
        </xd:desc>
        <xd:desc>
            <xd:p><xd:b>Revised on:</xd:b> June 4 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b>SJD</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="no" />
    <xsl:preserve-space elements="*"/>
    <xsl:param name="object"/>   
    <xsl:param name="material"/>
    
    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="t:revisionDesc">
        <xsl:choose>                    
        <xsl:when test="//t:dimensions[@type='letter']">
            <xsl:copy>
                <xsl:apply-templates/>
                <change when="2020-06-18" who="Scott J. DiGiulio">Relocated letter dimensions to proper place</change>
            </xsl:copy>
        </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:dimensions[@type='letter']"/>
    
    <xsl:template match="t:handNote">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:text>
            </xsl:text>
            <xsl:copy-of select="//t:dimensions[@type='letter']" xml:space="preserve"/>
            <xsl:text>
            </xsl:text>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    <!-- 
    <xsl:template match="t:objectDesc">
        <objectDesc ana="{concat('#',$object)}">
            <xsl:apply-templates select="@*|node()" />
        </objectDesc>
    </xsl:template>
    
    <xsl:template match="t:body" xml:space="preserve">
        <xsl:element name="body">
        <xsl:apply-templates select="t:div[@type='edition']"/>
        
        <xsl:choose>
            <xsl:when test="t:div[@type='translation']">
                <xsl:apply-templates select="t:div[@type='translation']"/>
            </xsl:when>
            <xsl:otherwise>
                <div type="translation">
                    <p/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:choose>
            <xsl:when test="t:div[@type='commentary']">
                <xsl:apply-templates select="t:div[@type='commentary']"/>
            </xsl:when>
            <xsl:otherwise>
                <div type="commentary">
                    <p/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:choose>
            <xsl:when test="t:div[@type='apparatus']">
                <xsl:apply-templates select="t:div[@type='apparatus']"/>
            </xsl:when>
            <xsl:otherwise>
                <div type="apparatus">
                    <p/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:apply-templates select="t:div[@type='bibliography']"/>
        </xsl:element>
        
    </xsl:template>-->
    
   
    
    
   
</xsl:stylesheet>
