<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Produk"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Artable</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/uikit@3.25.1/dist/css/uikit.min.css" />

        <script src="https://cdn.jsdelivr.net/npm/uikit@3.25.1/dist/js/uikit.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/uikit@3.25.1/dist/js/uikit-icons.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background:#f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }

            /* Penyelarasan Header Section dengan nuansa ungu */
            .uk-section h1 {
                font-weight: 800;
                color: #4a3f81;
                position: relative;
                padding-bottom: 15px; /* Memberi ruang untuk garis */
            }

            /* Membuat garis dekoratif default di kiri */
            .uk-section h1::after {
                content: '';
                display: block;
                width: 60px;
                height: 4px;
                background: #d2c9ff;
                margin-top: 10px;
                border-radius: 2px;
            }

            /* KHUSUS: Jika h1 punya class 'uk-text-center', garis akan pindah ke tengah */
            h1.uk-text-center::after {
                margin-left: auto !important;
                margin-right: auto !important;
            }

            .uk-card {
                border-radius: 20px;
                border: 1px solid #eee;
                transition: .3s ease;
            }
            .uk-card-hover:hover {
                box-shadow: 0 10px 25px rgba(111, 66, 193, 0.2) !important;
                transform: translateY(-5px);
            }

            .product-img {
                height:200px;
                object-fit:contain;
                background:#fff;
            }

            /* Styling Nama Produk agar sangat JELAS */
            .product-name {
                color: #212529 !important; /* Hitam pekat */
                font-weight: 700 !important;
                font-size: 1.1rem;
                margin-bottom: 5px;
            }

            /* Tombol VIEW - Dibuat JELAS dengan border ungu */
            .btn-view-custom {
                color: #6f42c1 !important;
                border: 2px solid #6f42c1 !important; /* Border ungu tegas */
                background-color: #ffffff !important;
                font-weight: 600;
                transition: 0.3s;
            }
            .btn-view-custom:hover {
                background-color: #6f42c1 !important;
                color: #ffffff !important;
            }

            /* Tombol ADD - Ungu Muda Solid */
            .btn-add-custom {
                background-color: #d2c9ff !important;
                border: none;
                color: #333 !important;
                font-weight: 600;
            }
            .btn-add-custom:hover {
                background-color: #b5a8ff !important;
                color: #fff !important;
            }

            /* Slider Nav */
            .uk-slidenav {
                background: rgba(210, 201, 255, 0.4);
                padding: 10px;
                border-radius: 50%;
                color: #6f42c1 !important;
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
                        <a href="Home" class="text-decoration-none text-danger fw-bold">Home</a>
                        <a href="Produk?menu=shop" class="text-decoration-none text-dark">Shop</a>
                        <a href="Home?menu=about" class="text-decoration-none text-dark">About Us</a>
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

        <!-- BAGIAN SLIDER AWAL -->
        <div class="uk-position-relative uk-visible-toggle uk-light uk-margin-medium-top" tabindex="-1" uk-slider="center: true">
            <div class="uk-slider-items uk-grid">
                <div class="uk-width-3-4">
                    <div class="uk-panel">
                        <img src="https://images.unsplash.com/photo-1549490349-8643362247b5?q=80&w=1287&auto=format&fit=crop" class="rounded-4" style="width:100%; height:400px; object-fit:cover;" alt="">
                    </div>
                </div>
                <div class="uk-width-3-4">
                    <div class="uk-panel">
                        <img src="https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=1345&auto=format&fit=crop" class="rounded-4" style="width:100%; height:400px; object-fit:cover;" alt="">
                    </div>
                </div>
            </div>
            <a class="uk-position-center-left uk-position-small uk-hidden-hover" href uk-slidenav-previous uk-slider-item="previous"></a>
            <a class="uk-position-center-right uk-position-small uk-hidden-hover" href uk-slidenav-next uk-slider-item="next"></a>
        </div>
        <!-- BAGIAN NEW PRODUCT -->
        <section id="newProducts" class="uk-section">
            <div class="uk-container">
                <h1 class="uk-text-center uk-margin-large-top">New Products</h1>

                <div class="uk-position-relative uk-visible-toggle uk-light" tabindex="-1" uk-slider>
                    <ul class="uk-slider-items uk-child-width-1-2 uk-child-width-1-3@m uk-grid-small uk-grid">
                        <%
                            ArrayList<Produk> prods = (ArrayList<Produk>) request.getAttribute("list");
                            if (prods != null && !prods.isEmpty()) {
                                for (Produk p : prods) {
                        %>
                        <li>
                            <div class="uk-card uk-card-default uk-card-body uk-padding-small uk-text-center uk-card-hover" style="color: #000;">
                                <div class="uk-flex uk-flex-center">
                                    <img src="<%= p.getImageUrl()%>" alt="<%= p.getNama()%>" class="product-img">
                                </div>
                                <div class="card-body text-center uk-margin-top">
                                    <h6 class="product-name"><%= p.getNama()%></h6>
                                    <p class="mb-3"><strong>Rp<%= String.format("%,.0f", p.getHarga())%></strong></p>
                                    <%
                                        if (userSession == null || !"SEKOLAH".equals(userSession.getRole())) {
                                    %>
                                    <div class="d-flex justify-content-around">
                                        <a href="Produk?menu=view&id=<%= p.getIdProduk()%>" class="btn btn-sm btn-view-custom rounded-pill px-3"><i class="bi bi-eye"></i> View</a>
                                        <form action="CartServlet" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="id" value="<%= p.getIdProduk()%>">

                                            <button type="submit" class="btn btn-sm btn-add-custom rounded-pill px-3 shadow-sm">
                                                <i class="bi bi-cart"></i> Add
                                            </button>
                                        </form>
                                    </div>
                                    <% } else {%>
                                    <div class="d-flex justify-content-center">
                                        <a href="Produk?menu=view&id=<%= p.getIdProduk()%>" class="btn btn-sm btn-view-custom rounded-pill px-3"><i class="bi bi-eye"></i> View</a>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </li>
                        <%
                            }
                        } else {
                        %>
                        <div class="uk-width-1-1 uk-text-center py-5">
                            <p class="text-muted">No products found</p>
                        </div>
                        <% }%>
                    </ul>
                    <a class="uk-position-center-left uk-position-small uk-hidden-hover" href uk-slidenav-previous uk-slider-item="previous"></a>
                    <a class="uk-position-center-right uk-position-small uk-hidden-hover" href uk-slidenav-next uk-slider-item="next"></a>
                </div>
            </div>
        </section>

        <section id="shopByCategory" class="uk-section">
            <div class="uk-container">
                <h1 class="uk-text-left uk-margin-small-top">Shop By Category</h1>
                <div class="uk-child-width-1-3@s uk-grid-large uk-grid-match uk-text-center" uk-grid>
                    <a href="Produk?menu=shop&category=FINE_ART" class="uk-link-toggle text-decoration-none">
                        <div class="uk-card uk-card-default uk-padding-remove uk-card-hover" style="border-bottom: 5px solid #d2c9ff;">
                            <div class="uk-card-media-top">
                                <img src="images/categories/fine-art.png" alt="" class="category-img">
                            </div>
                            <div class="uk-card-body">
                                <h3 class="category-title" style="color: #6f42c1; font-weight: 700;">Fine Art</h3>
                                <p class="category-desc">Paintings, Classical Art, etc.</p>
                            </div>
                        </div>
                    </a>

                    <a href="Produk?menu=shop&category=DIGITAL_ART" class="uk-link-toggle text-decoration-none">
                        <div class="uk-card uk-card-default uk-padding-remove uk-card-hover" style="border-bottom: 5px solid #d2c9ff;">
                            <div class="uk-card-media-top">
                                <img src="images/categories/digital-art.png" alt="" class="category-img">
                            </div>
                            <div class="uk-card-body">
                                <h3 class="category-title" style="color: #6f42c1; font-weight: 700;">Digital Art</h3>
                                <p class="category-desc">Graphic Art, 3D Art, etc.</p>
                            </div>
                        </div>
                    </a>

                    <a href="Produk?menu=shop&category=HANDMADE_ART" class="uk-link-toggle text-decoration-none">
                        <div class="uk-card uk-card-default uk-padding-remove uk-card-hover" style="border-bottom: 5px solid #d2c9ff;">
                            <div class="uk-card-media-top">
                                <img src="images/categories/handmade.png" alt="" class="category-img">
                            </div>
                            <div class="uk-card-body">
                                <h3 class="category-title" style="color: #6f42c1; font-weight: 700;">Handmade Art</h3>
                                <p class="category-desc">Crafts, Sculptures, DIY Art, etc.</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </section>
        <section id="frequentlyAskedQuestions" class="uk-section">
            <div class="uk-container">
                <h1 class="uk-text-center uk-margin-large-top">Frequently Asked Questions</h1>

                <!-- ITEM 1 -->
                <ul uk-accordion="multiple: true">
                    <li>
                        <div class="uk-accordion-title fw-bold">Apa itu Artable?</div>
                        <div class="uk-accordion-content">
                            <p>Artable adalah platform e-commerce inklusif yang menyediakan ruang bagi sekolah dan
                                seniman anak disabilitas untuk memasarkan karya seni mereka secara profesional.
                                Artable menghubungkan karya bermakna dengan pembeli yang peduli terhadap dampak sosial.
                            </p>
                        </div>
                    </li>
                </ul>

                <hr>

                <!-- ITEM 2 -->
                <ul uk-accordion="multiple: true">
                    <li>
                        <div class="uk-accordion-title fw-bold">Siapa saja yang dapat menjual karya di Artable?</div>
                        <div class="uk-accordion-content">
                            <p>Penjual di Artable adalah pihak sekolah, khususnya Sekolah Luar Biasa (SLB), yang mewakili siswa (seniman disabilitas).
                                Sekolah bertanggung jawab mengelola akun, mengunggah karya, dan memproses pesanan.</p>
                        </div>
                    </li>
                </ul>

                <hr>

                <!-- ITEM 3 -->
                <ul uk-accordion="multiple: true">
                    <li>
                        <div class="uk-accordion-title fw-bold">Jenis karya apa saja yang bisa dijual?</div>
                        <div class="uk-accordion-content">
                            <p>Karya yang dijual meliputi berbagai bentuk seni dan kreativitas, seperti lukisan, kerajinan tangan, ilustrasi,
                                produk dekoratif, dan karya kreatif lainnya yang dibuat oleh siswa disabilitas.</p>
                        </div>
                    </li>
                </ul>

            </div>
        </section>     

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