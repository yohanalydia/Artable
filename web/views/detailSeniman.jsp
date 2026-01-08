<%@page import="model.Produk"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detail Seniman - Artable</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <!-- GOOGLE FONTS -->
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background: #f6f7fb;
                color: #4b566b;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size: 14px;
                background: #eef1f8;
            }
            .product-detail-card {
                background: #fff;
                border: 1px solid #eaeaea;
                border-radius: 20px; /* Lebih bulat agar modern */
            }
            .img-container img {
                transition: transform 0.3s ease;
            }
            .img-container img:hover {
                transform: scale(1.02); /* Efek zoom halus pada foto seniman */
            }
            /* Tombol Ungu Custom */
            .btn-purple {
                background-color: #6f42c1;
                color: white;
                border: none;
                font-weight: 600;
                transition: 0.3s;
            }
            .btn-purple:hover {
                background-color: #5a369d;
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(111, 66, 193, 0.3);
            }
            /* Style untuk tabel info */
            .info-table {
                background-color: #f8f9fa;
                border-left: 4px solid #d2c9ff;
            }
            /* Breadcrumb custom */
            .breadcrumb-item a {
                color: #6f42c1;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
            /* Tambahan untuk kartu produk */
            .product-card {
                transition: transform 0.3s ease;
            }
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(111, 66, 193, 0.1) !important;
            }
            .text-purple {
                color: #6f42c1;
            }
            .btn-purple {
                background-color: #6f42c1;
                color: white;
                border: none;
            }
            .btn-purple:hover {
                background-color: #5a369d;
                color: white;
            }
        </style>
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
                    <a href="Produk?menu=shop" class="text-decoration-none text-dark">Shop</a>
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
                        // Menampilkan tombol untuk login dan register jika user belum login
                        if (userSession == null) {
                    %>
                    <a href="/Auth" class="text-decoration-none text-dark">Login</a> /
                    <a href="/Auth?type=register" class="text-decoration-none text-dark">Register</a>
                    <%
                        // Menampilkan nama user yang sedang login beserta tombol logout
                    } else {
                    %>
                    <span class="fw-bold me-2">Hi, <a href="Auth?type=profil" class="text-decoration-none" style="color: #6f42c1;"> <%= userSession.getNama()%> </a> </span>
                    <a href="/Auth?logout=true" class="text-danger text-decoration-none small">Logout</a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <!-- DETAIL SENIMAN -->
    <%
        // Ambil objek seniman 's' yang dikirim oleh Servlet
        model.Seniman s = (model.Seniman) request.getAttribute("s");
        if (s == null) {
            response.sendRedirect("Produk?menu=shop"); // Kembalikan jika data tidak ada
            return;
        }
    %>

    <div class="container my-5">
        <div class="product-detail-card p-4 shadow-sm bg-white rounded-4">
            <div class="row g-5 align-items-center">

                <div class="col-md-5">
                    <div class="img-container text-center">
                        <img src="<%= s.getImageUrl()%>" 
                             class="img-fluid rounded-4 shadow-sm" 
                             style="max-height: 450px; width: 100%; object-fit: cover;" 
                             alt="<%= s.getNama()%>">
                    </div>
                </div>

                <div class="col-md-7">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb small">
                            <li class="breadcrumb-item"><a href="Home" class="text-decoration-none">Home</a></li>
                            <li class="breadcrumb-item active">Seniman</li>
                        </ol>
                    </nav>

                    <h1 class="fw-bold mb-2"><%= s.getNama()%></h1>

                    <div class="mb-3">
                        <span class="badge rounded-pill px-3 py-2" style="background-color: #d2c9ff; color: #6f42c1;">
                            <i class="bi bi-person-check-fill me-1"></i> <%= s.getJenisDisabilitas()%>
                        </span>
                        <span class="badge rounded-pill px-3 py-2 bg-light text-dark border">
                            <i class="bi bi-gender-ambiguous me-1"></i> <%= s.getJenisKelamin()%>
                        </span>
                    </div>

                    <hr class="text-muted">

                    <div class="artist-bio mb-4">
                        <h5 class="fw-bold"><i class="bi bi-info-circle me-2"></i>Tentang Seniman</h5>
                        <p class="text-secondary" style="line-height: 1.8;">
                            <%= s.getTentangSaya()%>
                        </p>
                    </div>

                    <div class="info-table p-3 rounded-3" style="background-color: #f8f9fa;">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td class="fw-bold text-muted" width="150">Tanggal Lahir</td>
                                <td>: <%= s.getTanggalLahir()%></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-muted">Asal Sekolah</td>
                                <td class="text-dark fw-bold">: <%= (request.getAttribute("namaSekolah") != null) ? request.getAttribute("namaSekolah") : "-"%></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
                            
    <!-- Menampilkan daftar karya yang dibuat oleh seniman ini -->
    <div class="container pb-5">
        <div class="d-flex align-items-center mb-4">
            <h3 class="fw-bold text-purple m-0">Karya <%= s.getNama()%></h3>
            <div class="ms-3 flex-grow-1 border-top" style="opacity: 0.1;"></div>
        </div>

        <div class="row g-4">
            <%
                ArrayList<Produk> listKarya = (ArrayList<Produk>) request.getAttribute("listKarya");
                if (listKarya != null && !listKarya.isEmpty()) {
                    for (Produk p : listKarya) {
            %>
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden product-card">
                    <img src="<%= p.getImageUrl()%>" class="card-img-top" 
                         style="height: 200px; object-fit: cover;" alt="<%= p.getNama()%>">
                    <div class="card-body text-center p-3">
                        <h6 class="fw-bold mb-1"><%= p.getNama()%></h6>
                        <p class="text-purple fw-bold mb-3">Rp<%= String.format("%,.0f", p.getHarga())%></p>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                            <a href="Produk?menu=view&id=<%= p.getIdProduk()%>" 
                               class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                                <i class="bi bi-eye"></i> View
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12 text-center py-5">
                <p class="text-muted">Seniman ini belum memiliki karya yang diunggah.</p>
            </div>
            <% }%>
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
