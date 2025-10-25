USE [master]
GO
/****** Object:  Database [bilgisiyar]    Script Date: 12.05.2024 17:10:12 ******/
CREATE DATABASE [bilgisiyar]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bilgisiyar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\bilgisiyar.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bilgisiyar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\bilgisiyar_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [bilgisiyar] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bilgisiyar].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bilgisiyar] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bilgisiyar] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bilgisiyar] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bilgisiyar] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bilgisiyar] SET ARITHABORT OFF 
GO
ALTER DATABASE [bilgisiyar] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bilgisiyar] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bilgisiyar] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bilgisiyar] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bilgisiyar] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bilgisiyar] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bilgisiyar] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bilgisiyar] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bilgisiyar] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bilgisiyar] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bilgisiyar] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bilgisiyar] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bilgisiyar] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bilgisiyar] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bilgisiyar] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bilgisiyar] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bilgisiyar] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bilgisiyar] SET RECOVERY FULL 
GO
ALTER DATABASE [bilgisiyar] SET  MULTI_USER 
GO
ALTER DATABASE [bilgisiyar] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bilgisiyar] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bilgisiyar] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bilgisiyar] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bilgisiyar] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bilgisiyar] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [bilgisiyar] SET QUERY_STORE = ON
GO
ALTER DATABASE [bilgisiyar] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/****** Object:  Login [NT Service\MSSQL$SQLEXPRESS]    Script Date: 12.05.2024 17:10:12 ******/

/****** Object:  Login [NT SERVICE\Winmgmt]    Script Date: 12.05.2024 17:10:12 ******/

/****** Object:  Login [NT SERVICE\SQLWriter]    Script Date: 12.05.2024 17:10:12 ******/



/****** Object:  Login [DESKTOP-68FH6J1\PC]    Script Date: 12.05.2024 17:10:12 ******/

/****** Object:  Login [BUILTIN\Users]    Script Date: 12.05.2024 17:10:12 ******/

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [##MS_PolicyTsqlExecutionLogin##]    Script Date: 12.05.2024 17:10:12 ******/

ALTER LOGIN [##MS_PolicyTsqlExecutionLogin##] DISABLE
GO

GO
ALTER LOGIN [##MS_PolicyEventProcessingLogin##] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\Winmgmt]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLWriter]
GO

USE [bilgisiyar]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_MUSTERI_SAYISI]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_MUSTERI_SAYISI]
(@musteri NVARCHAR(100))
RETURNS INT
AS
BEGIN
DECLARE @toplam int
SET @toplam =  (SELECT COUNT(*) FROM Musteri)

			   RETURN @toplam
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_STOK_FIYAT_TOPLAM]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_STOK_FIYAT_TOPLAM]()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @toplam DECIMAL(10,2)
    DECLARE @fiyatStokToplam DECIMAL(10,2)

    -- FiyaStokToplam için baþlangýç deðeri atanýyor
    SET @fiyatStokToplam = 0.0

    -- Ram tablosundaki her bir ürünün fiyatýný stok miktarýyla çarp ve topla
    SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
    FROM Ram 

    -- Anakart tablosundaki her bir ürünün fiyatýný stok miktarýyla çarp ve topla
    SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
    FROM Anakart 
	
	 --BilgisiyarKasasý
	
	 SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
     FROM BilgisayarKasasi
	 
	 --Ekran Kartý

     SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
     FROM EkranKarti
     
	 --Fan
	 SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
     FROM Fan

	 --HDD
	 SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
     FROM HDD

	 --Ýþlemci
	  SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
      FROM Islemci

	  --PSU
	  SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
      FROM PSU
	   
	   --SSD
	   SELECT @fiyatStokToplam = @fiyatStokToplam + (Fiyat * Stok_Miktari)
       FROM SSD


    -- Toplamý hesapla
    SET @toplam = @fiyatStokToplam

    RETURN @toplam
END
GO
/****** Object:  Table [dbo].[Personel]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personel](
	[Personel_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ad] [nvarchar](50) NOT NULL,
	[Soyad] [nvarchar](50) NOT NULL,
	[IseBaslamaTarihi] [date] NOT NULL,
	[Medeni_Durum] [nvarchar](20) NOT NULL,
	[Maas] [money] NOT NULL,
 CONSTRAINT [PK_Personel] PRIMARY KEY CLUSTERED 
(
	[Personel_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_PersonelMaasSec]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_PersonelMaasSec] (@Secilen_ID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Ad, Soyad, Maas
    FROM Personel
    WHERE Personel_ID = @secilen_ID
)
GO
/****** Object:  Table [dbo].[Modeller]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modeller](
	[Model_ID] [int] IDENTITY(1,1) NOT NULL,
	[Model_Adi] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Modeller__1E82D1D3C9FB1DD5] PRIMARY KEY CLUSTERED 
(
	[Model_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BilgisayarKasasi]    Script Date: 12.05.2024 17:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BilgisayarKasasi](
	[Kasa_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Kasa_Boyutu] [varchar](50) NOT NULL,
	[Kasa_Turu] [varchar](50) NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__Bilgisay__1595E41195F53F13] PRIMARY KEY CLUSTERED 
(
	[Kasa_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Full_Outer_Join/ModellerXBilgisiyarKasasi]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Full_Outer_Join/ModellerXBilgisiyarKasasi]
AS
SELECT        dbo.Modeller.Model_ID, dbo.Modeller.Model_Adi, dbo.BilgisayarKasasi.Kasa_ID, dbo.BilgisayarKasasi.Marka_ID, dbo.BilgisayarKasasi.Model_ID AS Expr1, dbo.BilgisayarKasasi.Kasa_Boyutu, 
                         dbo.BilgisayarKasasi.Kasa_Turu, dbo.BilgisayarKasasi.Fiyat, dbo.BilgisayarKasasi.Stok_Miktari
FROM            dbo.Modeller FULL OUTER JOIN
                         dbo.BilgisayarKasasi ON dbo.Modeller.Model_ID = dbo.BilgisayarKasasi.Model_ID
GO
/****** Object:  Table [dbo].[Anakart]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Anakart](
	[Anakart_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Islemci_Soketi_Turu] [varchar](50) NOT NULL,
	[Bellek_Yuvalari] [int] NOT NULL,
	[Baglanti_Noktalari] [varchar](255) NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__Anakart__8A5E86FDF83DEB5D] PRIMARY KEY CLUSTERED 
(
	[Anakart_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_AnakartFiyatAraligi]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_AnakartFiyatAraligi] (@minFiyat DECIMAL, @maxFiyat DECIMAL)
RETURNS TABLE
AS
RETURN
(
    SELECT Anakart_ID, Fiyat
    FROM Anakart
    WHERE Fiyat BETWEEN @minFiyat AND @maxFiyat
)


GO
/****** Object:  Table [dbo].[Markalar]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Markalar](
	[Marka_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_Adi] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Markalar__5DAC4C9B250BFF27] PRIMARY KEY CLUSTERED 
(
	[Marka_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PSU]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PSU](
	[PSU_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Watt_Deðeri] [int] NOT NULL,
	[Verimlilik_Sýnýfý] [varchar](50) NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__PSU__FAA156BEDF1F8BEF] PRIMARY KEY CLUSTERED 
(
	[PSU_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Right_Outer_Join/MarkalarXPSU]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Right_Outer_Join/MarkalarXPSU]
AS
SELECT        dbo.Markalar.Marka_ID, dbo.Markalar.Marka_Adi, dbo.PSU.PSU_ID, dbo.PSU.Marka_ID AS Expr1, dbo.PSU.Model_ID, dbo.PSU.Watt_Deðeri, dbo.PSU.Verimlilik_Sýnýfý, dbo.PSU.Fiyat, dbo.PSU.Stok_Miktari
FROM            dbo.Markalar RIGHT OUTER JOIN
                         dbo.PSU ON dbo.Markalar.Marka_ID = dbo.PSU.Marka_ID
GO
/****** Object:  Table [dbo].[IslemciSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IslemciSatis](
	[IslemciSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Islemci_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_IslemciSatis] PRIMARY KEY CLUSTERED 
(
	[IslemciSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Musteri]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Musteri](
	[Musteri_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ad] [nvarchar](70) NOT NULL,
	[Soyad] [nvarchar](40) NOT NULL,
	[Telefon] [nvarchar](11) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Adres] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Musteri__1E6CEE0AE996A95C] PRIMARY KEY CLUSTERED 
(
	[Musteri_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Left_Outer_Join/MusteriXIslemciSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Left_Outer_Join/MusteriXIslemciSatis]
AS
SELECT        dbo.Musteri.Musteri_ID, dbo.Musteri.Ad, dbo.Musteri.Soyad, dbo.Musteri.Telefon, dbo.Musteri.Email, dbo.Musteri.Adres, dbo.IslemciSatis.IslemciSatis_ID, dbo.IslemciSatis.Musteri_ID AS Expr1, dbo.IslemciSatis.Islemci_ID, 
                         dbo.IslemciSatis.SatisTarihi
FROM            dbo.Musteri LEFT OUTER JOIN
                         dbo.IslemciSatis ON dbo.Musteri.Musteri_ID = dbo.IslemciSatis.Musteri_ID
GO
/****** Object:  Table [dbo].[Ram]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ram](
	[Ram_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Kapasite] [int] NOT NULL,
	[Hiz] [int] NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__Ram__8840B2972B061A63] PRIMARY KEY CLUSTERED 
(
	[Ram_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Inner_Join/ModellerXRam]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Inner_Join/ModellerXRam]
AS
SELECT        dbo.Modeller.Model_ID, dbo.Modeller.Model_Adi, dbo.Ram.Ram_ID, dbo.Ram.Marka_ID, dbo.Ram.Model_ID AS Expr1, dbo.Ram.Kapasite, dbo.Ram.Hiz, dbo.Ram.Fiyat, dbo.Ram.Stok_Miktari
FROM            dbo.Modeller INNER JOIN
                         dbo.Ram ON dbo.Modeller.Model_ID = dbo.Ram.Model_ID
GO
/****** Object:  Table [dbo].[AnakartSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnakartSatis](
	[AnakartSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Anakart_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_AnakartSatis] PRIMARY KEY CLUSTERED 
(
	[AnakartSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BilgisayarKasasiSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BilgisayarKasasiSatis](
	[BilgisayarKasasiSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Kasa_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_BilgisayarKasasiSatis] PRIMARY KEY CLUSTERED 
(
	[BilgisayarKasasiSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EkranKarti]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EkranKarti](
	[EkranKarti_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Bellek_Kapasitesi] [int] NOT NULL,
	[Baglanti_Arayuzu] [varchar](50) NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__EkranKar__252B111CD418B500] PRIMARY KEY CLUSTERED 
(
	[EkranKarti_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EkranKartiSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EkranKartiSatis](
	[EkranKartiSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[EkranKarti_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_EkranKartiSatis] PRIMARY KEY CLUSTERED 
(
	[EkranKartiSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fan]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fan](
	[Fan_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Fan_Boyutu] [int] NOT NULL,
	[Baglanti_Arayuzu] [varchar](50) NOT NULL,
	[Fan_Hizi] [int] NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__Fan__9CB60E1677B8E49A] PRIMARY KEY CLUSTERED 
(
	[Fan_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FanSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FanSatis](
	[FanSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Fan_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_FanSatis] PRIMARY KEY CLUSTERED 
(
	[FanSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HDD]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HDD](
	[HDD_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Kapasite] [int] NOT NULL,
	[Baglanti_Turu] [varchar](50) NOT NULL,
	[Donus_Hizi] [int] NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__HDD__2B1AB7D6BBAD1C29] PRIMARY KEY CLUSTERED 
(
	[HDD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HDDSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HDDSatis](
	[HDDSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[HDD_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_HDDSatis] PRIMARY KEY CLUSTERED 
(
	[HDDSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Islemci]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Islemci](
	[Islemci_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Soket_Turu] [varchar](50) NOT NULL,
	[Cekirdek_Sayisi] [int] NOT NULL,
	[Islemci_Hizi] [decimal](5, 2) NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__Islemci__7F391BA640236D88] PRIMARY KEY CLUSTERED 
(
	[Islemci_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Musteri_Yedek]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Musteri_Yedek](
	[Musteri_ID] [int] NOT NULL,
	[Ad] [nvarchar](70) NOT NULL,
	[Soyad] [nvarchar](40) NOT NULL,
	[Telefon] [nvarchar](11) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Adres] [nvarchar](255) NOT NULL,
	[Sistem_Tarihi] [datetime] NULL,
	[Atan_Kullanici] [nvarchar](100) NULL,
	[Silinme_Durumu] [bit] NULL,
 CONSTRAINT [PK_Musteri_Yedek] PRIMARY KEY CLUSTERED 
(
	[Musteri_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PSUSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PSUSatis](
	[PSUSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[PSU_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_PSUSatis] PRIMARY KEY CLUSTERED 
(
	[PSUSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RamSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RamSatis](
	[RamSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Ram_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_RamSatis] PRIMARY KEY CLUSTERED 
(
	[RamSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSD]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSD](
	[SSD_ID] [int] IDENTITY(1,1) NOT NULL,
	[Marka_ID] [int] NOT NULL,
	[Model_ID] [int] NOT NULL,
	[Kapasite] [int] NOT NULL,
	[Baglanti_Turu] [varchar](50) NOT NULL,
	[Okuma_Hizi] [int] NOT NULL,
	[Yazma_Hizi] [int] NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
	[Stok_Miktari] [int] NOT NULL,
 CONSTRAINT [PK__SSD__A3D2622CB7C05037] PRIMARY KEY CLUSTERED 
(
	[SSD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSDSatis]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSDSatis](
	[SSDSatis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[SSD_ID] [int] NOT NULL,
	[SatisTarihi] [date] NOT NULL,
	[Personel_ID] [int] NOT NULL,
 CONSTRAINT [PK_SSDSatis] PRIMARY KEY CLUSTERED 
(
	[SSDSatis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ToplamaPC]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ToplamaPC](
	[ToplamaPC_ID] [int] IDENTITY(1,1) NOT NULL,
	[Musteri_ID] [int] NOT NULL,
	[Personel_ID] [int] NOT NULL,
	[Tarih] [date] NOT NULL,
	[Anakart_ID] [int] NOT NULL,
	[Kasa_ID] [int] NOT NULL,
	[EkranKarti_ID] [int] NOT NULL,
	[Fan_ID] [int] NOT NULL,
	[HDD_ID] [int] NOT NULL,
	[Islemci_ID] [int] NOT NULL,
	[PSU_ID] [int] NOT NULL,
	[Ram_ID] [int] NOT NULL,
	[SSD_ID] [int] NOT NULL,
	[Fiyat] [decimal](12, 0) NOT NULL,
 CONSTRAINT [PK_ToplamaPC] PRIMARY KEY CLUSTERED 
(
	[ToplamaPC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Anakart] ON 

INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (1, 16, 22, N'LGA1200', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(2299.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (2, 15, 21, N'AM4', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(899.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (3, 15, 21, N'AM4', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(1199.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (4, 16, 22, N'LGA1200', 2, N'USB, Ethernet, HDMI, DisplayPort', CAST(599.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (5, 15, 21, N'AM4', 2, N'USB, Ethernet, HDMI, DisplayPort', CAST(499.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (6, 16, 22, N'LGA1200', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(1699.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (7, 16, 22, N'LGA1200', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(2499.99 AS Decimal(10, 2)), 8)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (8, 15, 21, N'AM4', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(1399.99 AS Decimal(10, 2)), 12)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (9, 15, 21, N'AM4', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(799.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[Anakart] ([Anakart_ID], [Marka_ID], [Model_ID], [Islemci_Soketi_Turu], [Bellek_Yuvalari], [Baglanti_Noktalari], [Fiyat], [Stok_Miktari]) VALUES (10, 16, 22, N'LGA1200', 4, N'USB, Ethernet, HDMI, DisplayPort', CAST(1899.99 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[Anakart] OFF
GO
SET IDENTITY_INSERT [dbo].[AnakartSatis] ON 

INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 9, CAST(N'2023-02-10' AS Date), 2)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 3, 2, CAST(N'2024-05-03' AS Date), 3)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 4, 5, CAST(N'2024-05-04' AS Date), 1)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 5, 4, CAST(N'2024-05-05' AS Date), 2)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[AnakartSatis] ([AnakartSatis_ID], [Musteri_ID], [Anakart_ID], [SatisTarihi], [Personel_ID]) VALUES (8, 7, 6, CAST(N'2024-05-07' AS Date), 1)
SET IDENTITY_INSERT [dbo].[AnakartSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[BilgisayarKasasi] ON 

INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (1, 1, 11, N'ATX', N'Mid Tower', CAST(349.99 AS Decimal(10, 2)), 50)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (2, 7, 12, N'ATX', N'Mid Tower', CAST(99.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (3, 11, 13, N'ATX', N'Mid Tower', CAST(69.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (4, 12, 14, N'ATX', N'Mid Tower', CAST(109.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (5, 5, 15, N'ATX', N'Mid Tower', CAST(79.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (6, 13, 16, N'ATX', N'Mid Tower', CAST(149.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (7, 4, 17, N'Micro ATX', N'Mini Tower', CAST(49.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (8, 6, 18, N'ATX', N'Mid Tower', CAST(119.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (9, 9, 19, N'ATX', N'Mid Tower', CAST(69.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[BilgisayarKasasi] ([Kasa_ID], [Marka_ID], [Model_ID], [Kasa_Boyutu], [Kasa_Turu], [Fiyat], [Stok_Miktari]) VALUES (10, 14, 20, N'Mini ITX', N'Mini Tower', CAST(59.99 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[BilgisayarKasasi] OFF
GO
SET IDENTITY_INSERT [dbo].[BilgisayarKasasiSatis] ON 

INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-05-03' AS Date), 3)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2024-05-04' AS Date), 1)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2024-05-05' AS Date), 2)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[BilgisayarKasasiSatis] ([BilgisayarKasasiSatis_ID], [Musteri_ID], [Kasa_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-07' AS Date), 1)
SET IDENTITY_INSERT [dbo].[BilgisayarKasasiSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[EkranKarti] ON 

INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (1, 17, 23, 6, N'HDMI, DisplayPort', CAST(1999.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (2, 18, 24, 4, N'HDMI, DisplayPort', CAST(1499.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (3, 19, 25, 11, N'HDMI, DisplayPort', CAST(6999.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (4, 20, 26, 12, N'HDMI, DisplayPort', CAST(2999.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (5, 21, 27, 4, N'HDMI, DisplayPort', CAST(899.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (6, 22, 28, 12, N'HDMI, DisplayPort', CAST(3899.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (7, 23, 29, 16, N'HDMI, DisplayPort', CAST(4999.99 AS Decimal(10, 2)), 5)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (8, 24, 30, 8, N'HDMI, DisplayPort', CAST(3499.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (9, 25, 31, 16, N'HDMI, DisplayPort', CAST(5999.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[EkranKarti] ([EkranKarti_ID], [Marka_ID], [Model_ID], [Bellek_Kapasitesi], [Baglanti_Arayuzu], [Fiyat], [Stok_Miktari]) VALUES (10, 26, 32, 10, N'HDMI, DisplayPort', CAST(8999.99 AS Decimal(10, 2)), 8)
SET IDENTITY_INSERT [dbo].[EkranKarti] OFF
GO
SET IDENTITY_INSERT [dbo].[EkranKartiSatis] ON 

INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-05-03' AS Date), 3)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2024-05-04' AS Date), 1)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2024-05-05' AS Date), 2)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[EkranKartiSatis] ([EkranKartiSatis_ID], [Musteri_ID], [EkranKarti_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-07' AS Date), 1)
SET IDENTITY_INSERT [dbo].[EkranKartiSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[Fan] ON 

INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (1, 27, 33, 120, N'4-pin', 1500, CAST(99.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (2, 1, 34, 120, N'4-pin', 2400, CAST(129.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (3, 7, 35, 140, N'4-pin', 1500, CAST(149.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (4, 5, 36, 120, N'3-pin', 2000, CAST(79.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (5, 6, 37, 140, N'4-pin', 1000, CAST(89.99 AS Decimal(10, 2)), 12)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (6, 4, 38, 120, N'3-pin', 1500, CAST(69.99 AS Decimal(10, 2)), 14)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (7, 28, 39, 120, N'4-pin', 1800, CAST(49.99 AS Decimal(10, 2)), 12)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (8, 29, 40, 120, N'3-pin', 1300, CAST(39.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (9, 30, 41, 120, N'4-pin', 2400, CAST(59.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[Fan] ([Fan_ID], [Marka_ID], [Model_ID], [Fan_Boyutu], [Baglanti_Arayuzu], [Fan_Hizi], [Fiyat], [Stok_Miktari]) VALUES (10, 31, 42, 120, N'3-pin', 2000, CAST(49.99 AS Decimal(10, 2)), 5)
SET IDENTITY_INSERT [dbo].[Fan] OFF
GO
SET IDENTITY_INSERT [dbo].[FanSatis] ON 

INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-05-03' AS Date), 3)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2024-05-04' AS Date), 1)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2024-05-05' AS Date), 2)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[FanSatis] ([FanSatis_ID], [Musteri_ID], [Fan_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-07' AS Date), 1)
SET IDENTITY_INSERT [dbo].[FanSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[HDD] ON 

INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (1, 32, 43, 2000, N'SATA', 7200, CAST(299.99 AS Decimal(10, 2)), 50)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (2, 33, 44, 1000, N'SATA', 7200, CAST(149.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (3, 34, 45, 3000, N'SATA', 7200, CAST(249.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (4, 35, 46, 500, N'SATA', 7200, CAST(99.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (5, 36, 47, 2000, N'SATA', 7200, CAST(199.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (6, 37, 48, 4000, N'SATA', 7200, CAST(399.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (7, 38, 49, 8000, N'SATA', 7200, CAST(599.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (8, 33, 50, 6000, N'SATA', 5400, CAST(499.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (9, 34, 51, 10000, N'SATA', 7200, CAST(899.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[HDD] ([HDD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Donus_Hizi], [Fiyat], [Stok_Miktari]) VALUES (10, 35, 52, 2000, N'SATA', 5400, CAST(129.99 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[HDD] OFF
GO
SET IDENTITY_INSERT [dbo].[HDDSatis] ON 

INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2022-05-01' AS Date), 1)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2023-05-02' AS Date), 2)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2022-05-03' AS Date), 3)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2023-05-04' AS Date), 1)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2022-05-05' AS Date), 2)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-02-07' AS Date), 1)
INSERT [dbo].[HDDSatis] ([HDDSatis_ID], [Musteri_ID], [HDD_ID], [SatisTarihi], [Personel_ID]) VALUES (8, 8, 8, CAST(N'2024-05-08' AS Date), 2)
SET IDENTITY_INSERT [dbo].[HDDSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[Islemci] ON 

INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (1, 15, 53, N'LGA1200', 10, CAST(3.70 AS Decimal(5, 2)), CAST(2599.99 AS Decimal(10, 2)), 50)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (2, 16, 54, N'AM4', 16, CAST(4.90 AS Decimal(5, 2)), CAST(4499.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (3, 15, 55, N'LGA1200', 8, CAST(3.80 AS Decimal(5, 2)), CAST(1499.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (4, 16, 56, N'AM4', 8, CAST(4.70 AS Decimal(5, 2)), CAST(999.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (5, 15, 57, N'LGA1200', 6, CAST(4.10 AS Decimal(5, 2)), CAST(699.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (6, 16, 58, N'AM4', 6, CAST(4.60 AS Decimal(5, 2)), CAST(399.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (7, 15, 59, N'LGA1200', 4, CAST(3.60 AS Decimal(5, 2)), CAST(299.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (8, 16, 60, N'AM4', 4, CAST(4.30 AS Decimal(5, 2)), CAST(199.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (9, 15, 61, N'LGA1200', 2, CAST(4.00 AS Decimal(5, 2)), CAST(99.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[Islemci] ([Islemci_ID], [Marka_ID], [Model_ID], [Soket_Turu], [Cekirdek_Sayisi], [Islemci_Hizi], [Fiyat], [Stok_Miktari]) VALUES (10, 16, 62, N'AM4', 2, CAST(3.50 AS Decimal(5, 2)), CAST(69.99 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[Islemci] OFF
GO
SET IDENTITY_INSERT [dbo].[IslemciSatis] ON 

INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 4, 5, CAST(N'2024-05-04' AS Date), 1)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 7, 6, CAST(N'2024-05-07' AS Date), 1)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 3, 2, CAST(N'2024-05-03' AS Date), 3)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[IslemciSatis] ([IslemciSatis_ID], [Musteri_ID], [Islemci_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 5, 4, CAST(N'2024-05-05' AS Date), 2)
SET IDENTITY_INSERT [dbo].[IslemciSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[Markalar] ON 

INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (1, N'Corsair')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (2, N'EVGA')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (3, N'Seasonic')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (4, N'Thermaltake')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (5, N'Cooler Master')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (6, N'be quiet!')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (7, N'NZXT')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (8, N'SilverStone')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (9, N'Antec')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (10, N'FSP')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (11, N'Phanteks')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (12, N'Fractal Design')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (13, N'Lian Li')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (14, N'SilverStone')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (15, N'Intel')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (16, N'AMD')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (17, N'MSI')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (18, N'Gigabyte')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (19, N'ASUS')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (20, N'EVGA')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (21, N'ZOTAC')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (22, N'Sapphire')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (23, N'PowerColor')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (24, N'PNY')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (25, N'XFX')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (26, N'Colorful')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (27, N'Noctua')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (28, N'ARCTIC')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (29, N'Deepcool')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (30, N'Phanteks')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (31, N'Antec')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (32, N'Seagate')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (33, N'WD')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (34, N'Toshiba')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (35, N'Samsung')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (36, N'Hitachi')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (37, N'HGST')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (38, N'Seagate')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (39, N'Kingston')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (40, N'G.Skill')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (41, N'Crucial')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (42, N'ADATA')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (43, N'TeamGroup')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (44, N'Patriot')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (45, N'HyperX')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (46, N'Transcend')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (47, N'SanDisk')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (48, N'EmirinMarkasi')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (49, N'yakup')
INSERT [dbo].[Markalar] ([Marka_ID], [Marka_Adi]) VALUES (50, N'marka_adý')
SET IDENTITY_INSERT [dbo].[Markalar] OFF
GO
SET IDENTITY_INSERT [dbo].[Modeller] ON 

INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (1, N'RM750x')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (2, N'SuperNOVA 850 G5')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (3, N'Focus GX-650')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (4, N'Smart 500W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (5, N'MWE Gold 750 V2')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (6, N'Straight Power 11 650W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (7, N'C750')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (8, N'SST-ET750-G')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (9, N'EarthWatts Gold Pro 750W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (10, N'Hydro G PRO 750W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (11, N'Crystal 570X RGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (12, N'H510')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (13, N'Eclipse P300A Mesh')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (14, N'Meshify C')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (15, N'MasterBox MB520 ARGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (16, N'LANCOOL II MESH RGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (17, N'Versa H18')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (18, N'Pure Base 500DX')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (19, N'NX400')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (20, N'Sugo SG13')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (21, N'r5 5500')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (22, N'i3 12800h')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (23, N'GeForce GTX 1660 Ti')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (24, N'Radeon RX 570')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (25, N'ROG Strix GeForce RTX 2080 Ti')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (26, N'GeForce RTX 3060')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (27, N'GeForce GTX 1050 Ti Mini')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (28, N'Nitro+ Radeon RX 6700 XT')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (29, N'Red Devil Radeon RX 6800')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (30, N'XLR8 Gaming GeForce RTX 3060 Ti')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (31, N'Speedster QICK319 Radeon RX 6900 XT')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (32, N'iGame GeForce RTX 3080')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (33, N'NF-F12')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (34, N'ML120 Pro')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (35, N'AER RGB 2')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (36, N'MasterFan MF120R ARGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (37, N'Silent Wings 3')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (38, N'Pure Plus 12 RGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (39, N'P12 PWM PST')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (40, N'RF120M')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (41, N'PH-F120MP')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (42, N'Prizm 120 ARGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (43, N'BarraCuda')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (44, N'Blue')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (45, N'P300')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (46, N'Spinpoint F3')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (47, N'Deskstar 7K3000')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (48, N'Ultrastar 7K4000')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (49, N'IronWolf')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (50, N'Red')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (51, N'N300')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (52, N'Spinpoint F4')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (53, N'Core i9-10900K')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (54, N'Ryzen 9 5950X')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (55, N'Core i7-10700K')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (56, N'Ryzen 7 5800X')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (57, N'Core i5-10600K')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (58, N'Ryzen 5 5600X')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (59, N'Core i3-10100')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (60, N'Ryzen 3 3300X')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (61, N'Pentium Gold G6400')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (62, N'Athlon 3000G')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (63, N'RM750x')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (64, N'SuperNOVA 850 G5')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (65, N'Focus GX-650')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (66, N'Smart 500W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (67, N'MWE Gold 750 V2')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (68, N'Straight Power 11 650W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (69, N'C750')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (70, N'SST-ET750-G')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (71, N'EarthWatts Gold Pro 750W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (72, N'Hydro G PRO 750W')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (73, N'Vengeance LPX')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (74, N'HyperX Fury')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (75, N'Ripjaws V Series')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (76, N'Ballistix Elite')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (77, N'XPG Spectrix D40')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (78, N'T-Force Delta RGB')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (79, N'Viper Steel Series')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (80, N'Impact')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (81, N'JetRam')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (82, N'Crucial Ballistix Sport LT')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (83, N'970 EVO Plus')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (84, N'MX500')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (85, N'Blue SN550')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (86, N'A2000')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (87, N'XPG SX8200 Pro')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (88, N'Ultra 3D')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (89, N'CS900')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (90, N'FireCuda 520')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (91, N'MP33')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (92, N'AORUS RGB M.2 NVMe SSD')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (93, N'yas')
INSERT [dbo].[Modeller] ([Model_ID], [Model_Adi]) VALUES (94, N'model_adý')
SET IDENTITY_INSERT [dbo].[Modeller] OFF
GO
SET IDENTITY_INSERT [dbo].[Musteri] ON 

INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (1, N'Emir', N'Erguler', N'5552221112', N'emir3@gmail.con', N'Balçova , Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (2, N'Yakup', N'Ceri', N'5522368410', N'emir2@gmail.con', N'Gazemir , Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (3, N'Emir', N'Çingüler', N'5555555555', N'emir@gmail.con', N'Bornova , Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (4, N'yakup', N'emir', N'5521368410', N'asdasas@gmail.com', N'Buca , Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (5, N'yakup', N'emir', N'5502368410', N'asdas@gmail.com', N'Buca , Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (6, N'YeniAd', N'YeniSoyad', N'5551234567', N'yeni@email.com', N'Yeni Adres')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (7, N'Elif', N'Arslan', N'5551034567', N'elif@gmail.com', N'Ýzmir, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (8, N'Can', N'Özdemir', N'5329876543', N'can@gmail.com', N'Ankara, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (9, N'Yasemin', N'Kurtuluþ', N'5441112233', N'yasemin@gmail.com', N'Ýstanbul, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (10, N'Kaan', N'Turan', N'5053334455', N'kaan@gmail.com', N'Antalya, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (11, N'Ebru', N'Þahin', N'5372223344', N'ebru@gmail.com', N'Bursa, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (12, N'Burak', N'Yýlmaz', N'5304445566', N'burak@gmail.com', N'Adana, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (13, N'Gizem', N'Çetin', N'5495556677', N'gizem@gmail.com', N'Diyarbakýr, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (14, N'Deniz', N'Karadað', N'5386667788', N'deniz@gmail.com', N'Ýzmit, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (15, N'Þevval', N'Durmaz', N'5317778899', N'sevval@gmail.com', N'Eskiþehir, Türkiye')
INSERT [dbo].[Musteri] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres]) VALUES (16, N'Tolga', N'Kaya', N'5528889900', N'tolga@gmail.com', N'Konya, Türkiye')
SET IDENTITY_INSERT [dbo].[Musteri] OFF
GO
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (1, N'Emir', N'Erguler', N'5552221112', N'emir3@gmail.con', N'Balçova , Türkiye', NULL, NULL, NULL)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (2, N'Yakup', N'Ceri', N'5522368410', N'emir2@gmail.con', N'Gazemir , Türkiye', NULL, NULL, NULL)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (4, N'yakup', N'emir', N'5521368410', N'asdasas@gmail.com', N'Buca , Türkiye', NULL, NULL, NULL)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (8, N'Can', N'Özdemir', N'5329876543', N'can@gmail.com', N'Ankara, Türkiye', NULL, NULL, NULL)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (10, N'Kaan', N'Turan', N'5053334455', N'kaan@gmail.com', N'Antalya, Türkiye', NULL, NULL, NULL)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (19, N'YeniAd', N'YeniSoyad', N'5551234567', N'yeni@email.com', N'Yeni Adres', CAST(N'2024-05-11T23:34:19.527' AS DateTime), N'sa', 1)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (21, N'Elif', N'Arslan', N'5551034567', N'elif@gmail.com', N'Ýzmir, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (22, N'Can', N'Özdemir', N'5329876543', N'can@gmail.com', N'Ankara, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (23, N'Yasemin', N'Kurtuluþ', N'5441112233', N'yasemin@gmail.com', N'Ýstanbul, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (24, N'Kaan', N'Turan', N'5053334455', N'kaan@gmail.com', N'Antalya, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (25, N'Ebru', N'Þahin', N'5372223344', N'ebru@gmail.com', N'Bursa, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (26, N'Burak', N'Yýlmaz', N'5304445566', N'burak@gmail.com', N'Adana, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (27, N'Gizem', N'Çetin', N'5495556677', N'gizem@gmail.com', N'Diyarbakýr, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (28, N'Deniz', N'Karadað', N'5386667788', N'deniz@gmail.com', N'Ýzmit, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (29, N'Þevval', N'Durmaz', N'5317778899', N'sevval@gmail.com', N'Eskiþehir, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
INSERT [dbo].[Musteri_Yedek] ([Musteri_ID], [Ad], [Soyad], [Telefon], [Email], [Adres], [Sistem_Tarihi], [Atan_Kullanici], [Silinme_Durumu]) VALUES (30, N'Tolga', N'Kaya', N'5528889900', N'tolga@gmail.com', N'Konya, Türkiye', CAST(N'2024-05-12T16:19:51.403' AS DateTime), N'sa', 0)
GO
SET IDENTITY_INSERT [dbo].[Personel] ON 

INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (1, N'Berkay', N'Þahin', CAST(N'2000-10-22' AS Date), N'Evli', 35400.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (2, N'Ahmet', N'Yýlmaz', CAST(N'2022-01-15' AS Date), N'Bekar', 50000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (3, N'Ayþe', N'Kaya', CAST(N'2023-03-20' AS Date), N'Belirtilmedi', 48000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (4, N'Mehmet', N'Demir', CAST(N'2023-07-10' AS Date), N'Belirtilmedi', 52000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (5, N'Fatma', N'Öztürk', CAST(N'2024-02-05' AS Date), N'Bekar', 52000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (6, N'Mustafa', N'Kara', CAST(N'2022-11-30' AS Date), N'Evli', 53000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (7, N'Zeynep', N'Þahin', CAST(N'2023-09-25' AS Date), N'Bekar', 51020.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (8, N'Emine', N'Yýldýrým', CAST(N'2024-01-10' AS Date), N'Evli', 49200.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (9, N'Ali', N'Aktaþ', CAST(N'2023-06-12' AS Date), N'Evli', 54000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (10, N'Hatice', N'Çelik', CAST(N'2022-04-18' AS Date), N'Belirtilmedi', 47000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (11, N'Ýbrahim', N'Güneþ', CAST(N'2024-04-03' AS Date), N'Belirtilmedi', 45000.0000)
INSERT [dbo].[Personel] ([Personel_ID], [Ad], [Soyad], [IseBaslamaTarihi], [Medeni_Durum], [Maas]) VALUES (12, N'Yakup', N'Çeri', CAST(N'2022-08-15' AS Date), N'Belirtilmedi', 70000.0000)
SET IDENTITY_INSERT [dbo].[Personel] OFF
GO
SET IDENTITY_INSERT [dbo].[PSU] ON 

INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (1, 1, 63, 750, N'80 Plus Gold', CAST(199.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (2, 2, 64, 850, N'80 Plus Gold', CAST(229.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (3, 3, 65, 650, N'80 Plus Gold', CAST(149.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (4, 4, 66, 500, N'80 Plus White', CAST(59.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (5, 5, 67, 750, N'80 Plus Gold', CAST(169.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (6, 6, 68, 650, N'80 Plus Gold', CAST(179.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (7, 7, 69, 750, N'80 Plus Gold', CAST(129.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (8, 8, 70, 750, N'80 Plus Gold', CAST(139.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (9, 9, 71, 750, N'80 Plus Gold', CAST(129.99 AS Decimal(10, 2)), 22)
INSERT [dbo].[PSU] ([PSU_ID], [Marka_ID], [Model_ID], [Watt_Deðeri], [Verimlilik_Sýnýfý], [Fiyat], [Stok_Miktari]) VALUES (10, 10, 72, 750, N'80 Plus Gold', CAST(159.99 AS Decimal(10, 2)), 28)
SET IDENTITY_INSERT [dbo].[PSU] OFF
GO
SET IDENTITY_INSERT [dbo].[PSUSatis] ON 

INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2023-05-01' AS Date), 1)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-02' AS Date), 2)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-02-03' AS Date), 3)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2021-01-04' AS Date), 1)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2022-05-05' AS Date), 2)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-06' AS Date), 3)
INSERT [dbo].[PSUSatis] ([PSUSatis_ID], [Musteri_ID], [PSU_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-07' AS Date), 1)
SET IDENTITY_INSERT [dbo].[PSUSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[Ram] ON 

INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (1, 1, 73, 16, 3200, CAST(699.99 AS Decimal(10, 2)), 50)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (2, 39, 74, 8, 2666, CAST(399.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (3, 40, 75, 32, 3600, CAST(1499.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (4, 41, 76, 16, 4000, CAST(799.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (5, 42, 77, 32, 3000, CAST(1299.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (6, 43, 78, 16, 3200, CAST(899.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (7, 44, 79, 8, 3000, CAST(299.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (8, 45, 80, 16, 2666, CAST(599.99 AS Decimal(10, 2)), 45)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (9, 46, 81, 8, 2400, CAST(199.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[Ram] ([Ram_ID], [Marka_ID], [Model_ID], [Kapasite], [Hiz], [Fiyat], [Stok_Miktari]) VALUES (10, 35, 82, 8, 3000, CAST(349.99 AS Decimal(10, 2)), 50)
SET IDENTITY_INSERT [dbo].[Ram] OFF
GO
SET IDENTITY_INSERT [dbo].[RamSatis] ON 

INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-03' AS Date), 2)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-05-05' AS Date), 3)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2024-05-07' AS Date), 1)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2024-05-09' AS Date), 2)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-11' AS Date), 3)
INSERT [dbo].[RamSatis] ([RamSatis_ID], [Musteri_ID], [Ram_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-13' AS Date), 1)
SET IDENTITY_INSERT [dbo].[RamSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[SSD] ON 

INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (1, 35, 83, 500, N'NVMe', 3500, 3300, CAST(599.99 AS Decimal(10, 2)), 50)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (2, 41, 84, 1, N'SATA', 560, 510, CAST(199.99 AS Decimal(10, 2)), 30)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (3, 33, 85, 1, N'NVMe', 2400, 1950, CAST(249.99 AS Decimal(10, 2)), 25)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (4, 39, 86, 500, N'NVMe', 2200, 2000, CAST(119.99 AS Decimal(10, 2)), 40)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (5, 42, 87, 1, N'NVMe', 3500, 3000, CAST(299.99 AS Decimal(10, 2)), 35)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (6, 47, 88, 1, N'SATA', 560, 530, CAST(179.99 AS Decimal(10, 2)), 20)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (7, 24, 89, 250, N'SATA', 515, 490, CAST(59.99 AS Decimal(10, 2)), 15)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (8, 38, 90, 1, N'NVMe', 5000, 4400, CAST(399.99 AS Decimal(10, 2)), 10)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (9, 43, 91, 512, N'NVMe', 2100, 1700, CAST(99.99 AS Decimal(10, 2)), 18)
INSERT [dbo].[SSD] ([SSD_ID], [Marka_ID], [Model_ID], [Kapasite], [Baglanti_Turu], [Okuma_Hizi], [Yazma_Hizi], [Fiyat], [Stok_Miktari]) VALUES (10, 18, 92, 1, N'NVMe', 5000, 4400, CAST(479.99 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[SSD] OFF
GO
SET IDENTITY_INSERT [dbo].[SSDSatis] ON 

INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (2, 2, 3, CAST(N'2024-05-03' AS Date), 2)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (3, 3, 2, CAST(N'2024-05-05' AS Date), 3)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (4, 4, 5, CAST(N'2024-05-07' AS Date), 1)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (5, 5, 4, CAST(N'2024-05-09' AS Date), 2)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (6, 6, 7, CAST(N'2024-05-11' AS Date), 3)
INSERT [dbo].[SSDSatis] ([SSDSatis_ID], [Musteri_ID], [SSD_ID], [SatisTarihi], [Personel_ID]) VALUES (7, 7, 6, CAST(N'2024-05-13' AS Date), 1)
SET IDENTITY_INSERT [dbo].[SSDSatis] OFF
GO
SET IDENTITY_INSERT [dbo].[ToplamaPC] ON 

INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (1, 1, 1, CAST(N'2024-05-01' AS Date), 1, 1, 1, 1, 1, 1, 1, 1, 1, CAST(30500 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (2, 2, 2, CAST(N'2024-05-02' AS Date), 2, 2, 2, 2, 2, 2, 2, 2, 2, CAST(12300 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (3, 3, 3, CAST(N'2024-05-03' AS Date), 3, 3, 3, 3, 3, 3, 3, 3, 3, CAST(27200 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (4, 4, 1, CAST(N'2024-05-04' AS Date), 4, 4, 4, 4, 4, 4, 4, 4, 4, CAST(12400 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (5, 5, 2, CAST(N'2024-05-05' AS Date), 5, 5, 5, 5, 5, 5, 5, 5, 5, CAST(12800 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (6, 6, 3, CAST(N'2024-05-06' AS Date), 6, 6, 6, 6, 6, 6, 6, 6, 6, CAST(26200 AS Decimal(12, 0)))
INSERT [dbo].[ToplamaPC] ([ToplamaPC_ID], [Musteri_ID], [Personel_ID], [Tarih], [Anakart_ID], [Kasa_ID], [EkranKarti_ID], [Fan_ID], [HDD_ID], [Islemci_ID], [PSU_ID], [Ram_ID], [SSD_ID], [Fiyat]) VALUES (7, 7, 1, CAST(N'2024-05-07' AS Date), 7, 7, 7, 7, 7, 7, 7, 7, 7, CAST(22800 AS Decimal(12, 0)))
SET IDENTITY_INSERT [dbo].[ToplamaPC] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Musteri_Email]    Script Date: 12.05.2024 17:10:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_Musteri_Email] ON [dbo].[Musteri]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Musteri_Telefon]    Script Date: 12.05.2024 17:10:13 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_Musteri_Telefon] ON [dbo].[Musteri]
(
	[Telefon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Personel] ADD  CONSTRAINT [DF_Personel_Medeni_Durum]  DEFAULT (N'Belirtilmedi') FOR [Medeni_Durum]
GO
ALTER TABLE [dbo].[Anakart]  WITH CHECK ADD  CONSTRAINT [FK_Anakart_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[Anakart] CHECK CONSTRAINT [FK_Anakart_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[Anakart]  WITH CHECK ADD  CONSTRAINT [FK_Anakart_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[Anakart] CHECK CONSTRAINT [FK_Anakart_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[AnakartSatis]  WITH CHECK ADD  CONSTRAINT [FK_AnakartSatis_Anakart/Anakart_ID] FOREIGN KEY([Anakart_ID])
REFERENCES [dbo].[Anakart] ([Anakart_ID])
GO
ALTER TABLE [dbo].[AnakartSatis] CHECK CONSTRAINT [FK_AnakartSatis_Anakart/Anakart_ID]
GO
ALTER TABLE [dbo].[AnakartSatis]  WITH CHECK ADD  CONSTRAINT [FK_AnakartSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[AnakartSatis] CHECK CONSTRAINT [FK_AnakartSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[AnakartSatis]  WITH CHECK ADD  CONSTRAINT [FK_AnakartSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[AnakartSatis] CHECK CONSTRAINT [FK_AnakartSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[BilgisayarKasasi]  WITH CHECK ADD  CONSTRAINT [FK_BilgisayarKasasi_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[BilgisayarKasasi] CHECK CONSTRAINT [FK_BilgisayarKasasi_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[BilgisayarKasasi]  WITH CHECK ADD  CONSTRAINT [FK_BilgisayarKasasi_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[BilgisayarKasasi] CHECK CONSTRAINT [FK_BilgisayarKasasi_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis]  WITH CHECK ADD  CONSTRAINT [FK_BilgisayarKasasiSatis_BilgisayarKasasi/Kasa_ID] FOREIGN KEY([Kasa_ID])
REFERENCES [dbo].[BilgisayarKasasi] ([Kasa_ID])
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis] CHECK CONSTRAINT [FK_BilgisayarKasasiSatis_BilgisayarKasasi/Kasa_ID]
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis]  WITH CHECK ADD  CONSTRAINT [FK_BilgisayarKasasiSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis] CHECK CONSTRAINT [FK_BilgisayarKasasiSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis]  WITH CHECK ADD  CONSTRAINT [FK_BilgisayarKasasiSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[BilgisayarKasasiSatis] CHECK CONSTRAINT [FK_BilgisayarKasasiSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[EkranKarti]  WITH CHECK ADD  CONSTRAINT [FK_EkranKarti_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[EkranKarti] CHECK CONSTRAINT [FK_EkranKarti_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[EkranKarti]  WITH CHECK ADD  CONSTRAINT [FK_EkranKarti_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[EkranKarti] CHECK CONSTRAINT [FK_EkranKarti_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[EkranKartiSatis]  WITH CHECK ADD  CONSTRAINT [FK_EkranKartiSatis_EkranKarti/EkranKarti_ID] FOREIGN KEY([EkranKarti_ID])
REFERENCES [dbo].[EkranKarti] ([EkranKarti_ID])
GO
ALTER TABLE [dbo].[EkranKartiSatis] CHECK CONSTRAINT [FK_EkranKartiSatis_EkranKarti/EkranKarti_ID]
GO
ALTER TABLE [dbo].[EkranKartiSatis]  WITH CHECK ADD  CONSTRAINT [FK_EkranKartiSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[EkranKartiSatis] CHECK CONSTRAINT [FK_EkranKartiSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[EkranKartiSatis]  WITH CHECK ADD  CONSTRAINT [FK_EkranKartiSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[EkranKartiSatis] CHECK CONSTRAINT [FK_EkranKartiSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[Fan]  WITH CHECK ADD  CONSTRAINT [FK_Fan_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[Fan] CHECK CONSTRAINT [FK_Fan_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[Fan]  WITH CHECK ADD  CONSTRAINT [FK_Fan_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[Fan] CHECK CONSTRAINT [FK_Fan_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[FanSatis]  WITH CHECK ADD  CONSTRAINT [FK_FanSatis_Fan/Fan_ID] FOREIGN KEY([Fan_ID])
REFERENCES [dbo].[Fan] ([Fan_ID])
GO
ALTER TABLE [dbo].[FanSatis] CHECK CONSTRAINT [FK_FanSatis_Fan/Fan_ID]
GO
ALTER TABLE [dbo].[FanSatis]  WITH CHECK ADD  CONSTRAINT [FK_FanSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[FanSatis] CHECK CONSTRAINT [FK_FanSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[FanSatis]  WITH CHECK ADD  CONSTRAINT [FK_FanSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[FanSatis] CHECK CONSTRAINT [FK_FanSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[HDD]  WITH CHECK ADD  CONSTRAINT [FK_HDD_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[HDD] CHECK CONSTRAINT [FK_HDD_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[HDD]  WITH CHECK ADD  CONSTRAINT [FK_HDD_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[HDD] CHECK CONSTRAINT [FK_HDD_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[HDDSatis]  WITH CHECK ADD  CONSTRAINT [FK_HDDSatis_HDD/HDD_ID] FOREIGN KEY([HDD_ID])
REFERENCES [dbo].[HDD] ([HDD_ID])
GO
ALTER TABLE [dbo].[HDDSatis] CHECK CONSTRAINT [FK_HDDSatis_HDD/HDD_ID]
GO
ALTER TABLE [dbo].[HDDSatis]  WITH CHECK ADD  CONSTRAINT [FK_HDDSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[HDDSatis] CHECK CONSTRAINT [FK_HDDSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[HDDSatis]  WITH CHECK ADD  CONSTRAINT [FK_HDDSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[HDDSatis] CHECK CONSTRAINT [FK_HDDSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[Islemci]  WITH CHECK ADD  CONSTRAINT [FK_Islemci_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[Islemci] CHECK CONSTRAINT [FK_Islemci_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[Islemci]  WITH CHECK ADD  CONSTRAINT [FK_Islemci_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[Islemci] CHECK CONSTRAINT [FK_Islemci_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[IslemciSatis]  WITH CHECK ADD  CONSTRAINT [FK_IslemciSatis_Islemci/Islemci_ID] FOREIGN KEY([Islemci_ID])
REFERENCES [dbo].[Islemci] ([Islemci_ID])
GO
ALTER TABLE [dbo].[IslemciSatis] CHECK CONSTRAINT [FK_IslemciSatis_Islemci/Islemci_ID]
GO
ALTER TABLE [dbo].[IslemciSatis]  WITH CHECK ADD  CONSTRAINT [FK_IslemciSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[IslemciSatis] CHECK CONSTRAINT [FK_IslemciSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[IslemciSatis]  WITH CHECK ADD  CONSTRAINT [FK_IslemciSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[IslemciSatis] CHECK CONSTRAINT [FK_IslemciSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[PSU]  WITH CHECK ADD  CONSTRAINT [FK_PSU_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[PSU] CHECK CONSTRAINT [FK_PSU_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[PSU]  WITH CHECK ADD  CONSTRAINT [FK_PSU_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[PSU] CHECK CONSTRAINT [FK_PSU_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[PSUSatis]  WITH CHECK ADD  CONSTRAINT [FK_PSUSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[PSUSatis] CHECK CONSTRAINT [FK_PSUSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[PSUSatis]  WITH CHECK ADD  CONSTRAINT [FK_PSUSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[PSUSatis] CHECK CONSTRAINT [FK_PSUSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[PSUSatis]  WITH CHECK ADD  CONSTRAINT [FK_PSUSatis_PSU/PSU_ID] FOREIGN KEY([PSU_ID])
REFERENCES [dbo].[PSU] ([PSU_ID])
GO
ALTER TABLE [dbo].[PSUSatis] CHECK CONSTRAINT [FK_PSUSatis_PSU/PSU_ID]
GO
ALTER TABLE [dbo].[Ram]  WITH CHECK ADD  CONSTRAINT [FK_Ram_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[Ram] CHECK CONSTRAINT [FK_Ram_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[Ram]  WITH CHECK ADD  CONSTRAINT [FK_Ram_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[Ram] CHECK CONSTRAINT [FK_Ram_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[RamSatis]  WITH CHECK ADD  CONSTRAINT [FK_RamSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[RamSatis] CHECK CONSTRAINT [FK_RamSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[RamSatis]  WITH CHECK ADD  CONSTRAINT [FK_RamSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[RamSatis] CHECK CONSTRAINT [FK_RamSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[RamSatis]  WITH CHECK ADD  CONSTRAINT [FK_RamSatis_Ram/Ram_ID] FOREIGN KEY([Ram_ID])
REFERENCES [dbo].[Ram] ([Ram_ID])
GO
ALTER TABLE [dbo].[RamSatis] CHECK CONSTRAINT [FK_RamSatis_Ram/Ram_ID]
GO
ALTER TABLE [dbo].[SSD]  WITH CHECK ADD  CONSTRAINT [FK_SSD_Markalar/Marka_ID] FOREIGN KEY([Marka_ID])
REFERENCES [dbo].[Markalar] ([Marka_ID])
GO
ALTER TABLE [dbo].[SSD] CHECK CONSTRAINT [FK_SSD_Markalar/Marka_ID]
GO
ALTER TABLE [dbo].[SSD]  WITH CHECK ADD  CONSTRAINT [FK_SSD_Modeller/Model_ID] FOREIGN KEY([Model_ID])
REFERENCES [dbo].[Modeller] ([Model_ID])
GO
ALTER TABLE [dbo].[SSD] CHECK CONSTRAINT [FK_SSD_Modeller/Model_ID]
GO
ALTER TABLE [dbo].[SSDSatis]  WITH CHECK ADD  CONSTRAINT [FK_SSDSatis_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[SSDSatis] CHECK CONSTRAINT [FK_SSDSatis_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[SSDSatis]  WITH CHECK ADD  CONSTRAINT [FK_SSDSatis_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[SSDSatis] CHECK CONSTRAINT [FK_SSDSatis_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[SSDSatis]  WITH CHECK ADD  CONSTRAINT [FK_SSDSatis_SSD/SSD_ID] FOREIGN KEY([SSD_ID])
REFERENCES [dbo].[SSD] ([SSD_ID])
GO
ALTER TABLE [dbo].[SSDSatis] CHECK CONSTRAINT [FK_SSDSatis_SSD/SSD_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Anakart/Anakart_ID] FOREIGN KEY([Anakart_ID])
REFERENCES [dbo].[Anakart] ([Anakart_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Anakart/Anakart_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_BilgisayarKasasi/Kasa_ID] FOREIGN KEY([Kasa_ID])
REFERENCES [dbo].[BilgisayarKasasi] ([Kasa_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_BilgisayarKasasi/Kasa_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_EkranKarti/EktanKarti_ID] FOREIGN KEY([EkranKarti_ID])
REFERENCES [dbo].[EkranKarti] ([EkranKarti_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_EkranKarti/EktanKarti_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Fan/Fan_ID] FOREIGN KEY([Fan_ID])
REFERENCES [dbo].[Fan] ([Fan_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Fan/Fan_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_HDD/HDD_ID] FOREIGN KEY([HDD_ID])
REFERENCES [dbo].[HDD] ([HDD_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_HDD/HDD_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Islemci/Islemci_ID] FOREIGN KEY([Islemci_ID])
REFERENCES [dbo].[Islemci] ([Islemci_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Islemci/Islemci_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Musteri/Musteri_ID] FOREIGN KEY([Musteri_ID])
REFERENCES [dbo].[Musteri] ([Musteri_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Musteri/Musteri_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Personel/Personel_ID] FOREIGN KEY([Personel_ID])
REFERENCES [dbo].[Personel] ([Personel_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Personel/Personel_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_PSU/PSU_ID] FOREIGN KEY([PSU_ID])
REFERENCES [dbo].[PSU] ([PSU_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_PSU/PSU_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_Ram/Ram_ID] FOREIGN KEY([Ram_ID])
REFERENCES [dbo].[Ram] ([Ram_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_Ram/Ram_ID]
GO
ALTER TABLE [dbo].[ToplamaPC]  WITH CHECK ADD  CONSTRAINT [FK_ToplamaPC_SSD/SSD_ID] FOREIGN KEY([SSD_ID])
REFERENCES [dbo].[SSD] ([SSD_ID])
GO
ALTER TABLE [dbo].[ToplamaPC] CHECK CONSTRAINT [FK_ToplamaPC_SSD/SSD_ID]
GO
ALTER TABLE [dbo].[Musteri]  WITH CHECK ADD  CONSTRAINT [CK_Musteri_Telefon] CHECK  (([Telefon]>=(1000000000.) AND [telefon]<=(9999999999.)))
GO
ALTER TABLE [dbo].[Musteri] CHECK CONSTRAINT [CK_Musteri_Telefon]
GO
ALTER TABLE [dbo].[Personel]  WITH CHECK ADD  CONSTRAINT [CK_Personel_Medeni_Durum] CHECK  (([Medeni_Durum]='Evli' OR [Medeni_Durum]='Bekar' OR [Medeni_Durum]='Belirtilmedi'))
GO
ALTER TABLE [dbo].[Personel] CHECK CONSTRAINT [CK_Personel_Medeni_Durum]
GO
/****** Object:  StoredProcedure [dbo].[sp_ArdisikUcKayitEkleme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ArdisikUcKayitEkleme]
(
    @ad nvarchar(70),
    @soyad nvarchar(40),
    @telefon nvarchar(11),
    @email nvarchar(100),
    @adres nvarchar(255),
    @model_ad nvarchar(255),
    @marka_ad nvarchar(255)
)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        EXEC sp_MusteriKayitEkleme @ad = @ad, @soyad = @soyad, @telefon = @telefon, @email = @email, @adres = @adres;
        EXEC sp_ModelKayitEkleme @Model_Ad = @model_ad;
        EXEC sp_MarkaKayitEkleme @Marka_Ad = @marka_ad;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_MarkaKayitEkleme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_MarkaKayitEkleme]
(
@Marka_Ad nvarchar(255)

)
as
begin
Insert into Markalar (Marka_Adi)
Values (@Marka_Ad)
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_ModelKayitEkleme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ModelKayitEkleme]
(
@Model_Ad nvarchar(255)
)
as
begin
Insert into Modeller(Model_Adi)
Values (@Model_Ad)
end 

GO
/****** Object:  StoredProcedure [dbo].[sp_MusteriKayitDegistirme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MusteriKayitDegistirme]
(
    @musteriID INT,
    @ad nvarchar(70),
    @soyad nvarchar(40),
    @telefon nvarchar(11),
    @email nvarchar(100),
    @adres nvarchar(255)
)
AS
BEGIN
    UPDATE Musteri
    SET Ad = @ad,
        Soyad = @soyad,
        Telefon = @telefon,
        Email = @email,
        Adres = @adres
    WHERE Musteri_ID = @musteriID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_MusteriKayitEkleme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_MusteriKayitEkleme]
(
@ad nvarchar(70),
@soyad nvarchar(40),
@telefon nvarchar(11),
@email nvarchar(100),
@adres nvarchar(255)
)
as
begin
Insert into Musteri (Ad , Soyad , Telefon , Email , Adres)
Values (@ad , @soyad , @telefon , @email , @adres)
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_MusteriKayitSilme]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MusteriKayitSilme]
(
    @musteriID INT
)
AS
BEGIN
    -- Belirtilen müþteri ID'sine sahip kaydý sil
    DELETE FROM Musteri WHERE Musteri_ID = @musteriID;
END;
GO
/****** Object:  Trigger [dbo].[TR_AFTER_INSERT]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_AFTER_INSERT]
ON [dbo].[Musteri]
AFTER INSERT
AS
BEGIN
    INSERT INTO Musteri_Yedek (Musteri_ID, Ad, Soyad, Telefon, Email, Adres, Sistem_Tarihi, Atan_Kullanici, Silinme_Durumu)
    SELECT Musteri_ID, Ad, Soyad, Telefon, Email, Adres, GETDATE(), SUSER_NAME(), 0
    FROM inserted;
END;
GO
ALTER TABLE [dbo].[Musteri] ENABLE TRIGGER [TR_AFTER_INSERT]
GO
/****** Object:  Trigger [dbo].[TR_AFTER_UPDATE]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_AFTER_UPDATE]
ON [dbo].[Musteri]
AFTER UPDATE
AS
BEGIN
    UPDATE Musteri_Yedek
    SET Ad = Musteri.Ad,
        Soyad = Musteri.Soyad,
        Telefon = Musteri.Telefon,
        Email = Musteri.Email,
        Adres = Musteri.Adres
    FROM Musteri_Yedek
    JOIN inserted ON Musteri_Yedek.Musteri_ID = inserted.Musteri_ID
    JOIN Musteri ON Musteri.Musteri_ID = inserted.Musteri_ID;
END;
GO
ALTER TABLE [dbo].[Musteri] ENABLE TRIGGER [TR_AFTER_UPDATE]
GO
/****** Object:  Trigger [dbo].[TR_INSTEAD_OF_DELETE]    Script Date: 12.05.2024 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_INSTEAD_OF_DELETE]
ON [dbo].[Musteri]
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Musteri_Yedek
    SET Silinme_Durumu = 1
    FROM Musteri_Yedek
    JOIN deleted ON Musteri_Yedek.Musteri_ID = deleted.Musteri_ID;
END;
GO
ALTER TABLE [dbo].[Musteri] ENABLE TRIGGER [TR_INSTEAD_OF_DELETE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Modeller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BilgisayarKasasi"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Full_Outer_Join/ModellerXBilgisiyarKasasi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Full_Outer_Join/ModellerXBilgisiyarKasasi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Modeller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Ram"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Inner_Join/ModellerXRam'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Inner_Join/ModellerXRam'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Musteri"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IslemciSatis"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Left_Outer_Join/MusteriXIslemciSatis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Left_Outer_Join/MusteriXIslemciSatis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Markalar"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PSU"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Right_Outer_Join/MarkalarXPSU'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Right_Outer_Join/MarkalarXPSU'
GO
USE [master]
GO
ALTER DATABASE [bilgisiyar] SET  READ_WRITE 
GO
