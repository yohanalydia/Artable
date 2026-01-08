<%@page import="model.Notifikasi"%>
<%@page import="model.Seniman, model.User, java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detail Sekolah - Artable</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                background: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size: 14px;
                background: #eef1f8;
            }
            .text-purple {
                color: #6f42c1;
            }
            .bg-purple {
                background-color: #6f42c1;
                color: white;
            }
            .btn-purple {
                background: #6f42c1;
                color: white;
                border-radius: 12px;
                transition: 0.3s;
                border: none;
            }
            .btn-purple:hover {
                background: #5a369d;
                color: white;
                transform: translateY(-2px);
            }

            /* Profile Header */
            .school-profile-card {
                background: white;
                border-radius: 24px;
                padding: 40px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.03);
                margin-top: -50px;
                position: relative;
                z-index: 10;
            }
            .profile-banner {
                height: 200px;
                background: #d2c9ff;
                border-radius: 0 0 40px 40px;
            }
            .school-logo {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border: 5px solid white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            /* Artist Card */
            .artist-card {
                border: none;
                border-radius: 20px;
                transition: 0.4s;
                background: white;
            }
            .artist-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(111, 66, 193, 0.12);
            }
            .artist-img {
                height: 250px;
                object-fit: cover;
                border-radius: 20px 20px 0 0;
            }
            .stats-box {
                background: #f8f6ff;
                border-radius: 15px;
                padding: 15px;
            }
        </style>
    </head>
    <body>

        <%
            // Mengambil data dari Servlet
            User sekolah = (User) request.getAttribute("sekolah");
            ArrayList<Seniman> listSeniman = (ArrayList<Seniman>) request.getAttribute("listSeniman");
            User userSession = (User) session.getAttribute("user");
        %>

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

        <div class="profile-banner"></div>
        
        <!-- DETAIL SEKOLAH -->
        <div class="container">
            <% if (sekolah != null) {%>
            <div class="school-profile-card">
                <div class="row align-items-center">
                    <div class="col-md-3 text-center text-md-start">
                        <img src="<%= (sekolah.getImageUrl() != null && !sekolah.getImageUrl().isEmpty()) ? sekolah.getImageUrl() : "https://via.placeholder.com/150"%>" 
                             class="rounded-circle school-logo mb-3 mb-md-0" alt="Logo Sekolah">
                    </div>
                    <div class="col-md-6 text-center text-md-start">
                        <h2 class="fw-bold text-dark mb-1"><%= sekolah.getNama()%></h2>
                        <p class="text-muted"><i class="bi bi-geo-alt-fill text-purple me-1"></i> <%= sekolah.getAlamat()%></p>
                        <div class="d-flex gap-3 justify-content-center justify-content-md-start mt-3">
                            <div class="stats-box text-center">
                                <span class="d-block small text-muted">Telepon</span>
                                <span class="fw-bold text-purple"><%= sekolah.getNomorTelepon()%></span>
                            </div>
                            <div class="stats-box text-center">
                                <span class="d-block small text-muted">Total Seniman</span>
                                <span class="fw-bold text-purple"><%= (listSeniman != null) ? listSeniman.size() : 0%></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 text-center text-md-end mt-4 mt-md-0">
                        <a href="https://wa.me/<%= sekolah.getNomorTelepon()%>" class="btn btn-purple px-4 py-2">
                            <i class="bi bi-chat-dots me-2"></i>Hubungi Sekolah
                        </a>
                    </div>
                </div>
            </div>

            <!-- Menampilkan daftar seniman pada sekolah tersebut -->
            <div class="py-5">
                <div class="d-flex align-items-center mb-4">
                    <h3 class="fw-bold text-purple mb-0">Seniman Kami</h3>
                    <div class="ms-3 flex-grow-1 border-top" style="opacity: 0.1;"></div>
                </div>

                <div class="row g-4">
                    <%
                        if (listSeniman != null && !listSeniman.isEmpty()) {
                            for (Seniman s : listSeniman) {
                    %>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card artist-card h-100 shadow-sm">
                            <img src="<%= (s.getImageUrl() != null) ? s.getImageUrl() : "https://via.placeholder.com/300x400"%>" 
                                 class="card-img-top artist-img" alt="<%= s.getNama()%>">
                            <div class="card-body text-center">
                                <h6 class="fw-bold mb-1"><%= s.getNama()%></h6>
                                <a href="SenimanServlet?menu=view&id=<%= s.getIdSeniman()%>" class="btn btn-sm btn-view-custom rounded-pill px-3" style="background-color: #d2c9ff; color: #6f42c1;">
                                    <i class="bi bi-eye me-1"></i> View Profile
                                </a>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="col-12 text-center py-5">
                        <div class="text-muted">
                            <i class="bi bi-people mb-3" style="font-size: 3rem;"></i>
                            <p>Belum ada seniman yang terdaftar di sekolah ini.</p>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-danger mt-5 text-center">Data sekolah tidak ditemukan!</div>
            <% }%>
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