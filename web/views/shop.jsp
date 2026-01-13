<%@page import="model.Notifikasi"%>
<%@page import="model.Seniman"%>
<%@page import="model.User"%>
<%@page import="model.Pembeli"%>
<%@page import="model.Produk"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Belanja - Artable</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <!-- GOOGLE FONTS -->
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
            .filter-box {
                background:#fff;
                border:1px solid #eaeaea;
                padding:20px;
            }
            .product-card {
                border:1px solid #eaeaea;
                transition:.2s;
            }
            .product-card:hover {
                box-shadow:0 8px 20px rgba(0,0,0,.08);
                transform:translateY(-2px);
            }
            .product-img {
                height:260px;
                object-fit:contain;
                background:#fff;
            }
            .old-price {
                text-decoration:line-through;
                color:#999;
                font-size:14px;
            }

            .btn-view-custom {
                color: #6f42c1 !important;
                border: 2px solid #6f42c1 !important;
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
            /* Sidebar Styling */
            .card {
                transition: all 0.3s ease;
            }

            /* Mengubah tampilan tombol kategori yang tidak aktif */
            .btn-light {
                background-color: #f8f9fa !important;
                color: #4b566b !important;
                font-weight: 500;
            }

            .btn-light:hover {
                background-color: #eef1f8 !important;
                color: #6f42c1 !important; /* Warna ungu brand kamu */
            }

            /* Mengubah tampilan tombol kategori yang aktif */
            .btn-primary {
                background-color: #6f42c1 !important; /* Warna ungu brand */
                border-color: #6f42c1 !important;
                font-weight: 600;
            }

            /* Input Search Focus */
            .form-control:focus {
                background-color: #fff !important;
                border-color: #d2c9ff !important;
                box-shadow: 0 0 0 0.25rem rgba(111, 66, 193, 0.1) !important;
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

                    <!-- Menampilkan jumlah notifikasi pada user sekaligus tombol notifikasi jika user telah login -->
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
                        <a href="Produk?menu=shop" class="text-decoration-none text-danger fw-bold">Shop</a>
                        <a href="Home?menu=about" class="text-decoration-none text-dark">About Us</a>
                        <!-- Menampilkan menu-menu sesuai dengan role user yang sedang login -->
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
                                    <a class="dropdown-item py-2" href="SenimanServlet?menu=myseniman">
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
                            // Menampilkan tombol untuk login dan register jika user belum login
                            if (userSession == null) {
                        %>
                        <a href="Auth" class="text-decoration-none text-dark">Login</a> /
                        <a href="Auth?type=register" class="text-decoration-none text-dark">Register</a>
                        <%
                            // Menampilkan nama user yang sedang login beserta tombol logout
                        } else {
                        %>
                        <span class="fw-bold me-2">Hi, <a href="Auth?type=profil" class="text-decoration-none" style="color: #6f42c1;"> <%= userSession.getNama()%> </a> </span>
                        <a href="Auth?logout=true" class="text-danger text-decoration-none small">Logout</a>
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
                <h1 class="display-4 fw-bold mb-3">ARTABLE SHOP</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-center">
                        <li class="breadcrumb-item">
                            <a href="Home" class="text-decoration-none text-dark">Home</a>
                        </li>
                        <li class="breadcrumb-item active text-muted" aria-current="page">Shop</li>
                    </ol>
                </nav>
            </div>
        </header>

        <!-- Content -->
        <div class="container my-5">
            <div class="row">

                <!-- Sidebar -->
                <aside class="col-md-3">
                    <%
                        String currentCat = request.getParameter("category");
                        if (currentCat == null) {
                            currentCat = "";
                        }
                        
                        String currentSort = request.getParameter("sort");
                        if (currentSort == null) {
                            currentSort = "";
                        }
                        
                        String currentSearch = request.getParameter("search");
                        if (currentSearch == null) {
                            currentSearch = "";
                        }

                        // String pembantu untuk menjaga parameter di URL
                        String sortParam = currentSort.isEmpty() ? "" : "&sort=" + currentSort;
                        String searchParam = currentSearch.isEmpty() ? "" : "&search=" + currentSearch;
                    %>

                    <div class="card border-0 shadow-sm rounded-4 mb-4">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-building me-2 text-primary"></i>School</h6>
                            <form action="Produk" method="GET">
                                <input type="hidden" name="menu" value="shop">
                                <!-- Mengecek kondisi filter saat ini untuk melakukan filtering -->
                                <% if (!currentCat.isEmpty()) {%> <input type="hidden" name="category" value="<%= currentCat%>"> <% } %>
                                <% if (!currentSort.isEmpty()) {%> <input type="hidden" name="sort" value="<%= currentSort%>"> <% } %>
                                <% if (!currentSearch.isEmpty()) {%> <input type="hidden" name="search" value="<%= currentSearch%>"> <% }%>

                                <!-- Menampilkan fitur search berdasarkan nama sekolah -->
                                <div class="input-group">
                                    <input name="search-school" class="form-control border-end-0 bg-light" 
                                           placeholder="Search by school name..." 
                                           style="border-radius: 10px 0 0 10px;"
                                           value="<%= request.getParameter("search-school") != null ? request.getParameter("search-school") : ""%>">
                                    <button class="btn btn-light border border-start-0 bg-light text-muted" type="submit" style="border-radius: 0 10px 10px 0;">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Menampilkan pilihan filter berdasarkan kategori -->
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-grid me-2 text-primary"></i>Category</h6>

                            <div class="d-grid gap-2">
                                <a href="Produk?menu=shop<%= sortParam%><%= searchParam%>" 
                                   class="btn btn-sm text-start py-2 px-3 rounded-3 <%= currentCat.isEmpty() ? "btn-primary shadow-sm" : "btn-light border-0"%>">
                                    All Categories
                                </a>

                                <a href="Produk?menu=shop&category=FINE_ART<%= sortParam%><%= searchParam%>" 
                                   class="btn btn-sm text-start py-2 px-3 rounded-3 <%= "FINE_ART".equals(currentCat) ? "btn-primary shadow-sm" : "btn-light border-0"%>">
                                    Fine Art
                                </a>

                                <a href="Produk?menu=shop&category=DIGITAL_ART<%= sortParam%><%= searchParam%>" 
                                   class="btn btn-sm text-start py-2 px-3 rounded-3 <%= "DIGITAL_ART".equals(currentCat) ? "btn-primary shadow-sm" : "btn-light border-0"%>">
                                    Digital Art
                                </a>

                                <a href="Produk?menu=shop&category=HANDMADE_ART<%= sortParam%><%= searchParam%>" 
                                   class="btn btn-sm text-start py-2 px-3 rounded-3 <%= "HANDMADE_ART".equals(currentCat) ? "btn-primary shadow-sm" : "btn-light border-0"%>">
                                    Handmade Art
                                </a>
                            </div>
                        </div>
                    </div>
                </aside>

                <!-- Products -->
                <main class="col-md-9">
                    <div class="d-flex justify-content-between mb-3">
                        <!-- BAGIAN SEARCH -->
                        <form action="Produk" method="GET" class="w-50">
                            <input type="hidden" name="menu" value="shop">
                            <% if (!currentCat.isEmpty()) {%> <input type="hidden" name="category" value="<%= currentCat%>"> <% } %>
                            <% if (!currentSort.isEmpty()) {%> <input type="hidden" name="sort" value="<%= currentSort%>"> <% }%>

                            <div class="input-group">
                                <input name="search" class="form-control" placeholder="Search by name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : ""%>">
                                <button class="btn btn-outline-secondary" type="submit"><i class="bi bi-search"></i></button>
                            </div>
                        </form>
                        <%
                            // Ambil nilai kategori saat ini
                            currentCat = request.getParameter("category");
                            if (currentCat == null) {
                                currentCat = "";
                            }
                            String catParam = currentCat.isEmpty() ? "" : "&category=" + currentCat;
                        %>

                        <select class="form-select w-25" onchange="location = this.value;">
                            <option value="Produk?menu=shop<%= catParam%>">Sort by</option>
                            <option value="Produk?menu=shop<%= catParam%>&sort=price_low" <%= "price_low".equals(currentSort) ? "selected" : ""%>>Price: Low to High</option>
                            <option value="Produk?menu=shop<%= catParam%>&sort=price_high" <%= "price_high".equals(currentSort) ? "selected" : ""%>>Price: High to Low</option>
                            <option value="Produk?menu=shop<%= catParam%>&sort=newest" <%= "newest".equals(currentSort) ? "selected" : ""%>>Newest</option>
                        </select>
                    </div>

                    <div class="row g-4">

                        <!-- Menampilkan daftar produk -->
                        <%
                            ArrayList<Produk> prods = (ArrayList<Produk>) request.getAttribute("list");
                            
                            if (prods != null && !prods.isEmpty()) {
                                for (Produk p : prods) {
                                    String url = p.getImageUrl();
                                    String nama = p.getNama();
                                    double harga = p.getHarga();
                                    Seniman s = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));
                                    User sekolah = new User().find("idUser", String.valueOf(s.getIdUser()));
                                    out.print("<div class='col-md-4'>");
                                    out.print("<div class='card product-card'>");
                                    out.print("<img src= '" + url + "' class='product-img'>");
                                    out.print("<div class='card-body text-center'>");
                                    out.print("<h6>" + nama + "</h6>");
                                    out.print("<p class='small text-muted mb-2'><i class='bi bi-building me-1'></i>" + sekolah.getNama() + "</p>");
                                    out.print("<p class='mb-2'><strong>Rp" + String.format("%,.0f", harga) + "</strong></p>");
                                    if (userSession == null || !"SEKOLAH".equals(userSession.getRole())) {
                                        out.print("<div class='d-flex justify-content-around'>");
                                        // Tombol VIEW
                                        out.print("<a href='Produk?menu=view&id=" + p.getIdProduk() + "' class='btn btn-sm btn-view-custom rounded-pill px-3'><i class='bi bi-eye'></i> View</a>");
                                        // Tombol ADD
                                        out.print("<form action='CartServlet' method='POST' style='display:inline;'>");
                                        out.print("<input type='hidden' name='action' value='add'>");
                                        out.print("<input type='hidden' name='id' value='" + p.getIdProduk() + "'>");
                                        out.print("<button type='submit' class='btn btn-sm btn-add-custom rounded-pill px-3 shadow-sm'>");
                                        out.print("<i class='bi bi-cart'></i> Add");
                                        out.print("</button>");
                                        out.print("</form>");
                                    } else {
                                        out.print("<div class='d-flex justify-content-center'>");
                                        // Tombol VIEW
                                        out.print("<a href='Produk?menu=view&id=" + p.getIdProduk() + "' class='btn btn-sm btn-view-custom rounded-pill px-3'><i class='bi bi-eye'></i> View</a>");
                                    }
                                    out.print("</div>");
                                    out.print("</div>");
                                    out.print("</div>");
                                    out.print("</div>");
                                }
                            }
                        %>
                    </div>
                </main>

            </div>
        </div>

        <!-- FOOTER -->
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