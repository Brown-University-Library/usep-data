<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:template match="/">
		<xsl:apply-templates select="//tei:ab" mode="corr"/>
		<xsl:text> </xsl:text>
		<xsl:if test="//tei:choice or //tei:surplus">
			<xsl:apply-templates select="//tei:ab" mode="orig" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:ab" mode="corr">
		<xsl:apply-templates mode="corr" />	
	</xsl:template>

	<xsl:template match="tei:lb" mode="corr">
		<xsl:if test="not(@break)">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:name" mode="corr">
		<xsl:value-of select="@key"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="corr"/>
	</xsl:template>

	<xsl:template match="tei:num" mode="corr">
		<xsl:value-of select="@value"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="corr"/>
	</xsl:template>

	<xsl:template match="tei:choice" mode="corr">
		<xsl:apply-templates select="tei:corr" mode="corr" />
		<xsl:apply-templates select="tei:reg" mode="corr" />
	</xsl:template>


	<xsl:template match="tei:surplus" mode="corr">
	</xsl:template>

	<xsl:template match="tei:expan" mode="corr">
		<xsl:apply-templates select="tei:abbr" mode="corr"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="corr"/>
	</xsl:template>

	<xsl:template match="*" mode="corr">
		<xsl:apply-templates mode="corr" />
	</xsl:template>

	<xsl:template match="tei:choice" mode="orig">
		<xsl:apply-templates select="tei:sic" mode="corr" />
		<xsl:apply-templates select="tei:orig" mode="corr" />
	</xsl:template>
	<xsl:template match="tei:surplus" mode="orig">
		<xsl:apply-templates mode="orig" />
	</xsl:template>

	<xsl:template match="tei:ab" mode="orig">
		<xsl:apply-templates mode="orig" />	
	</xsl:template>

	<xsl:template match="tei:lb" mode="orig">
		<xsl:if test="not(@break)">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:name" mode="orig">
		<xsl:value-of select="@key"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="orig"/>
	</xsl:template>

	<xsl:template match="tei:num" mode="orig">
		<xsl:value-of select="@value"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="orig"/>
	</xsl:template>

	<xsl:template match="tei:expan" mode="orig">
		<xsl:apply-templates select="tei:abbr"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="orig"/>
	</xsl:template>

	<xsl:template match="*" mode="orig">
		<xsl:apply-templates mode="orig"/>
	</xsl:template>


</xsl:stylesheet>