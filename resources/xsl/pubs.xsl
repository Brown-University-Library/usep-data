<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd"
    version="2.0">

    <xsl:param name="url" />
    <xsl:param name="new" />

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
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='j']" mode="journal">
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='m']" mode="monograph">
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span style="color:grey"><xsl:value-of select="@xml:id"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='v']" mode="parent">
        <li><a href="/../{concat($url, normalize-space(./@xml:id))}"> 
            <xsl:choose>
                <xsl:when test="ancestor::t:bibl[@type='c']">
                    <!-- corpus, display abbr -->
                    <xsl:value-of select="ancestor::t:bibl[@type='c']/t:abbr[@type='primary']" />
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!-- not a corpus, display vol -->
                    <xsl:text>vol. </xsl:text>
                </xsl:otherwise>
             </xsl:choose> 
             
            <xsl:choose>
                <xsl:when test="t:biblScope and t:date">
                    <xsl:value-of select="t:biblScope" />
                    (<xsl:value-of select="t:date" />)
                </xsl:when>
                <xsl:otherwise>
                <xsl:if test="t:biblScope">
                    <xsl:value-of select="t:biblScope" />
                </xsl:if>
                <xsl:if test="t:date">
                    <xsl:value-of select="t:date" />
                </xsl:if>
                    
                </xsl:otherwise>
            </xsl:choose>
            <!-- abbr: <xsl:value-of select="t:abbr[@type='primary']" />
            num: <xsl:value-of select="t:biblScope/t:num/@value" />
            date: <xsl:value-of select="t:date" /> @when: <xsl:value-of select="t:date/@when" />
            biblScope: <xsl:value-of select="t:biblScope" /> -->
        </a></li>
    </xsl:template>
    <xsl:template match="t:bibl[@type='a']" mode="parent"/>
    
    
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