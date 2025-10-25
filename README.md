# 💻 Computer Store – SQL Server Veri Tabanı

Bu proje, bir bilgisayar mağazasının satış ve stok süreçlerini yönetmek amacıyla **Microsoft SQL Server** üzerinde tasarlanmış **ilişkisel veri tabanı** modelidir. Projede müşteri, personel, ürün, stok ve satış işlemleri; **3NF normalizasyon**, **transaction** ve **kısıtlama** (PK/FK/UNIQUE/CHECK) prensipleriyle modellenmiştir.

---

## 🎯 Amaç
- Ürün/Parça envanteri ve stok takibi  
- Müşteri ve personel yönetimi  
- Parçadan **Toplama PC** kurgusu  
- Satış süreçleri ve raporlama  
- Veri bütünlüğü ve güvenliği (ACID)

---

## 🧱 Teknik Özellikler
- **Veri Tabanı:** SQL Server  
- **Normalizasyon:** 3. Normal Form (3NF)  
- **İlişkiler:** `PRIMARY KEY` / `FOREIGN KEY`, `UNIQUE`, `CHECK`  
- **JOIN:** INNER / LEFT / RIGHT / FULL (görünümlerle)  
- **Transaction:** `BEGIN TRAN` – `COMMIT` – `ROLLBACK`  
- **Trigger:** INSERT / UPDATE / INSTEAD OF DELETE (Müşteri)  
- **Function:** `FN_MUSTERI_SAYISI`, `FN_STOK_FIYAT_TOPLAM`, `FN_PersonelMaasSec`, `FN_AnakartFiyatAraligi`  
- **View:** `Inner_Join/ModellerXRam`, `Left_Outer_Join/MusteriXIslemciSatis`, `Right_Outer_Join/MarkalarXPSU`, `Full_Outer_Join/ModellerXBilgisiyarKasasi`

  ## 📦 Tablo Özeti (seçilmişler)
- **Musteri**, **Personel**  
- **Markalar**, **Modeller**  
- Parça tablolari: **Anakart**, **Islemci**, **Ram**, **SSD**, **HDD**, **EkranKarti**, **PSU**, **Fan**, **BilgisayarKasasi**  
- Satış tablolari: **AnakartSatis**, **IslemciSatis**, **RamSatis**, **SSDSatis**, **HDDSatis**, **EkranKartiSatis**, **PSUSatis**, **BilgisayarKasasiSatis**  
- **ToplamaPC** (parçaların bir araya getirildiği yapı)  
- **Musteri_Yedek** (tetikleyiciler için yedek/log amaçlı)

Tam liste (24 tablo): `Personel, Modeller, BilgisayarKasasi, Anakart, Markalar, PSU, IslemciSatis, Musteri, Ram, AnakartSatis, BilgisayarKasasiSatis, EkranKarti, EkranKartiSatis, Fan, FanSatis, HDD, HDDSatis, Islemci, Musteri_Yedek, PSUSatis, RamSatis, SSD, SSDSatis, ToplamaPC`

---

### Trigger (INSERT sonrası yedekleme)
```sql
CREATE TRIGGER TR_AFTER_INSERT ON dbo.Musteri
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.Musteri_Yedek (Musteri_ID, Ad, Soyad, Adres, IslemTarihi, IslemKullanici, SilindiMi)
    SELECT i.Musteri_ID, i.Ad, i.Soyad, i.Adres, GETDATE(), SUSER_NAME(), 0
    FROM inserted i;
END;

```
🧮 Function Örneği (Toplam stok değeri hesaplama)
Function (Toplam stok değeri)
```
CREATE FUNCTION dbo.FN_STOK_FIYAT_TOPLAM()
RETURNS MONEY
AS
BEGIN
    RETURN (
        SELECT ISNULL(SUM(CAST(Fiyat AS MONEY)),0)
        FROM (
            SELECT Fiyat FROM dbo.Islemci
            UNION ALL SELECT Fiyat FROM dbo.Anakart
            UNION ALL SELECT Fiyat FROM dbo.Ram
            UNION ALL SELECT Fiyat FROM dbo.SSD
            UNION ALL SELECT Fiyat FROM dbo.HDD
            UNION ALL SELECT Fiyat FROM dbo.EkranKarti
            UNION ALL SELECT Fiyat FROM dbo.PSU
            UNION ALL SELECT Fiyat FROM dbo.Fan
            UNION ALL SELECT Fiyat FROM dbo.BilgisayarKasasi
        ) AS X
    );
END;
```
⚙️ Stored Procedure Örnekleri (Müşteri işlemleri)
```
EXEC dbo.sp_ArdisikUcKayitEkleme;
EXEC dbo.sp_MusteriKayitDegistirme @Musteri_ID=1, @Ad='Ali', @Soyad='Yılmaz';
EXEC dbo.sp_MusteriKayitSilme @Musteri_ID=5;
```
View (JOIN örnekleri)

- Inner_Join/ModellerXRam
- Left_Outer_Join/MusteriXIslemciSatis
- Right_Outer_Join/MarkalarXPSU
- Full_Outer_Join/ModellerXBilgisiyarKasasi

🚀 Kurulum & Çalıştırma
  
- SQL Server Management Studio (SSMS)’ı açın.
- Yeni bir veri tabanı oluşturun (örn. ComputerStoreDB).
- Depodaki computer-store-sql-database.sql dosyasını açın.
- Sırasıyla tablolar, kısıtlamalar, fonksiyonlar, görünümler, tetikleyiciler ve prosedürleri oluşturan scriptleri çalıştırın.
- Örnek veri/raporlama sorgularını çalıştırın.
İsteğe bağlı: BEGIN TRAN ile test edin, gerekirse ROLLBACK ile geri alın.








