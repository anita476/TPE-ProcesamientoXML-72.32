<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  
  <xsl:template match="season_data">
  <xsl:choose>
  <xsl:when test="error">
  <xsl:apply-templates select="error"/>
  </xsl:when>
  <xsl:otherwise>
  # Season <xsl:value-of select="season/name"/>
  ### Competition: <xsl:value-of select="season/competition/name"/>
  Gender: <xsl:value-of select="season/competition/gender"/>
  #### Year: <xsl:value-of select="season/date/year"/>. From <xsl:value-of select="season/date/start"/> to <xsl:value-of select="season/date/end"/>
  --- <xsl:apply-templates select="stages/stage"/>
  #### Teams
  <xsl:apply-templates select="competitors/competitor"/>
  <xsl:apply-templates select="error"/>
  ---
  </xsl:otherwise>
  </xsl:choose>
  </xsl:template>


  <xsl:template match="stage">
  ---
  #### <xsl:value-of select="@phase"/>. From <xsl:value-of select="@start_date"/> to <xsl:value-of select="@end_date"/>
  <xsl:apply-templates select="groups/group"/>
  </xsl:template>


  <xsl:template match="group">
  #### Competitors:
  <xsl:for-each select="competitor"> * <xsl:value-of select="name"/> (<xsl:value-of select="abbreviation"/>) 
  </xsl:for-each>
  </xsl:template>


  <xsl:template match="competitor">
  #### <xsl:value-of select="name"/>
  ##### Players:
  | Name | Type | Date of Birth | Nationality | Events Played |
  | --- | --- | --- | --- | --- |
  <xsl:apply-templates select="players/player">
  <xsl:sort select="number(events_played)" order="descending"/>
  </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="player">
  <xsl:value-of select="name"/> | <xsl:value-of select="type"/> | <xsl:value-of select="date_of_birth"/> | <xsl:value-of select="nationality"/> | <xsl:value-of select="events_played"/> |
  </xsl:template>

  <xsl:template match="error">
  Error: <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>  