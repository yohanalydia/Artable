<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tentang Kami - Artable</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: #f6f7fb;
                color: #333;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            .shop-header {
                background-color: #d2c9ff; /* Warna ungu muda yang sama */
                padding: 80px 0;           /* Padding yang lebih luas */
                border-radius: 0 0 50px 50px; /* Lekukan di bagian bawah agar estetik */
                margin-bottom: 50px;
                text-align: center;
            }

            .shop-header h1 {
                font-weight: 700;
                font-size: 2.5rem; /* Ukuran font judul yang lebih besar */
                color: #333;
            }


            .section-title {
                position: relative;
                padding-bottom: 15px;
                margin-bottom: 30px;
                font-weight: 700;
            }

            .section-title::after {
                content: '';
                position: absolute;
                left: 0;
                bottom: 0;
                width: 50px;
                height: 4px;
                background-color: #d2c9ff;
                border-radius: 2px;
            }


            .card-custom {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                transition: transform 0.3s ease;
            }

            .card-custom:hover {
                transform: translateY(-5px);
            }

            .mission-item {
                display: flex;
                align-items: flex-start;
                margin-bottom: 20px;
            }

            .mission-icon {
                background-color: #e9e5ff;
                color: #6f42c1;
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                flex-shrink: 0;
            }

            .impact-list {
                list-style: none;
                padding-left: 0;
            }

            .impact-list li {
                padding: 10px 0;
                display: flex;
                align-items: center;
            }

            .impact-list li i {
                color: #28a745;
                margin-right: 10px;
            }

            .cta-box {
                background: linear-gradient(135deg, #d2c9ff 0%, #b5a8ff 100%);
                border-radius: 30px;
                padding: 50px;
                text-align: center;
                color: #444;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
        </style>
    </head>
    <body>
        <!-- BAGIAN NAVIGASI -->
        <div class="sticky-top shadow-sm">
            <!-- Topbar -->
            <div class="topbar py-2">
                <div class="container d-flex justify-content-between">
                    <div class="topbar-links d-flex gap-3">
                        <a href="Main?menu=faq" class="text-muted text-decoration-none hover-purple">FAQs</a>
                        <span class="text-muted">|</span>
                        <a href="Main?menu=about" class="text-muted text-decoration-none hover-purple">Help</a>
                        <span class="text-muted">|</span>
                        <a href="https://wa.me/628123456789" target="_blank" class="text-muted text-decoration-none hover-purple">Support</a>
                    </div>
                    <div class="d-flex gap-3">
                        <i class="bi bi-facebook" style="color: #6f42c1;"></i>
                        <i class="bi bi-twitter" style="color: #6f42c1;"></i>
                        <i class="bi bi-instagram" style="color: #6f42c1;"></i>
                    </div>
                </div>
            </div>

            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg bg-white border-bottom">
                <div class="container d-flex justify-content-between">
                    <a class="navbar-brand fw-bold text-decoration-none" href="Home" style="color: #6f42c1;">Artable</a>

                    <div class="d-flex gap-4 align-items-center">
                        <%
                            User userSession = (User) session.getAttribute("user");
                            int countNotif = 0;
                            if (userSession != null) {
                                countNotif = new Notifikasi().getCountUnread(userSession.getIdUser());
                        %>
                        <a href="Notifikasi" class="text-dark position-relative text-decoration-none">
                            <i class="bi bi-bell fs-5"></i>
                            <% if (countNotif > 0) {%>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" 
                                  style="font-size: 0.65rem; padding: 0.35em 0.5em;">
                                <%= countNotif%>
                                <span class="visually-hidden">unread notifications</span>
                            </span>
                            <% } %>
                        </a>

                        <% if ("PEMBELI".equals(userSession.getRole())) { %>
                        <a href="CartServlet?action=view" class="text-dark"><i class="bi bi-cart fs-5"></i></a>
                            <% } %>

                        <% } %>
                    </div>
                </div>
            </nav>

            <!-- Menu -->
            <div class="border-bottom bg-white">
                <div class="container d-flex justify-content-between py-2">
                    <div class="d-flex gap-4">
                        <a href="Home" class="text-decoration-none text-dark">Home</a>
                        <a href="Produk?menu=shop" class="text-decoration-none text-dark">Shop</a>
                        <a href="Home?menu=about" class="text-decoration-none text-danger fw-bold">About Us</a>
                        <%
                            if (userSession != null && "ADMIN".equals(userSession.getRole())) { %>
                        <a href="Dashboard" class="bi bi-file-bar-graph text-decoration-none text-dark">Dashboard</a>
                        <% } %>
                        
                        <%
                            if (userSession != null && "PEMBELI".equals(userSession.getRole())) { %>
                        <a href="Transaksi" class="text-decoration-none text-dark">Pesanan Saya</a>
                        <% } %>

                        <!-- BAGIAN MENU TOKO -->
                        <%
                            if (userSession != null && "SEKOLAH".equals(userSession.getRole())) { %>
                        <div class="dropdown">
                            <a class="nav-link dropdown-toggle fw-bold text-dark text-decoration-none" role="button" id="dropdownMenuToko" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-shop me-1"></i> Menu Toko
                            </a>
                            <ul class="dropdown-menu shadow-sm border-0" aria-labelledby="dropdownMenuToko">
                                <li>
                                    <a class="dropdown-item py-2" href="Dashboard">
                                        <i class="bi bi-file-bar-graph me-3"></i> Dashboard
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="Produk?menu=myproduct">
                                        <i class="bi bi-box-seam me-3"></i> Produk Saya
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="Produk?menu=myseniman">
                                        <i class="bi bi-people me-3"></i> Seniman Saya
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="Transaksi">
                                        <i class="bi bi-cart-check me-3"></i> Pesanan Masuk
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <% } %>
                    </div>
                    <div>
                        <%
                            if (userSession == null) {
                        %>
                        <a href="${pageContext.request.contextPath}/Auth" class="text-decoration-none text-dark">Login</a> /
                        <a href="${pageContext.request.contextPath}/Auth?type=register" class="text-decoration-none text-dark">Register</a>
                        <%
                        } else {
                        %>
                        <span class="fw-bold me-2">Hi, <a href="Auth?type=profil" class="text-decoration-none" style="color: #6f42c1;"> <%= userSession.getNama()%> </a> </span>
                        <a href="${pageContext.request.contextPath}/Auth?logout=true" class="text-danger text-decoration-none small">Logout</a>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Header -->
        <header class="shop-header">
            <div class="container">
                <h1 class="display-4 fw-bold mb-3">ABOUT ARTABLE</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-center">
                        <li class="breadcrumb-item">
                            <a href="Home" class="text-decoration-none text-dark">Home</a>
                        </li>
                        <li class="breadcrumb-item active text-muted" aria-current="page">About Us</li>
                    </ol>
                </nav>
            </div>
        </header>

        <div class="container mb-5">
            <div class="row align-items-center mb-5">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <img src="https://images.unsplash.com/photo-1560421683-6856ea585c78?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Art Inclusivity" class="img-fluid rounded-4 shadow">
                </div>
                <div class="col-lg-6 ps-lg-5">
                    <h2 class="section-title">Apa itu Artable?</h2>
                    <p class="lead text-muted">Artable adalah platform e-commerce inklusif yang didedikasikan untuk mendukung dan memasarkan karya seni anak-anak disabilitas melalui peran aktif sekolah, khususnya Sekolah Luar Biasa (SLB).</p>
                    <hr>
                    <p>Kami percaya bahwa setiap anak memiliki potensi, kreativitas, dan cerita yang layak untuk diapresiasi oleh dunia. Melalui Artable, sekolah berperan sebagai mitra utama yang membantu mengelola, mengunggah, dan memasarkan karya seni siswa secara profesional.</p>
                    <p>Dengan begitu, karya-karya tersebut tidak hanya menjadi hasil pembelajaran, tetapi juga memiliki nilai ekonomi dan sosial yang nyata.</p>
                </div>
            </div>

            <div class="row mb-5">
                <div class="col-12">
                    <div class="card card-custom p-4 p-md-5">
                        <h2 class="section-title">Latar Belakang</h2>
                        <p>Banyak anak disabilitas menghasilkan karya seni yang unik dan bernilai tinggi, namun sering kali terbatas dalam akses pemasaran dan distribusi. Di sisi lain, masyarakat semakin peduli terhadap produk-produk yang memiliki dampak sosial.</p>
                        <p class="mb-0"><strong>Artable hadir sebagai jembatan</strong> antara kedua pihak tersebut - menghubungkan seniman disabilitas dan sekolah dengan pembeli yang ingin berkontribusi secara langsung dalam menciptakan perubahan sosial melalui pembelian karya seni.</p>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-5">
                    <div class="card card-custom h-100 p-4" style="background-color: #fff;">
                        <h2 class="section-title">Visi</h2>
                        <p class="fst-italic text-muted">"Mewujudkan ekosistem e-commerce yang inklusif, berkelanjutan, dan memberdayakan seniman disabilitas agar karya mereka dikenal, dihargai, dan memberikan dampak nyata bagi masa depan mereka."</p>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="card card-custom h-100 p-4">
                        <h2 class="section-title">Misi Kami</h2>
                        <div class="mission-item">
                            <div class="mission-icon"><i class="bi bi-star"></i></div>
                            <p class="mb-0">Memberdayakan sekolah dan seniman disabilitas dengan platform penjualan yang mandiri dan profesional.</p>
                        </div>
                        <div class="mission-item">
                            <div class="mission-icon"><i class="bi bi-shield-check"></i></div>
                            <p class="mb-0">Menciptakan pasar yang aman, transparan, dan terpercaya khusus untuk karya anak disabilitas.</p>
                        </div>
                        <div class="mission-item">
                            <div class="mission-icon"><i class="bi bi-gear"></i></div>
                            <p class="mb-0">Mempermudah pengelolaan karya, seniman, dan transaksi bagi pihak sekolah.</p>
                        </div>
                        <div class="mission-item">
                            <div class="mission-icon"><i class="bi bi-heart"></i></div>
                            <p class="mb-0">Memberikan pengalaman belanja yang nyaman, aman, dan bermakna bagi pembeli.</p>
                        </div>
                        <div class="mission-item">
                            <div class="mission-icon"><i class="bi bi-megaphone"></i></div>
                            <p class="mb-0">Meningkatkan apresiasi masyarakat terhadap karya seni sekaligus cerita di baliknya.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row align-items-center mb-5 py-4">
                <div class="col-lg-6 order-2 order-lg-1">
                    <h2 class="section-title">Tujuan Sosial</h2>
                    <p>Artable tidak hanya berfokus pada jual beli produk, tetapi juga pada pembangunan kesadaran dan empati sosial. Setiap karya dilengkapi dengan profil sekolah dan seniman untuk memahami cerita dan perjuangan di baliknya.</p>
                    <p class="fw-bold mb-2">Dengan berbelanja di Artable, Anda turut:</p>
                    <ul class="impact-list">
                        <li><i class="bi bi-check-circle-fill"></i> Mendukung pendidikan dan pengembangan bakat anak disabilitas</li>
                        <li><i class="bi bi-check-circle-fill"></i> Membantu sekolah dalam menciptakan kemandirian ekonomi</li>
                        <li><i class="bi bi-check-circle-fill"></i> Mengapresiasi karya seni sebagai medium inklusi dan kesetaraan</li>
                    </ul>
                </div>
                <div class="col-lg-6 order-1 order-lg-2 mb-4 mb-lg-0 text-center">
                    <img src="https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=1471&auto=format&fit=crop" alt="Social Goal" class="img-fluid rounded-4 shadow w-75">
                </div>
            </div>

            <div class="cta-box">
                <h2 class="fw-bold mb-3">Bersama Kita Menciptakan Dampak</h2>
                <p class="mb-4">Artable percaya bahwa inklusivitas bukan hanya tentang memberi ruang, tetapi juga tentang memberi kesempatan yang setara. Mari bersama sekolah, seniman, dan pembeli menciptakan ekosistem yang luar biasa.</p>
                <a href="Produk?menu=shop" class="btn btn-dark btn-lg rounded-pill px-5 shadow">Mulai Belanja</a>
            </div>
        </div>

        <footer class="py-5 bg-light border-top mt-0">
            <div class="container">
                <div class="row g-4 text-center text-md-start">
                    <div class="col-12 col-md-6">
                        <h4 class="fw-bold" style="color:#6f42c1">Artable</h4>
                        <p class="text-muted pe-md-5">
                            Penghubung sekolah, seniman disabilitas, dan pembeli dalam platform e-commerce inklusif yang aman dan transparan.
                            Dirancang untuk mendukung apresiasi karya sekaligus dampak sosial berkelanjutan.
                        </p>
                    </div>
                    <div class="col-6 col-md-3">
                        <h5 class="fw-bold mb-3 border-start border-4 border-primary ps-2">Quick Links</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2"><a href="Home" class="text-decoration-none text-dark">Home</a></li>
                            <li class="mb-2"><a href="Produk?menu=shop" class="text-decoration-none text-dark">Shop</a></li>
                        </ul>
                    </div>
                    <div class="col-6 col-md-3">
                        <h5 class="fw-bold mb-3 border-start border-4 border-primary ps-2">Contact</h5>
                        <ul class="list-unstyled text-muted">
                            <li class="mb-1">info@artable.com</li>
                            <li class="mb-1">+62 812 3456 7890</li>
                        </ul>
                        <div class="mt-3 fs-5">
                            <i class="bi bi-facebook me-3"></i>
                            <i class="bi bi-instagram"></i>
                        </div>
                    </div>
                </div>
                <hr class="my-4">
                <p class="text-center text-secondary small">&copy; 2025 Artable. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>