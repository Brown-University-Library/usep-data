<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">

<xsl:template match="/">
	<xsl:element name="add">
		<xsl:attribute name="commitWithin">500</xsl:attribute>
		<xsl:element name="doc">
			<xsl:apply-templates select="/tei:TEI" />
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="/tei:TEI">

		<!--
		Old schema (All indexed, all stored):

		 d	id:				  string PRIMARY
		 d  msid_region:      string
		 d  msid_settlement:  string
		 d  msid_institution: string
		 d  msid_repository:  string
		 d  msid_idno:        string
		 d  language:         string
		 d  title:            string
		 d  condition:        string
		 d  decoration:       string
		 d  fake:             string
		 d  graphic_name:     string
		 d  material:         string
		 d  object_type:      string  multiValued
		 d  status:           string
		 d  text_genre:       string  multiValued
		 d  writing:          string

		 x  bib_authors:      string  multiValued  
		 d  bib_ids:          string  multiValued
		 x  bib_ids_filtered: string  multiValued
		 x  bib_ids_types:    string  multiValued
		 x  bib_titles:       string  multiValued
		 x  bib_titles_all:   string  multiValued
		    
		    text: text multivalued (Catch-all field)
		    Union of:
				bib_authors
				bib_ids
				bib_titles
				id
				condition
				decoration
				language
				material
				msid_region
				msid_settlement
				msid_institution
				msid_repository
				msid_idno
				object_type
				text_genre
				title
				writing
			(that's everything except bib_ids_filtered, bib_titles_all, fake, graphic_name, and status)
		-->
<!-- 
New Schema (all indexed, all stored):

id              PRIMARY

condition		string
decoration		stringSplit
fake			string
graphic_name	string
language		stringSplit
material		stringSplit
msid_region		string
msid_settlement		string
msid_institution	string
msid_repository		string
msid_idno		string
object_type		stringSplit
text_genre		stringSplit
title			string
writing			stringSplit
status			string

notBefore		date
notAfter		date

c_*				boolean dynamic
	(special characters)
names_<type>     stringSplit dynamic
usually: name_gentilicum
		 name_cognomen
always:  name (created at index time by solr)

bib_ids 		string multiValued
-->

	<xsl:apply-templates />
	<xsl:call-template name="status" />
</xsl:template>

<!-- Generic field-value element -->
<xsl:template name="fieldval">
	<xsl:param name="field" select="'default'" />
	<xsl:param name="value" select="'default'" />

	<xsl:if test="$value!=''">
	<xsl:element name="field">
		<xsl:attribute name="name"><xsl:value-of select="$field"/></xsl:attribute>
		<xsl:value-of select="$value" />
	</xsl:element>
	<xsl:text>
</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template name="fieldval_strip">
	<xsl:param name="field" select="'default'" />
	<xsl:param name="value" select="'default'" />

	<xsl:element name="field">
		<xsl:attribute name="name"><xsl:value-of select="$field"/></xsl:attribute>
		<xsl:value-of select="normalize-space(translate($value, '#', ''))" />
	</xsl:element>
	<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="tei:teiHeader">
	<!-- 
	fileDesc
	encodingDesc
	profileDesc
	revisionDesc 
	-->
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:fileDesc">
	<!-- 
	titleStmt
	publicationStmt
	sourceDesc 
	-->
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:encodingDesc"></xsl:template>

<xsl:template match="tei:profileDesc"></xsl:template>

<xsl:template match="tei:revisionDesc"></xsl:template>

<xsl:template match="tei:titleStmt">
	<!-- title
	/TEI/teiHeader/fileDesc/titleStmt/title
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">title</xsl:with-param>
		<xsl:with-param name="value" select="tei:title"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:publicationStmt">
	<!-- id 
		The UNIQUE primary identifier for the inscription.
		Looks like REGION.SETTLEMENT.INSTITUTION.REPO.IDNO (i.e. the filename of this xml)
		e.g. MA.Glouc.HCM.L.97.6.46
		/TEI/teiHeader/fileDesc/publicationStmt/idno
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">id</xsl:with-param>
		<xsl:with-param name="value" select="tei:idno" />
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:sourceDesc">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:msDesc">
	<!-- 
	contains:

	msIdentifier
	msContents
	physDesc
	history
	-->
	

	<!-- msid fields -->
	<xsl:apply-templates select="tei:msIdentifier"/>

	<!-- language
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msContents/textLang
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">language</xsl:with-param>
		<xsl:with-param name="value" select="tei:msContents/tei:textLang/@mainLang"/>
	</xsl:call-template>
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">language</xsl:with-param>
		<xsl:with-param name="value" select="tei:msContents/tei:textLang/@otherLangs"/>
	</xsl:call-template>

	<!-- fake
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/summary/rs
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">fake</xsl:with-param>
		<xsl:with-param name="value" select="tei:history/tei:summary/tei:rs" />
	</xsl:call-template>

	<xsl:apply-templates select="tei:physDesc"/>

	<!-- text_genre
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItem
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">text_genre</xsl:with-param>
		<xsl:with-param name="value" select="tei:msContents/tei:msItem/@class"/>
	</xsl:call-template>

	<!-- notBefore, notAfter
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/origin/date
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">notBefore</xsl:with-param>
		<xsl:with-param name="value" select="tei:history/tei:origin/tei:date/@notBefore"/>
	</xsl:call-template>
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">notAfter</xsl:with-param>
		<xsl:with-param name="value" select="tei:history/tei:origin/tei:date/@notAfter"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:msIdentifier">
	<!-- msid
		The breakdown of the state, city, institution, repository, and idno of the inscription.
		Five single-valued text fields:
			msid_region
			msid_settlement
			msid_institution
			msid_repository
			msid_idno
		/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier
	 -->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">msid_region</xsl:with-param>
		<xsl:with-param name="value" select="tei:region"/>
	</xsl:call-template>

	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">msid_settlement</xsl:with-param>
		<xsl:with-param name="value" select="tei:settlement"/>
	</xsl:call-template>

	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">msid_institution</xsl:with-param>
		<xsl:with-param name="value" select="tei:institution"/>
	</xsl:call-template>

	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">msid_repository</xsl:with-param>
		<xsl:with-param name="value" select="tei:repository"/>
	</xsl:call-template>

	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">msid_idno</xsl:with-param>
		<xsl:with-param name="value" select="tei:idno"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:physDesc">
	<!-- decoration
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/decoDesc/decoNote 
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">decoration</xsl:with-param>
		<xsl:with-param name="value" select="tei:decoDesc/tei:decoNote/@ana"/>
	</xsl:call-template>

	<xsl:apply-templates select="tei:objectDesc" />

	<!-- writing
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">writing</xsl:with-param>
		<xsl:with-param name="value" select="tei:handDesc/tei:handNote/@ana" />
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:objectDesc">
	<!-- object_type
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">object_type</xsl:with-param>
		<xsl:with-param name="value" select="./@ana"/>
	</xsl:call-template>

	<!-- condition
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/condition
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">condition</xsl:with-param>
		<xsl:with-param name="value" select="tei:supportDesc/tei:condition/@ana"/>
	</xsl:call-template>

	<!-- material
	/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc
	-->
	<xsl:call-template name="fieldval">
		<xsl:with-param name="field">material</xsl:with-param>
		<xsl:with-param name="value" select="tei:supportDesc/@ana"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tei:listBibl">
	<xsl:for-each select="tei:bibl">
		<xsl:call-template name="fieldval_strip">
			<xsl:with-param name="field">bib_ids</xsl:with-param>
			<xsl:with-param name="value" select="tei:ptr/@target" />
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="tei:facsimile">
	<!-- graphic_name
	URLs of the images for this inscription
	facsimile/surface/graphic
	-->
	<xsl:choose>
		<xsl:when test="contains(tei:surface/tei:graphic/@url, ' ')">
			<xsl:call-template name="fieldval">
				<xsl:with-param name="field">graphic_name</xsl:with-param>
				<xsl:with-param name="value" select="substring-before(tei:surface/tei:graphic/@url, ' ')" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="fieldval">
				<xsl:with-param name="field">graphic_name</xsl:with-param>
				<xsl:with-param name="value" select="tei:surface/tei:graphic/@url" />
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:text">
	<xsl:apply-templates select="tei:body/tei:div//tei:ab"/>
</xsl:template>

<xsl:template match="tei:ab">

	<!-- glyphs and highlights -->
	<xsl:for-each select=".//tei:g">
		<xsl:call-template name="fieldval">
			<xsl:with-param name="field">c_<xsl:value-of select="@type"/></xsl:with-param>
			<xsl:with-param name="value">true</xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

	<xsl:for-each select=".//tei:hi">
		<xsl:call-template name="fieldval">
			<xsl:with-param name="field">c_<xsl:value-of select="@rend"/></xsl:with-param>
			<xsl:with-param name="value">true</xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

	<!-- names -->
	<xsl:for-each select=".//tei:name">
		<xsl:choose>
			<xsl:when test="@type">
				<xsl:call-template name="fieldval">
					<xsl:with-param name="field">name_<xsl:value-of select="@type"/></xsl:with-param>
					<xsl:with-param name="value" select="@key" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="fieldval">
					<xsl:with-param name="field">name</xsl:with-param>
					<xsl:with-param name="value" select="@key" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- status
bib_only, metadata, or transcription depending on stuff
-->
<xsl:template name="status">
	<xsl:choose>
		<!-- presence of transcription ab elements -->
		<xsl:when test="tei:text/tei:body/tei:div//tei:ab">
			<!-- <xsl:for-each select="tei:text/tei:body/tei:div//tei:ab"> -->
				<xsl:if test="normalize-space(tei:text/tei:body/tei:div//tei:ab)">
					<xsl:call-template name="fieldval">
						<xsl:with-param name="field">status</xsl:with-param>
						<xsl:with-param name="value">transcription</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			<!-- </xsl:for-each> -->
		</xsl:when>
		<xsl:when test="normalize-space(tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc)">
			<xsl:call-template name="fieldval">
				<xsl:with-param name="field">status</xsl:with-param>
				<xsl:with-param name="value">metadata</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="fieldval">
				<xsl:with-param name="field">status</xsl:with-param>
				<xsl:with-param name="value">bib_only</xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
