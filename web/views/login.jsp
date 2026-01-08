<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Artable</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }

            .login-card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                background: white;
                width: 100%;
                max-width: 550px;
                margin: 60px auto;
            }

            .form-label {
                font-weight: 700;
                color: #999;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 8px;
            }

            /* Container Group */
            .input-group {
                border-radius: 12px;
                overflow: hidden;
                transition: 0.3s;
                border: 1px solid #eee; /* Border default abu-abu terang */
                background: #fcfdfe;
            }

            .input-group-text {
                background-color: transparent;
                border: none;
                color: #6f42c1;
                padding-left: 15px;
            }

            .form-control {
                border: none;
                background: transparent;
                padding: 12px 15px;
                font-weight: 600;
                color: #333;
            }

            .form-control:focus {
                box-shadow: none;
                background: transparent;
            }

            /* EFEK UNGU SOLID SAAT INPUT AKTIF */
            .input-group:focus-within {
                border-color: #6f42c1 !important; /* Outer border menjadi ungu solid */
                background: white;
            }

            .btn-purple {
                background: #6f42c1;
                color: white;
                border-radius: 12px;
                font-weight: 600;
                padding: 14px;
                transition: 0.3s;
                border: none;
                width: 100%;
            }

            .btn-purple:hover {
                background: #5a369d;
                transform: translateY(-2px);
                color: white;
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
                        <a href="https://wa.me/6281234567890" target="_blank" class="text-muted text-decoration-none hover-purple">Support</a>
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
                        <a href="${pageContext.request.contextPath}/Auth" class="text-decoration-none text-danger fw-bold">Login</a> /
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

        <div class="container">
            <div class="login-card p-4 p-md-5">

                <div class="text-center mb-5">
                    <h3 class="fw-bold text-dark mb-2">Welcome Back</h3>
                    <p class="text-muted small">Silahkan masuk menggunakan email terdaftar</p>
                </div>

                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger border-0 small py-3 mb-4 rounded-3" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2"></i> <%= request.getAttribute("error")%>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/Auth" method="POST">
                    <input type="hidden" name="action" value="login">

                    <div class="mb-4">
                        <label class="form-label">Email Address</label>
                        <div class="input-group shadow-sm">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="form-label">Password</label>
                        <div class="input-group shadow-sm">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="Masukkan password" required minlength="6">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-purple shadow-sm">
                        Masuk Sekarang
                    </button>
                </form>

                <div class="text-center mt-4">
                    <p class="small text-muted mb-0">
                        Belum punya akun? 
                        <a href="${pageContext.request.contextPath}/Auth?type=register" class="fw-bold text-decoration-none" style="color: #6f42c1;">Daftar Sekarang</a>
                    </p>
                </div>
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