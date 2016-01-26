ALTER TABLE [dbo].mp_Sites DROP CONSTRAINT DF_mp_Sites_MinRequiredNonAlphanumericCharacters
GO


ALTER TABLE [dbo].mp_Sites DROP COLUMN MinReqNonAlphaChars
GO


ALTER TABLE [dbo].mp_Sites DROP CONSTRAINT DF_mp_Sites_AllowUserFullNameChange
GO


ALTER TABLE [dbo].mp_Sites DROP COLUMN AllowUserFullNameChange
GO

ALTER TABLE [dbo].mp_Sites DROP CONSTRAINT DF_mp_Sites_PasswordAttemptWindowMinutes
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN PasswordAttemptWindowMinutes
GO

ALTER TABLE [dbo].mp_Sites DROP CONSTRAINT DF_mp_Sites_UseSSLOnAllPages
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN UseSSLOnAllPages
GO



ALTER TABLE [dbo].mp_Sites DROP COLUMN ApiKeyExtra1
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN ApiKeyExtra2
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN ApiKeyExtra3
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN ApiKeyExtra4
GO

ALTER TABLE [dbo].mp_Sites DROP COLUMN ApiKeyExtra5
GO

ALTER TABLE [dbo].mp_Sites ADD RequireConfirmedPhone bit NOT NULL default 0
GO

ALTER TABLE [dbo].mp_Sites ADD DefaultEmailFromAlias nvarchar(100) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD AccountApprovalEmailCsv nvarchar(max) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD DkimPublicKey nvarchar(max) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD DkimPrivateKey nvarchar(max) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD DkimDomain nvarchar(255) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD DkimSelector nvarchar(128) NULL 
GO


ALTER TABLE [dbo].mp_Sites ADD SignEmailWithDkim bit NOT NULL default 0
GO

ALTER TABLE [dbo].mp_Sites ADD OidConnectAppId nvarchar(255) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD OidConnectAppSecret nvarchar(max) NULL 
GO


ALTER TABLE [dbo].mp_Sites ADD SmsClientId nvarchar(255) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD SmsSecureToken nvarchar(max) NULL 
GO

ALTER TABLE [dbo].mp_Sites ADD SmsFrom nvarchar(100) NULL 
GO


ALTER TABLE [dbo].mp_Users DROP COLUMN FailedPasswordAnswerAttemptCount
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN FailedPasswordAnswerAttemptWindowStart
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN EmailChangeGuid
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN RegisterConfirmGuid
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN PasswordResetGuid
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN LastLockoutDate
GO

ALTER TABLE [dbo].mp_Users DROP COLUMN LastActivityDate
GO

ALTER TABLE [dbo].mp_Users ADD NewEmailApproved bit NOT NULL default 0
GO

ALTER TABLE [dbo].mp_Users ADD NormalizedUserName nvarchar(50) NULL 
GO

ALTER TABLE [dbo].mp_Users ADD CanBeLockedOut bit NOT NULL default 1
GO



ALTER PROCEDURE [dbo].[mp_Sites_Insert]

/*
Author:   			Joe Audette
Created: 			2005-03-07
Last Modified: 		2016-01-26

*/

@SiteName nvarchar(255),
@Skin nvarchar(100),
@AllowNewRegistration bit,
@UseSecureRegistration 	bit,
@IsServerAdminSite 	bit,
@UseLdapAuth bit,
@AutoCreateLdapUserOnFirstLogin	bit,
@LdapServer	nvarchar(255),
@LdapPort int,
@LdapDomain	nvarchar(255),
@LdapRootDN	nvarchar(255),
@LdapUserDNKey nvarchar(10),
@UseEmailForLogin bit,
@ReallyDeleteUsers bit,
@SiteGuid uniqueidentifier,
@RecaptchaPrivateKey nvarchar(255),
@RecaptchaPublicKey	nvarchar(255),
@DisableDbAuth bit,
@RequiresQuestionAndAnswer bit,
@MaxInvalidPasswordAttempts int,
@MinRequiredPasswordLength int,
@DefaultEmailFromAddress nvarchar(100),
@AllowDbFallbackWithLdap bit,
@EmailLdapDbFallback bit,
@AllowPersistentLogin bit,
@CaptchaOnLogin bit,
@CaptchaOnRegistration bit,
@SiteIsClosed bit,
@SiteIsClosedMessage nvarchar(max),
@PrivacyPolicy nvarchar(max),
@TimeZoneId nvarchar(50),
@GoogleAnalyticsProfileId nvarchar(25),
@CompanyName nvarchar(255),
@CompanyStreetAddress nvarchar(250),
@CompanyStreetAddress2 nvarchar(250),
@CompanyRegion nvarchar(200),
@CompanyLocality nvarchar(200),
@CompanyCountry nvarchar(10),
@CompanyPostalCode nvarchar(20),
@CompanyPublicEmail nvarchar(100),
@CompanyPhone nvarchar(20),
@CompanyFax nvarchar(20),
@FacebookAppId nvarchar(100),
@FacebookAppSecret nvarchar(max),
@GoogleClientId nvarchar(100),
@GoogleClientSecret nvarchar(max),
@TwitterConsumerKey nvarchar(100),
@TwitterConsumerSecret nvarchar(max),
@MicrosoftClientId nvarchar(100),
@MicrosoftClientSecret nvarchar(max),
@PreferredHostName nvarchar(250),
@SiteFolderName nvarchar(50),
@AddThisDotComUsername nvarchar(50),
@LoginInfoTop nvarchar(max),
@LoginInfoBottom nvarchar(max),
@RegistrationAgreement nvarchar(max),
@RegistrationPreamble nvarchar(max),
@SmtpServer nvarchar(200),
@SmtpPort int,
@SmtpUser nvarchar(500),
@SmtpPassword nvarchar(max),
@SmtpPreferredEncoding nvarchar(20),
@SmtpRequiresAuth bit,
@SmtpUseSsl bit,
@RequireApprovalBeforeLogin bit,
@IsDataProtected bit,
@CreatedUtc datetime,
@RequireConfirmedPhone bit,
@DefaultEmailFromAlias nvarchar(100),
@AccountApprovalEmailCsv nvarchar(max),
@DkimPublicKey nvarchar(max),
@DkimPrivateKey nvarchar(max),
@DkimDomain nvarchar(255),
@DkimSelector nvarchar(128),
@SignEmailWithDkim bit,
@OidConnectAppId nvarchar(255),
@OidConnectAppSecret nvarchar(max),
@SmsClientId nvarchar(255),
@SmsSecureToken nvarchar(max),
@SmsFrom nvarchar(100)

AS
INSERT INTO 	[dbo].[mp_Sites] 
(
				
				[SiteName],
				[Skin],
				[AllowNewRegistration],
				[UseSecureRegistration],
				[IsServerAdminSite],
				UseLdapAuth,
				AutoCreateLdapUserOnFirstLogin,
				LdapServer,
				LdapPort,
				LdapDomain,
				LdapRootDN,
				LdapUserDNKey,
				ReallyDeleteUsers,
				UseEmailForLogin,
				SiteGuid,
				RecaptchaPrivateKey,
				RecaptchaPublicKey,
				DisableDbAuth,
				RequiresQuestionAndAnswer,
				MaxInvalidPasswordAttempts,
				MinRequiredPasswordLength,
				DefaultEmailFromAddress,
				AllowDbFallbackWithLdap,
				EmailLdapDbFallback,
				AllowPersistentLogin,
				CaptchaOnLogin,
				CaptchaOnRegistration,
				SiteIsClosed,
				SiteIsClosedMessage,
				PrivacyPolicy,
				TimeZoneId,
				GoogleAnalyticsProfileId,
				CompanyName,
				CompanyStreetAddress,
				CompanyStreetAddress2,
				CompanyRegion,
				CompanyLocality,
				CompanyCountry,
				CompanyPostalCode,
				CompanyPublicEmail,
				CompanyPhone,
				CompanyFax,
				FacebookAppId,
				FacebookAppSecret,
				GoogleClientId,
				GoogleClientSecret,
				TwitterConsumerKey,
				TwitterConsumerSecret,
				MicrosoftClientId,
				MicrosoftClientSecret,
				PreferredHostName,
				SiteFolderName,
				AddThisDotComUsername,
				LoginInfoTop,
				LoginInfoBottom,
				RegistrationAgreement,
				RegistrationPreamble,
				SmtpServer,
				SmtpPort,
				SmtpUser,
				SmtpPassword,
				SmtpPreferredEncoding,
				SmtpRequiresAuth,
				SmtpUseSsl,
				RequireApprovalBeforeLogin,
				CreatedUtc,
				IsDataProtected,
				RequireConfirmedPhone,
				DefaultEmailFromAlias,
				AccountApprovalEmailCsv,
				DkimPublicKey,
				DkimPrivateKey,
				DkimDomain,
				DkimSelector,
				SignEmailWithDkim,
				OidConnectAppId,
				OidConnectAppSecret,
				SmsClientId,
				SmsSecureToken,
				SmsFrom
) 

VALUES 
(
				
				@SiteName,
				@Skin,
				@AllowNewRegistration,
				@UseSecureRegistration,
				@IsServerAdminSite,
				@UseLdapAuth,
				@AutoCreateLdapUserOnFirstLogin,
				@LdapServer,
				@LdapPort,
				@LdapDomain,
				@LdapRootDN,
				@LdapUserDNKey,
				@ReallyDeleteUsers,
				@UseEmailForLogin,
				@SiteGuid,
				@RecaptchaPrivateKey,
				@RecaptchaPublicKey,
				@DisableDbAuth,
				@RequiresQuestionAndAnswer,
				@MaxInvalidPasswordAttempts,
				@MinRequiredPasswordLength,
				@DefaultEmailFromAddress,
				@AllowDbFallbackWithLdap,
				@EmailLdapDbFallback,
				@AllowPersistentLogin,
				@CaptchaOnLogin,
				@CaptchaOnRegistration,
				@SiteIsClosed,
				@SiteIsClosedMessage,
				@PrivacyPolicy,
				@TimeZoneId,
				@GoogleAnalyticsProfileId,
				@CompanyName,
				@CompanyStreetAddress,
				@CompanyStreetAddress2,
				@CompanyRegion,
				@CompanyLocality,
				@CompanyCountry,
				@CompanyPostalCode,
				@CompanyPublicEmail,
				@CompanyPhone,
				@CompanyFax,
				@FacebookAppId,
				@FacebookAppSecret,
				@GoogleClientId,
				@GoogleClientSecret,
				@TwitterConsumerKey,
				@TwitterConsumerSecret,
				@MicrosoftClientId,
				@MicrosoftClientSecret,
				@PreferredHostName,
				@SiteFolderName,
				@AddThisDotComUsername,
				@LoginInfoTop,
				@LoginInfoBottom,
				@RegistrationAgreement,
				@RegistrationPreamble,
				@SmtpServer,
				@SmtpPort,
				@SmtpUser,
				@SmtpPassword,
				@SmtpPreferredEncoding,
				@SmtpRequiresAuth,
				@SmtpUseSsl,
				@RequireApprovalBeforeLogin,
				@CreatedUtc,
				@IsDataProtected,
				@RequireConfirmedPhone,
				@DefaultEmailFromAlias,
				@AccountApprovalEmailCsv,
				@DkimPublicKey,
				@DkimPrivateKey,
				@DkimDomain,
				@DkimSelector,
				@SignEmailWithDkim,
				@OidConnectAppId,
				@OidConnectAppSecret,
				@SmsClientId,
				@SmsSecureToken,
				@SmsFrom
				
)
SELECT @@IDENTITY

GO


ALTER PROCEDURE [dbo].[mp_Sites_Update]

/*
Author:		Joe Audette
Last Modified:	2016-01-26

*/

@SiteID int,
@SiteName nvarchar(128),
@Skin nvarchar(100),
@AllowNewRegistration bit,
@UseSecureRegistration bit,
@IsServerAdminSite bit,
@UseLdapAuth bit,
@AutoCreateLdapUserOnFirstLogin	bit,
@LdapServer	nvarchar(255),
@LdapPort int,
@LdapDomain	nvarchar(255),
@LdapRootDN	nvarchar(255),
@LdapUserDNKey	nvarchar(10),
@UseEmailForLogin bit,
@ReallyDeleteUsers bit,
@RecaptchaPrivateKey nvarchar(255),
@RecaptchaPublicKey	nvarchar(255),
@DisableDbAuth bit,
@RequiresQuestionAndAnswer bit,
@MaxInvalidPasswordAttempts int,
@MinRequiredPasswordLength int,
@DefaultEmailFromAddress nvarchar(100),
@AllowDbFallbackWithLdap bit,
@EmailLdapDbFallback bit,
@AllowPersistentLogin bit,
@CaptchaOnLogin bit,
@CaptchaOnRegistration bit,
@SiteIsClosed bit,
@SiteIsClosedMessage nvarchar(max),
@PrivacyPolicy nvarchar(max),
@TimeZoneId nvarchar(50),
@GoogleAnalyticsProfileId nvarchar(25),
@CompanyName nvarchar(255),
@CompanyStreetAddress nvarchar(250),
@CompanyStreetAddress2 nvarchar(250),
@CompanyRegion nvarchar(200),
@CompanyLocality nvarchar(200),
@CompanyCountry nvarchar(10),
@CompanyPostalCode nvarchar(20),
@CompanyPublicEmail nvarchar(100),
@CompanyPhone nvarchar(20),
@CompanyFax nvarchar(20),
@FacebookAppId nvarchar(100),
@FacebookAppSecret nvarchar(max),
@GoogleClientId nvarchar(100),
@GoogleClientSecret nvarchar(max),
@TwitterConsumerKey nvarchar(100),
@TwitterConsumerSecret nvarchar(max),
@MicrosoftClientId nvarchar(100),
@MicrosoftClientSecret nvarchar(max),
@PreferredHostName nvarchar(250),
@SiteFolderName nvarchar(50),
@AddThisDotComUsername nvarchar(50),
@LoginInfoTop nvarchar(max),
@LoginInfoBottom nvarchar(max),
@RegistrationAgreement nvarchar(max),
@RegistrationPreamble nvarchar(max),
@SmtpServer nvarchar(200),
@SmtpPort int,
@SmtpUser nvarchar(500),
@SmtpPassword nvarchar(max),
@SmtpPreferredEncoding nvarchar(20),
@SmtpRequiresAuth bit,
@SmtpUseSsl bit,
@RequireApprovalBeforeLogin bit,
@IsDataProtected bit,
@RequireConfirmedPhone bit,
@DefaultEmailFromAlias nvarchar(100),
@AccountApprovalEmailCsv nvarchar(max),
@DkimPublicKey nvarchar(max),
@DkimPrivateKey nvarchar(max),
@DkimDomain nvarchar(255),
@DkimSelector nvarchar(128),
@SignEmailWithDkim bit,
@OidConnectAppId nvarchar(255),
@OidConnectAppSecret nvarchar(max),
@SmsClientId nvarchar(255),
@SmsSecureToken nvarchar(max),
@SmsFrom nvarchar(100)
	
AS
UPDATE	mp_Sites

SET
    SiteName = @SiteName,
	Skin = @Skin,
	AllowNewRegistration = @AllowNewRegistration,
	UseSecureRegistration = @UseSecureRegistration,
	IsServerAdminSite = @IsServerAdminSite,
	UseLdapAuth = @UseLdapAuth,
	AutoCreateLdapUserOnFirstLogin = @AutoCreateLdapUserOnFirstLogin,
	LdapServer = @LdapServer,
	LdapPort = @LdapPort,
    LdapDomain = @LdapDomain,
	LdapRootDN = @LdapRootDN,
	LdapUserDNKey = @LdapUserDNKey,
	UseEmailForLogin = @UseEmailForLogin,
	ReallyDeleteUsers = @ReallyDeleteUsers,
	RecaptchaPrivateKey = @RecaptchaPrivateKey,
	RecaptchaPublicKey = @RecaptchaPublicKey,
	DisableDbAuth = @DisableDbAuth,
	RequiresQuestionAndAnswer = @RequiresQuestionAndAnswer,
	MaxInvalidPasswordAttempts = @MaxInvalidPasswordAttempts,
	MinRequiredPasswordLength = @MinRequiredPasswordLength,
	DefaultEmailFromAddress = @DefaultEmailFromAddress,
	AllowDbFallbackWithLdap = @AllowDbFallbackWithLdap,
	EmailLdapDbFallback = @EmailLdapDbFallback,
	AllowPersistentLogin = @AllowPersistentLogin,
	CaptchaOnLogin = @CaptchaOnLogin,
	CaptchaOnRegistration = @CaptchaOnRegistration,
	SiteIsClosed = @SiteIsClosed,
	SiteIsClosedMessage = @SiteIsClosedMessage,
	PrivacyPolicy = @PrivacyPolicy,
	TimeZoneId = @TimeZoneId,
	GoogleAnalyticsProfileId = @GoogleAnalyticsProfileId,
	CompanyName = @CompanyName,
	CompanyStreetAddress = @CompanyStreetAddress,
	CompanyStreetAddress2 = @CompanyStreetAddress2,
	CompanyRegion = @CompanyRegion,
	CompanyLocality = @CompanyLocality,
	CompanyCountry = @CompanyCountry,
	CompanyPostalCode = @CompanyPostalCode,
	CompanyPublicEmail = @CompanyPublicEmail,
	CompanyPhone = @CompanyPhone,
	CompanyFax = @CompanyFax,
	FacebookAppId = @FacebookAppId,
	FacebookAppSecret = @FacebookAppSecret,
	GoogleClientId = @GoogleClientId,
	GoogleClientSecret = @GoogleClientSecret,
	TwitterConsumerKey = @TwitterConsumerKey,
	TwitterConsumerSecret = @TwitterConsumerSecret,
	MicrosoftClientId = @MicrosoftClientId,
	MicrosoftClientSecret = @MicrosoftClientSecret,
	PreferredHostName = @PreferredHostName,
	SiteFolderName = @SiteFolderName,
	AddThisDotComUsername = @AddThisDotComUsername,
	LoginInfoTop = @LoginInfoTop,
	LoginInfoBottom = @LoginInfoBottom,
	RegistrationAgreement = @RegistrationAgreement,
	RegistrationPreamble = @RegistrationPreamble,
	SmtpServer = @SmtpServer,
	SmtpPort = @SmtpPort,
	SmtpUser = @SmtpUser,
	SmtpPassword = @SmtpPassword,
	SmtpPreferredEncoding = @SmtpPreferredEncoding,
	SmtpRequiresAuth = @SmtpRequiresAuth,
	SmtpUseSsl = @SmtpUseSsl,
	RequireApprovalBeforeLogin = @RequireApprovalBeforeLogin,
	IsDataProtected = @IsDataProtected,
	RequireConfirmedPhone = @RequireConfirmedPhone,
	DefaultEmailFromAlias = @DefaultEmailFromAlias,
	AccountApprovalEmailCsv = @AccountApprovalEmailCsv,
	DkimPublicKey = @DkimPublicKey,
	DkimPrivateKey = @DkimPrivateKey,
	DkimDomain = @DkimDomain,
	DkimSelector = @DkimSelector,
	SignEmailWithDkim = @SignEmailWithDkim,
	OidConnectAppId = @OidConnectAppId,
	OidConnectAppSecret = @OidConnectAppSecret,
	SmsClientId = @SmsClientId,
	SmsSecureToken = @SmsSecureToken,
	SmsFrom = @SmsFrom

WHERE
    	SiteID = @SiteID

GO


ALTER PROCEDURE [dbo].[mp_Sites_UpdateRelatedSiteSecurity]

/*
Author:			Joe Audette
Created			2009-09-16
Last Modified:	2016-01-27

*/

@SiteID           			int,
@AllowNewRegistration bit,
@UseSecureRegistration bit,
@UseLdapAuth				bit,
@AutoCreateLdapUserOnFirstLogin	bit,
@LdapServer				nvarchar(255),
@LdapDomain				nvarchar(255),
@LdapPort				int,
@LdapRootDN				nvarchar(255),
@LdapUserDNKey			nvarchar(10),
@AllowUserFullNameChange		bit,
@UseEmailForLogin			bit,
@RequiresQuestionAndAnswer	bit,
@MaxInvalidPasswordAttempts	int,
@MinRequiredPasswordLength	int

	
AS
UPDATE	mp_Sites

SET
    
	AllowNewRegistration = @AllowNewRegistration,
	UseSecureRegistration = @UseSecureRegistration,
	UseLdapAuth = @UseLdapAuth,
	AutoCreateLdapUserOnFirstLogin = @AutoCreateLdapUserOnFirstLogin,
	LdapServer = @LdapServer,
	LdapPort = @LdapPort,
    LdapDomain = @LdapDomain,
	LdapRootDN = @LdapRootDN,
	LdapUserDNKey = @LdapUserDNKey,
	AllowUserFullNameChange = @AllowUserFullNameChange,
	UseEmailForLogin = @UseEmailForLogin,
	RequiresQuestionAndAnswer = @RequiresQuestionAndAnswer,
	MaxInvalidPasswordAttempts = @MaxInvalidPasswordAttempts,
	MinRequiredPasswordLength = @MinRequiredPasswordLength
	
WHERE
    	SiteID <> @SiteID

GO

















CREATE PROCEDURE [dbo].[mp_Users_CountEmailUnconfirmed]

/*
Author:			Joe Audette
Created:		2016-01-25
Last Modified:	2016-01-25

*/

@SiteID		int

AS

SELECT  	COUNT(*)

FROM		mp_Users

WHERE	SiteID = @SiteID
AND		EmailConfirmed = 0


GO

CREATE PROCEDURE [dbo].[mp_Users_UnconfirmedEmailPage]

/*
Author:			Joe Audette
Created:		2016-01-25
Last Modified:	2016-01-25

*/

@SiteID			int,
@PageNumber 			int,
@PageSize 			int



AS
DECLARE @PageLowerBound int
DECLARE @PageUpperBound int


SET @PageLowerBound = (@PageSize * @PageNumber) - @PageSize
SET @PageUpperBound = @PageLowerBound + @PageSize + 1


CREATE TABLE #PageIndexForUsers 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	UserID int
)	


 BEGIN
	    INSERT INTO 	#PageIndexForUsers (UserID)

	    SELECT 	UserID
		FROM 		[dbo].mp_Users 
		WHERE 	
				SiteID = @SiteID
				AND EmailConfirmed = 0
				
		ORDER BY 	[Name]

END


SELECT		u.*

FROM			[dbo].mp_Users u

JOIN			#PageIndexForUsers p
ON			u.UserID = p.UserID

WHERE 		
			u.SiteID = 1
			AND p.IndexID > @PageLowerBound 
			AND p.IndexID < @PageUpperBound

ORDER BY		p.IndexID

DROP TABLE #PageIndexForUsers


GO


CREATE PROCEDURE [dbo].[mp_Users_CountPhoneUnconfirmed]

/*
Author:			Joe Audette
Created:		2016-01-25
Last Modified:	2016-01-25

*/

@SiteID		int

AS

SELECT  	COUNT(*)

FROM		mp_Users

WHERE	SiteID = @SiteID
AND		PhoneNumberConfirmed = 0


GO

CREATE PROCEDURE [dbo].[mp_Users_UnconfirmedPhonePage]

/*
Author:			Joe Audette
Created:		2016-01-25
Last Modified:	2016-01-25

*/

@SiteID			int,
@PageNumber 			int,
@PageSize 			int



AS
DECLARE @PageLowerBound int
DECLARE @PageUpperBound int


SET @PageLowerBound = (@PageSize * @PageNumber) - @PageSize
SET @PageUpperBound = @PageLowerBound + @PageSize + 1


CREATE TABLE #PageIndexForUsers 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	UserID int
)	


 BEGIN
	    INSERT INTO 	#PageIndexForUsers (UserID)

	    SELECT 	UserID
		FROM 		[dbo].mp_Users 
		WHERE 	
				SiteID = @SiteID
				AND PhoneNumberConfirmed = 0
				
		ORDER BY 	[Name]

END


SELECT		u.*

FROM			[dbo].mp_Users u

JOIN			#PageIndexForUsers p
ON			u.UserID = p.UserID

WHERE 		
			u.SiteID = 1
			AND p.IndexID > @PageLowerBound 
			AND p.IndexID < @PageUpperBound

ORDER BY		p.IndexID

DROP TABLE #PageIndexForUsers


GO


ALTER Procedure [dbo].[mp_Users_Insert]

/*
Author:			Joe Audette
Created:		2004-09-30
Last Modified:	2016-01-26

*/

@SiteGuid	uniqueidentifier,
@SiteID	int,
@Name     	nvarchar(100),
@LoginName	nvarchar(50),
@Email    	nvarchar(100),
@UserGuid	uniqueidentifier,
@DateCreated datetime,
@MustChangePwd bit,
@FirstName     	nvarchar(100),
@LastName     	nvarchar(100),
@TimeZoneId     	nvarchar(32),
@DateOfBirth	datetime,
@EmailConfirmed bit,
@PasswordHash nvarchar(max),
@SecurityStamp nvarchar(max),
@PhoneNumber nvarchar(50),
@PhoneNumberConfirmed bit,
@TwoFactorEnabled bit,
@LockoutEndDateUtc datetime,
@AccountApproved bit,
@IsLockedOut bit,
@DisplayInMemberList bit,
@WebSiteURL nvarchar(100),
@Country nvarchar(100),
@State nvarchar(100),
@AvatarUrl nvarchar(250),
@Signature nvarchar(max),
@AuthorBio nvarchar(max),
@Comment nvarchar(max),
@NormalizedUserName nvarchar(50),
@LoweredEmail nvarchar(100),
@CanBeLockedOut bit


AS
INSERT INTO mp_Users
(
			SiteGuid,
			SiteID,
    		[Name],
			LoginName,
    		Email,	
			UserGuid,
			DateCreated,
			MustChangePwd,
			RolesChanged,
			FirstName,
			LastName,
			TimeZoneId,
			DateOfBirth,
			EmailConfirmed,
			PasswordHash,
			SecurityStamp,
			PhoneNumber,
			PhoneNumberConfirmed,
			TwoFactorEnabled,
			LockoutEndDateUtc,
			AccountApproved,
			IsLockedOut,
			DisplayInMemberList,
			WebSiteURL,
			Country,
			State,
			AvatarUrl,
			Signature,
			IsDeleted,
			FailedPasswordAttemptCount,
			FailedPwdAnswerAttemptCount,
			AuthorBio,
			[Comment],
			NormalizedUserName,
			LoweredEmail,
			NewEmailApproved,
			CanBeLockedOut
		
	

)

VALUES
(
			@SiteGuid,
			@SiteID,
    		@Name,
			@LoginName,
    		@Email,
			@UserGuid,
			@DateCreated,
			@MustChangePwd,
			0,
			@FirstName,
			@LastName,
			@TimeZoneId,
			@DateOfBirth,
			@EmailConfirmed,
			@PasswordHash,
			@SecurityStamp,
			@PhoneNumber,
			@PhoneNumberConfirmed,
			@TwoFactorEnabled,
			@LockoutEndDateUtc,
			@AccountApproved,
			@IsLockedOut,
			@DisplayInMemberList,
			@WebSiteURL,
			@Country,
			@State,
			@AvatarUrl,
			@Signature,
			0,
			0,
			0,
			@AuthorBio,
			@Comment,
			@NormalizedUserName,
			@LoweredEmail,
			0,
			@CanBeLockedOut
)

SELECT		@@Identity As UserID

GO

ALTER PROCEDURE [dbo].[mp_Users_Update]

/*
Author:			Joe Audette
Created:		2004-09-30
Last Modified:	2015-11-05

*/

    
@UserID int,   
@Name nvarchar(100),
@LoginName nvarchar(50),
@Email  nvarchar(100),   
@Gender	nchar(1),
@AccountApproved bit,
@Trusted bit,
@DisplayInMemberList bit,
@WebSiteURL	nvarchar(100),
@Country nvarchar(100),
@State nvarchar(100),
@AvatarUrl nvarchar(255),
@Signature nvarchar(max),
@LoweredEmail nvarchar(100),
@Comment nvarchar(max),
@MustChangePwd bit,
@FirstName nvarchar(100),
@LastName nvarchar(100),
@TimeZoneId nvarchar(32),
@NewEmail nvarchar(100),
@RolesChanged bit,
@AuthorBio nvarchar(max),
@DateOfBirth datetime,
@EmailConfirmed bit,
@PasswordHash nvarchar(max),
@SecurityStamp nvarchar(max),
@PhoneNumber nvarchar(50),
@PhoneNumberConfirmed bit,
@TwoFactorEnabled bit,
@LockoutEndDateUtc datetime,
@IsLockedOut bit,
@NormalizedUserName nvarchar(50),
@NewEmailApproved bit,
@CanBeLockedOut bit


AS
UPDATE		mp_Users

SET			[Name] = @Name,
			LoginName = @LoginName,
			Email = @Email,
    		MustChangePwd = @MustChangePwd,
			Gender = @Gender,
			AccountApproved = @AccountApproved,
			Trusted = @Trusted,
			DisplayInMemberList = @DisplayInMemberList,
			WebSiteURL = @WebSiteURL,
			Country = @Country,
			[State] = @State,
			AvatarUrl = @AvatarUrl,
			[Signature] = @Signature,
			LoweredEmail = @LoweredEmail,
			Comment = @Comment,
			FirstName = @FirstName,
			LastName = @LastName,
			TimeZoneId = @TimeZoneId,
			NewEmail = @NewEmail,
			RolesChanged = @RolesChanged,
			AuthorBio = @AuthorBio,
			DateOfBirth = @DateOfBirth,
			EmailConfirmed = @EmailConfirmed,
			PasswordHash = @PasswordHash,
			SecurityStamp = @SecurityStamp,
			PhoneNumber = @PhoneNumber,
			PhoneNumberConfirmed = @PhoneNumberConfirmed,
			TwoFactorEnabled = @TwoFactorEnabled,
			IsLockedOut = @IsLockedOut,
			LockoutEndDateUtc = @LockoutEndDateUtc,
			NormalizedUserName = @NormalizedUserName,
			NewEmailApproved = @NewEmailApproved,
			CanBeLockedOut = @CanBeLockedOut
			
WHERE		UserID = @UserID

GO







