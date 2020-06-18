<?xml version="1.0" encoding="UTF-8"?>  
    <xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
        xmlns:t="http://www.tei-c.org/ns/1.0"
        xmlns="http://www.tei-c.org/ns/1.0"
        exclude-result-prefixes="xs xd t"
        version="2.0">
        <xd:doc scope="stylesheet">
            <xd:desc>
                <xd:p><xd:b>Revised on:</xd:b> June 4 2020</xd:p>
                <xd:p><xd:b>Author:</xd:b>SJD</xd:p>
                <xd:p></xd:p>
            </xd:desc>
        </xd:doc>
        
        <xsl:output method="xml" indent="no" />
        <xsl:preserve-space elements="*"/>
   
            
            <xsl:template match="//t:support/t:dimensions[@type='letter']">
                <xsl:copy>
                    <xsl:apply-templates select="t:dimensions[@type='letter']"/>
                </xsl:copy>
            </xsl:template>
            
            <xsl:template match="//t:physDesc/t:handDesc/t:handNote[1]">
                <xsl:copy>
                    <CheckList>
                        <xsl:apply-templates select="//t:support/t:dimensions[@type='letter']"/>
                        <xsl:apply-templates select="@*|//t:physDesc/t:handDesc/t:handNote[1]/t:dimensions"/>
                    </CheckList>
                </xsl:copy>
            </xsl:template>
    </xsl:stylesheet>