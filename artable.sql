-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 08, 2026 at 04:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `artable`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `idCart` int(11) NOT NULL,
  `idUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`idCart`, `idUser`) VALUES
(1, 5),
(2, 6),
(3, 7),
(4, 8),
(5, 9);

-- --------------------------------------------------------

--
-- Table structure for table `cartitem`
--

CREATE TABLE `cartitem` (
  `idCartItem` int(11) NOT NULL,
  `idCart` int(11) NOT NULL,
  `idProduk` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `updateTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `idDetail` int(11) NOT NULL,
  `idTransaksi` int(11) NOT NULL,
  `idProduk` int(11) NOT NULL,
  `idSekolah` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `hargaSatuan` double NOT NULL,
  `buktiTransfer` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Menunggu Pembayaran',
  `noResi` varchar(100) DEFAULT NULL,
  `kurir` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `idNotifikasi` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `judul` varchar(255) DEFAULT NULL,
  `pesan` text DEFAULT NULL,
  `waktu` timestamp NULL DEFAULT current_timestamp(),
  `status` enum('read','unread') DEFAULT 'unread'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `idProduk` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `kategori` enum('FINE_ART','DIGITAL_ART','HANDMADE_ART','OTHERS') NOT NULL,
  `harga` double NOT NULL,
  `deskripsi` text NOT NULL,
  `stok` int(11) NOT NULL,
  `idSeniman` int(11) DEFAULT NULL,
  `uploadTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `imageUrl` varchar(2048) NOT NULL,
  `berat` double DEFAULT NULL,
  `dimensi` varchar(255) DEFAULT NULL,
  `material` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`idProduk`, `nama`, `kategori`, `harga`, `deskripsi`, `stok`, `idSeniman`, `uploadTime`, `imageUrl`, `berat`, `dimensi`, `material`) VALUES
(1, 'Potret Senyap', 'FINE_ART', 1500000, 'Lukisan realisme cat minyak yang menangkap ekspresi mendalam seorang laki-laki dalam keheningan.', 3, 1, '2026-01-08 02:07:52', 'assets/fotoProduk/potret_senyap.jpg', 1.2, '60x80x3 cm', 'Canvas & Oil Paint'),
(2, 'Tote Bag Handmade', 'HANDMADE_ART', 250000, 'Tote bag kanvas yang dilukis manual dengan motif floral yang detail dan eksklusif.', 5, 1, '2026-01-08 02:07:52', 'assets/fotoProduk/totebag_lukis.jpg', 0.25, '35x40x1 cm', 'Canvas Fabric'),
(3, 'Ruang Tanpa Batas', 'FINE_ART', 1800000, 'Karya abstrak ekspresionis yang menggunakan perpaduan tekstur kasar untuk menggambarkan emosi.', 2, 2, '2026-01-08 02:07:52', 'assets/fotoProduk/ruang_tanpa_batas.jpg', 1.5, '70x70x4 cm', 'Mixed Media on Canvas'),
(4, 'Art Journal Handmade', 'HANDMADE_ART', 200000, 'Buku jurnal dengan cover lukisan tangan orisinal, cocok untuk menuangkan inspirasi harian.', 8, 2, '2026-01-08 02:07:52', 'assets/fotoProduk/art_journal.jpg', 0.4, '15x21x2 cm', 'Recycled Paper & Acrylic'),
(5, 'Dreamscape City', 'DIGITAL_ART', 350000, 'Ilustrasi digital kota masa depan dengan permainan cahaya neon yang memukau.', 4, 3, '2026-01-08 02:07:52', 'assets/fotoProduk/dreamscape_city.jpg', 0.1, '29.7x42 cm', 'Digital Print on Art Paper'),
(6, 'Forest Spirit', 'DIGITAL_ART', 300000, 'Karya digital bertema fantasi yang menggambarkan penjaga hutan dalam balutan kabut.', 6, 3, '2026-01-08 02:07:52', 'assets/fotoProduk/forest_spirit.jpg', 0.1, '29.7x42 cm', 'Digital Print on Art Paper'),
(7, 'Ukiran Kayu Garuda', 'FINE_ART', 2200000, 'Ukiran tangan detail di atas kayu jati yang menggambarkan kemegahan lambang Garuda.', 1, 4, '2026-01-08 02:07:52', 'assets/fotoProduk/ukiran_garuda.jpg', 3.5, '40x60x5 cm', 'Teak Wood (Kayu Jati)'),
(8, 'Miniatur Rumah Joglo', 'HANDMADE_ART', 750000, 'Replika rumah adat Jawa dengan tingkat presisi tinggi dari kayu berkualitas.', 3, 4, '2026-01-08 02:07:52', 'assets/fotoProduk/joglo_mini.jpg', 2, '30x30x25 cm', 'Mahogany Wood'),
(9, 'Character Concept Astra', 'DIGITAL_ART', 450000, 'Desain karakter original lengkap dengan detail perlengkapan untuk kebutuhan game atau komik.', 5, 5, '2026-01-08 02:07:52', 'assets/fotoProduk/character_astra.jpg', 0.05, '21x29.7 cm', 'Digital / Photo Paper'),
(10, 'Poster Fantasy World', 'DIGITAL_ART', 400000, 'Cetak poster berkualitas tinggi yang membawa Anda masuk ke dunia imajinasi Nadia.', 9, 5, '2026-01-08 02:07:52', 'assets/fotoProduk/poster_fantasy.jpg', 0.1, '42x59.4 cm', 'Matte Paper 250gsm'),
(11, 'Sudut Kota Senja', 'FINE_ART', 1600000, 'Lukisan cat akrilik yang menangkap suasana melankolis persimpangan jalan di sore hari.', 2, 6, '2026-01-08 02:07:52', 'assets/fotoProduk/kota_senja.jpg', 1.1, '50x70x3 cm', 'Acrylic on Canvas'),
(12, 'Tari Bedhaya', 'FINE_ART', 1700000, 'Lukisan klasik yang menggambarkan keanggunan penari Jawa dalam balutan busana tradisional.', 2, 7, '2026-01-08 02:07:52', 'assets/fotoProduk/tari_bedhaya.jpg', 1.3, '60x90x3 cm', 'Oil on Canvas'),
(13, 'Dompet Kulit Handmade', 'HANDMADE_ART', 300000, 'Dompet dari kulit asli dengan jahitan tangan yang kuat dan desain minimalis.', 7, 8, '2026-01-08 02:07:52', 'assets/fotoProduk/dompet_kulit.jpg', 0.15, '11x9x2 cm', 'Genuine Cow Leather'),
(14, 'Pastel Market Scene', 'DIGITAL_ART', 300000, 'Ilustrasi digital suasana pasar yang hangat dengan palet warna pastel yang lembut.', 5, 9, '2026-01-08 02:07:52', 'assets/fotoProduk/pastel_market.jpg', 0.1, '29.7x42 cm', 'Digital Print'),
(15, 'Pagi di Ubud', 'FINE_ART', 2000000, 'Lukisan landscape pemandangan sawah terasering Bali yang damai di pagi hari.', 1, 10, '2026-01-08 02:07:52', 'assets/fotoProduk/pagi_ubud.jpg', 1.8, '80x100x4 cm', 'Acrylic on Canvas'),
(16, 'Gelang Etnik Bali', 'HANDMADE_ART', 180000, 'Aksesori tangan unik dengan perpaduan manik-manik dan ornamen khas Bali.', 9, 11, '2026-01-08 02:07:52', 'assets/fotoProduk/gelang_bali.jpg', 0.03, '6x6x1 cm', 'Beads & Silver Wire'),
(17, 'Poster Musik Indie', 'DIGITAL_ART', 400000, 'Desain poster bergaya retro-modern untuk dekorasi ruang para pencinta musik.', 6, 12, '2026-01-08 02:07:52', 'assets/fotoProduk/poster_indie.jpg', 0.1, '29.7x42 cm', 'Art Carton 260gsm');

-- --------------------------------------------------------

--
-- Table structure for table `seniman`
--

CREATE TABLE `seniman` (
  `idSeniman` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `tanggalLahir` date NOT NULL,
  `jenisDisabilitas` varchar(255) DEFAULT NULL,
  `jenisKelamin` enum('LAKI-LAKI','PEREMPUAN') NOT NULL,
  `tentangSaya` text DEFAULT NULL,
  `imageUrl` varchar(2048) DEFAULT NULL,
  `idUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `seniman`
--

INSERT INTO `seniman` (`idSeniman`, `nama`, `tanggalLahir`, `jenisDisabilitas`, `jenisKelamin`, `tentangSaya`, `imageUrl`, `idUser`) VALUES
(1, 'Ayu Lestari', '2008-05-12', 'Autism Spectrum Disorder', 'PEREMPUAN', 'Ayu lahir di Jakarta pada 12 Mei 2008. Baginya, melukis adalah caranya berkomunikasi dengan dunia luar. Ia sangat menyukai detail dalam realisme potret manusia, di mana ia bisa menangkap emosi yang sulit ia ungkapkan dengan kata-kata melalui goresan kuas yang halus.', 'assets/fotoSeniman/ayu.png', 1),
(2, 'Dimas Pratama', '2009-09-22', 'Tuna Rungu', 'LAKI-LAKI', 'Lahir pada 22 September 2009, Dimas menemukan dunianya dalam keheningan yang penuh warna. Sebagai seorang tuna rungu, ia mengasah kepekaan visualnya melalui seni abstrak dan mixed media, menciptakan tekstur-tekstur unik yang mewakili suara-suara di dalam pikirannya.', 'assets/fotoSeniman/dimas.png', 1),
(3, 'Rani Puspita', '2007-01-30', 'Tuna Netra', 'PEREMPUAN', 'Rani adalah remaja kelahiran Januari 2007 yang memiliki semangat luar biasa. Meski memiliki hambatan penglihatan, ia menggunakan teknologi bantuan untuk menjadi ilustrator digital semi-realist. Ia mengandalkan daya imajinasi dan ingatannya tentang bentuk untuk menciptakan karya yang memukau.', 'assets/fotoSeniman/rani.png', 1),
(4, 'Bagas Wijaya', '2008-03-18', 'Tuna Daksa', 'LAKI-LAKI', 'Bagas lahir pada 18 Maret 2008 dan memiliki ketertarikan besar pada material alam. Meski memiliki keterbatasan fisik (tuna daksa), tangannya sangat cekatan dalam mengolah kayu menjadi kerajinan handmade berkualitas tinggi. Baginya, setiap serat kayu memiliki cerita yang unik.', 'assets/fotoSeniman/bagas.png', 2),
(5, 'Nadia Zahra', '2008-11-02', 'Low Vision', 'PEREMPUAN', 'Nadia, yang lahir pada 2 November 2008, tidak membiarkan kondisi low vision menghalangi mimpinya. Ia fokus pada concept art digital dengan kontras warna yang tajam dan berani. Melalui layar monitor yang diperbesar, ia menciptakan dunia fantasi yang luas dan penuh detail.', 'assets/fotoSeniman/nadia.png', 2),
(6, 'Fajar Mahendra', '2006-06-17', 'Bipolar Disorder', 'LAKI-LAKI', 'Fajar lahir pada 17 Juni 2006 dan menemukan ketenangan dalam seni lukis fine art urban. Perjalanan emosionalnya dengan gangguan bipolar ia tuangkan ke dalam kanvas-kanvas besar yang menggambarkan dinamika kehidupan kota, menjadikannya medium terapi sekaligus ekspresi diri.', 'assets/fotoSeniman/fajar.png', 2),
(7, 'Intan Maharani', '2007-07-14', 'Autism Spectrum Disorder', 'PEREMPUAN', 'Lahir di tengah keluarga yang kental dengan adat, Intan yang lahir 14 Juli 2007 sangat mencintai budaya Jawa. Fokusnya yang mendalam sebagai individu autistik membuatnya mampu melukis motif batik dan figur tradisional dengan tingkat ketelitian yang sangat tinggi dan penuh filosofi.', 'assets/fotoSeniman/intan.png', 3),
(8, 'Rizky Adi Saputra', '2007-12-01', 'Tuna Daksa', 'LAKI-LAKI', 'Rizky lahir pada 1 Desember 2007 dan merupakan sosok yang pantang menyerah. Ia mendedikasikan waktunya untuk mempelajari teknik kriya kayu dan kulit. Baginya, keterbatasan fisik bukanlah penghalang untuk menciptakan produk fungsional yang memiliki nilai estetika tinggi.', 'assets/fotoSeniman/rizky.png', 3),
(9, 'Salsa Permata', '2009-02-20', 'ADHD', 'PEREMPUAN', 'Salsa adalah remaja energik kelahiran 20 Februari 2009. Energi berlebih yang ia miliki karena ADHD disalurkan menjadi kreativitas tanpa batas dalam ilustrator digital bergaya pastel. Karyanya selalu ceria, penuh warna, dan memiliki komposisi yang dinamis.', 'assets/fotoSeniman/salsa.png', 3),
(10, 'Made Surya', '2009-08-09', 'Tuna Daksa', 'LAKI-LAKI', 'Made lahir di Bali pada 9 Agustus 2009. Terinspirasi dari alam sekitarnya, ia menekuni aliran naturalis. Walaupun memiliki keterbatasan mobilitas, ia mampu menangkap keindahan pemandangan sawah dan pura Bali dengan perspektif yang menyejukkan mata.', 'assets/fotoSeniman/made.png', 4),
(11, 'Ayu Kartika Dewi', '2008-04-25', 'Tuna Rungu', 'PEREMPUAN', 'Ayu lahir pada 25 April 2008 dan memiliki ketertarikan pada fashion etnik. Sebagai seniman tuna rungu, ia sangat peka terhadap komposisi manik-manik dan tekstur kain. Ia menciptakan aksesoris etnik yang modern namun tetap mempertahankan akar budaya tradisional.', 'assets/fotoSeniman/ayu_kartika.png', 4),
(12, 'Kevin Pranata', '2006-10-11', 'Autism Spectrum Disorder', 'LAKI-LAKI', 'Kevin lahir pada 11 Oktober 2006. Melalui desain poster dan ilustrasi digital, ia menemukan cara untuk memproses perasaan depresinya menjadi karya visual yang provokatif dan bermakna. Karya-karyanya seringkali mengangkat tema kesehatan mental untuk memotivasi orang lain.', 'assets/fotoSeniman/kevin.png', 4);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `idTransaksi` int(11) NOT NULL,
  `idPembeli` int(11) DEFAULT NULL,
  `tanggalTransaksi` datetime DEFAULT current_timestamp(),
  `totalBayar` double DEFAULT NULL,
  `metodePembayaran` varchar(50) DEFAULT NULL,
  `alamatPengiriman` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `idUser` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `alamat` text DEFAULT NULL,
  `nomorTelepon` varchar(20) DEFAULT NULL,
  `role` enum('ADMIN','PEMBELI','SEKOLAH') NOT NULL,
  `imageUrl` varchar(2048) DEFAULT NULL,
  `tipeRekening` varchar(50) DEFAULT NULL,
  `nomorRekening` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`idUser`, `nama`, `username`, `email`, `password`, `alamat`, `nomorTelepon`, `role`, `imageUrl`, `tipeRekening`, `nomorRekening`) VALUES
(1, 'SMK Seni Nusantara', 'smkseninus', 'admin@smkseninus.sch.id', '123456', 'Jl. Raya Setiabudi No. 45, Kel. Hegarmanah, Kec. Cidadap, Kota Bandung, Jawa Barat 40141', '081234567890', 'SEKOLAH', 'assets/fotoProfil/default.jpg', 'BCA', '8420991234'),
(2, 'SMA Kreativa', 'smakreativa', 'admin@smakreativa.sch.id', '123456', 'Jl. Kaliurang KM 7,5 No. 12, Kel. Condongcatur, Kec. Depok, Kabupaten Sleman, DI Yogyakarta 55283', '081298765432', 'SEKOLAH', 'assets/fotoProfil/default.jpg', 'Mandiri', '1370012345678'),
(3, 'SMK Budaya Kreatif', 'smkbudayakreatif', 'admin@smkbudayakreatif.sch.id', '123456', 'Jl. Slamet Riyadi No. 128, Kel. Sriwedari, Kec. Laweyan, Kota Surakarta, Jawa Tengah 57141', '081355667788', 'SEKOLAH', 'assets/fotoProfil/default.jpg', 'BNI', '0234567891'),
(4, 'SMA Cipta Karya', 'smaciptakarya', 'admin@smaciptakarya.sch.id', '123456', 'Jl. Tukad Yeh Aya No. 9, Kel. Panjer, Kec. Denpasar Selatan, Kota Denpasar, Bali 80234', '081366778899', 'SEKOLAH', 'assets/fotoProfil/default.jpg', 'BRI', '002101000123456'),
(5, 'Admin', 'Admin', 'admin@artable.com', 'admin123', NULL, '081234567890', 'ADMIN', 'assets/fotoProfil/default.jpg', NULL, NULL),
(6, 'Yohana', 'yohana', 'y@gmail.com', '123456', 'Jl. Melati No. 12, Jakarta', '081234567890', 'PEMBELI', 'assets/fotoProfil/default.jpg', NULL, NULL),
(7, 'Julian', 'julian', 'j@gmail.com', '123456', 'Jl. Mawar No. 45, Bandung', '081398765432', 'PEMBELI', 'assets/fotoProfil/default.jpg', NULL, NULL),
(8, 'Avatar', 'avatar', 'a@gmail.com', '123456', 'Jl. Anggrek No. 7, Surabaya', '081122334455', 'PEMBELI', 'assets/fotoProfil/default.jpg', NULL, NULL),
(9, 'Fayyedh', 'fayyedh', 'f@gmail.com', '123456', 'Jl. Kenanga No. 21, Yogyakarta', '081566778899', 'PEMBELI', 'assets/fotoProfil/default.jpg', NULL, NULL),
(10, 'Runa', 'runa', 'r@gmail.com', '123456', 'Jl. Dahlia No. 3, Denpasar', '081900112233', 'PEMBELI', 'assets/fotoProfil/default.jpg', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`idCart`),
  ADD UNIQUE KEY `uk_user_cart` (`idUser`),
  ADD KEY `fk_user_cart` (`idUser`);

--
-- Indexes for table `cartitem`
--
ALTER TABLE `cartitem`
  ADD PRIMARY KEY (`idCartItem`),
  ADD UNIQUE KEY `uk_cart_produk` (`idCart`,`idProduk`),
  ADD KEY `fk_cart_cartItem` (`idCart`),
  ADD KEY `fk_produk_cartItem` (`idProduk`);

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`idDetail`),
  ADD KEY `fk_produk` (`idProduk`),
  ADD KEY `fk_sekolah` (`idSekolah`),
  ADD KEY `fk_transaksi` (`idTransaksi`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`idNotifikasi`),
  ADD KEY `fk_notif_user` (`idUser`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`idProduk`),
  ADD KEY `fk_seniman_produk` (`idSeniman`);

--
-- Indexes for table `seniman`
--
ALTER TABLE `seniman`
  ADD PRIMARY KEY (`idSeniman`),
  ADD KEY `fk_user_seniman` (`idUser`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`idTransaksi`),
  ADD KEY `idPembeli` (`idPembeli`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `idx_username` (`username`),
  ADD UNIQUE KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `idCart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cartitem`
--
ALTER TABLE `cartitem`
  MODIFY `idCartItem` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `idDetail` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `idNotifikasi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `idProduk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `seniman`
--
ALTER TABLE `seniman`
  MODIFY `idSeniman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `idTransaksi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_user_cart` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cartitem`
--
ALTER TABLE `cartitem`
  ADD CONSTRAINT `fk_cart_cartItem` FOREIGN KEY (`idCart`) REFERENCES `cart` (`idCart`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_produk_cartItem` FOREIGN KEY (`idProduk`) REFERENCES `produk` (`idProduk`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `fk_produk` FOREIGN KEY (`idProduk`) REFERENCES `produk` (`idProduk`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sekolah` FOREIGN KEY (`idSekolah`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transaksi` FOREIGN KEY (`idTransaksi`) REFERENCES `transaksi` (`idTransaksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `fk_notif_user` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `fk_produk_seniman` FOREIGN KEY (`idSeniman`) REFERENCES `seniman` (`idSeniman`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `seniman`
--
ALTER TABLE `seniman`
  ADD CONSTRAINT `fk_user_seniman` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`idPembeli`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
