<%@page import="model.User"%>
<%@page import="model.Notifikasi, java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Notifikasi - Artable</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                background: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .text-purple {
                color: #6f42c1;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            /* Custom Accordion Styling */
            .accordion-item {
                border: none;
                border-radius: 12px !important;
                margin-bottom: 15px;
                overflow: hidden;
                box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            }

            .accordion-button {
                transition: 0.3s;
            }

            /* Hilangkan outline default bootstrap */
            .accordion-button:focus {
                box-shadow: none;
                border-color: rgba(111, 66, 193, 0.2);
            }

            /* Icon Panah Custom */
            .accordion-button::after {
                background-size: 1rem;
            }

            .notif-time {
                font-size: 0.75rem;
                opacity: 0.7;
            }

            .empty-state {
                padding: 100px 0;
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
                        <a href="Notifikasi" class="text-danger fw-bold position-relative text-decoration-none">
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
                    
        <div class="container py-5" style="max-width: 700px;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0 text-purple">Notifikasi</h3>
                    <p class="text-muted small m-0">Informasi terbaru mengenai pesanan Anda</p>
                </div>
                <a href="Home" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                    <i class="bi bi-house-door"></i> Beranda
                </a>
            </div>

            <div class="accordion" id="accordionNotif">
                <%
                    ArrayList<Notifikasi> list = (ArrayList<Notifikasi>) request.getAttribute("listNotif");
                    if (list == null || list.isEmpty()) {
                %>
                <div class="text-center empty-state bg-white rounded-4 shadow-sm border">
                    <i class="bi bi-bell-slash text-muted" style="font-size: 4rem;"></i>
                    <h5 class="mt-3 fw-bold">Belum ada notifikasi</h5>
                    <p class="text-muted small">Semua kabar terbaru akan muncul di sini.</p>
                </div>
                <%
                } else {
                    int i = 0;
                    for (Notifikasi n : list) {
                        i++;
                        // Logika Warna: Unread = Kuning (Warning), Read = Hijau (Success)
                        boolean isUnread = "unread".equals(n.getStatus());
                        String bgClass = isUnread ? "bg-warning-subtle" : "bg-success-subtle";
                        String textClass = isUnread ? "text-warning-emphasis" : "text-success-emphasis";
                        String iconClass = isUnread ? "bi-envelope-fill text-warning" : "bi-envelope-open text-success";
                %>
                <div class="accordion-item border">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed py-3 <%= bgClass%> <%= textClass%>" 
                                type="button" 
                                data-bs-toggle="collapse" 
                                data-bs-target="#collapseNotif<%= i%>"
                                onclick="markAsRead('<%= n.getIdNotifikasi()%>', this)">
                            <div class="d-flex align-items-center w-100 me-3">
                                <i class="bi <%= iconClass%> fs-5 me-3"></i>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-bold"><%= n.getJudul()%></span>
                                        <span class="notif-time"><%= n.getWaktu()%></span>
                                    </div>
                                </div>
                            </div>
                        </button>
                    </h2>
                    <div id="collapseNotif<%= i%>" class="accordion-collapse collapse" data-bs-parent="#accordionNotif">
                        <div class="accordion-body bg-white py-4 border-top">
                            <div class="text-dark mb-2">
                                <%= n.getPesan()%>
                            </div>
                            <% if (n.getPesan().toLowerCase().contains("pesanan") || n.getPesan().toLowerCase().contains("nota")) { %>
                            <div class="mt-3">
                                <a href="Transaksi?action=view" class="btn btn-sm btn-purple rounded-pill px-3" style="font-size: 0.75rem;">
                                    Lihat Transaksi
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>

            <p class="text-center text-muted mt-5" style="font-size: 0.7rem;">
                Notifikasi otomatis dihapus dalam 30 hari terakhir.
            </p>
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
        <script>
                                    function markAsRead(idNotif, element) {
                                        // Cari apakah elemen ini masih punya class bg-warning-subtle (unread)
                                        if (element.classList.contains('bg-warning-subtle')) {

                                            // Kirim data ke servlet tanpa reload halaman
                                            fetch('Notifikasi', {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                },
                                                body: 'idNotif=' + idNotif
                                            })
                                                    .then(response => {
                                                        // Ubah tampilan secara langsung di browser setelah sukses update di DB
                                                        element.classList.remove('bg-warning-subtle', 'text-warning-emphasis');
                                                        element.classList.add('bg-success-subtle', 'text-success-emphasis');

                                                        // Opsional: Ubah icon amplop dari tertutup ke terbuka
                                                        const icon = element.querySelector('.bi-envelope-fill');
                                                        if (icon) {
                                                            icon.classList.remove('bi-envelope-fill', 'text-warning');
                                                            icon.classList.add('bi-envelope-open', 'text-success');
                                                        }
                                                    });
                                        }
                                    }
        </script>
    </body>
</html>