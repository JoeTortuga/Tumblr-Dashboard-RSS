<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<rss version="2.0">
		<channel>
			<title>My Tumblr Dashboard</title>
			<link>http://www.tumblr.com/dashboard</link>
			<description>My Tumblr dashboard</description>

			<xsl:apply-templates select="//tumblr/posts/post" />			
		</channel>
	</rss>
</xsl:template>

<xsl:template match="post">
	<item>
		<link><xsl:value-of select="@url-with-slug" /></link>
		<pubDate><xsl:value-of select="@date-gmt" /></pubDate>
		<guid><xsl:value-of select="@url" /></guid>
		
	<xsl:choose>
		<xsl:when test="@type='regular'"><xsl:call-template name="regular" /></xsl:when>
		<xsl:when test="@type='photo'"><xsl:call-template name="photo" /></xsl:when>
		<xsl:when test="@type='quote'"><xsl:call-template name="quote" /></xsl:when>
		<xsl:when test="@type='link'"><xsl:call-template name="link" /></xsl:when>
		<xsl:when test="@type='conversation'"><xsl:call-template name="conversation" /></xsl:when>
		<xsl:when test="@type='video'"><xsl:call-template name="video" /></xsl:when>
		<xsl:when test="@type='audio'"><xsl:call-template name="audio" /></xsl:when>
	</xsl:choose>
	</item>
</xsl:template>

<!-- TODO: "reblogged from..." thing -->
<xsl:template name="regular">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="regular-title">
				<xsl:value-of select="regular-title" />
			</xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description><xsl:value-of select="regular-body" /></description>
</xsl:template>

<xsl:template name="photo">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="photo-caption">
				<xsl:call-template name="clean-up-title">
					<xsl:with-param name="text" select="photo-caption"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>untitled photo</xsl:otherwise>
		</xsl:choose>
	</title>
	<description>
		<xsl:if test="not(photoset)">
			<xsl:if test="photo-click-through-url">&lt;a href="<xsl:value-of select="photo-click-through-url" />&gt;</xsl:if>
			&lt;img src="<xsl:value-of select="photo-url[@max-width=500]" />" alt="" /&gt;
			<xsl:if test="photo-click-through-url">&lt;/a&gt;</xsl:if>
		</xsl:if>
		
		<xsl:value-of select="photo-caption" />
		
		<xsl:apply-templates select="photoset" />
	</description>
</xsl:template>

<xsl:template match="photoset">
	<xsl:for-each select="photo">
		<xsl:if test="string-length(@caption) > 0">&lt;h2&gt;<xsl:value-of select="@caption" />&lt;/h2&gt;</xsl:if>
		&lt;p&gt;&lt;img src="<xsl:value-of select="photo-url[@max-width=500]" />" alt="<xsl:value-of select="@caption" />" /&gt;&lt;/p&gt;
	</xsl:for-each>
</xsl:template>

<xsl:template name="quote">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="quote-text">
				<xsl:call-template name="clean-up-title">
					<xsl:with-param name="text" select="quote-text"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description>
		&lt;p&gt;"<xsl:value-of select="quote-text" />"&lt;/p&gt;
		<xsl:if test="quote-source">
			&lt;p&gt;<xsl:value-of select="quote-source" />&lt;/p&gt;
		</xsl:if>
	</description>
</xsl:template>

<xsl:template name="link">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="link-text"><xsl:value-of select="link-text" /></xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description>
		&lt;p&gt;Shared link: &lt;a href="<xsl:value-of select="link-url" />"&gt;<xsl:value-of select="link-text" />&lt;/a&gt;&lt;/p&gt;
		<xsl:value-of select="link-description" />
	</description>
</xsl:template>

<xsl:template name="conversation">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="conversation-title"><xsl:value-of select="conversation-title" /></xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description><xsl:apply-templates select="conversation/line" /></description>
</xsl:template>

<xsl:template match="line">
	&lt;p&gt;&lt;strong&gt;<xsl:value-of select="@label" />&lt;/strong&gt; <xsl:value-of select="." />&lt;/p&gt;
</xsl:template>

<xsl:template name="video">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="video-title"><xsl:value-of select="video-title" /></xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description>
		<xsl:value-of select="video-embed" /><xsl:value-of select="video-caption" />
	</description>
</xsl:template>

<xsl:template name="audio">
	<title>
		<xsl:value-of select="tumblelog/@name" />: <xsl:choose>
			<xsl:when test="audio-caption">
				<xsl:call-template name="clean-up-title">
					<xsl:with-param name="text" select="audio-caption"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>untitled post</xsl:otherwise>
		</xsl:choose>
	</title>
	<description>
		<xsl:value-of select="audio-player" />
		<xsl:value-of select="audio-caption" />
		&lt;p&gt;&lt;a href="<xsl:value-of select="@url-with-slug" />"&gt;listen to audio&lt;/a&gt;&lt;/p&gt;
	</description>
</xsl:template>

<xsl:template name="clean-up-title">
	<xsl:param name="text" />
	
	<xsl:variable name="output1">
		<xsl:call-template name="strip-tags">
			<xsl:with-param name="text" select="$text" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:value-of select="substring($output1, 1, 100)" /><xsl:if test="string-length($output1) > 100">...</xsl:if>
</xsl:template>


<xsl:template name="strip-tags">
	<xsl:param name="text" />
	<xsl:choose>
		<xsl:when test="contains($text, '&lt;')">
			<xsl:value-of select="substring-before($text, '&lt;')"/>
			<xsl:call-template name="strip-tags">
				<xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>