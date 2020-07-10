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
    </xd:doc>
    
    <xsl:output method="xml" indent="no" />
    <xsl:preserve-space elements="*"/>
    <xsl:param name="object"/>   
    <xsl:param name="material"/>
    
   <!-- 
    <xsl:template match="t:objectDesc">
        <objectDesc ana="{concat('#',$object)}">
            <xsl:apply-templates select="@*|node()" />
        </objectDesc>
    </xsl:template>-->
    
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
        
    </xsl:template>
    
    <!-- 
    
    <xsl:template match="t:revisionDesc">
        <xsl:copy><xsl:apply-templates/>
        <t:change when="2020-04-09" who="persons.xml#Elli_Mylonas">Added and re-ordered translation, commentary and apparatus divs</t:change>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="@*|node()" >
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>