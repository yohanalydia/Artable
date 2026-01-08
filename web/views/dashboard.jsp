<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Artable</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-purple: #6f42c1;
                --light-purple: #a951ed;
                --bg-body: #f4f2f7;
            }
            
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            
            body {
                background:#f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }

            .dashboard-card {
                border-radius: 15px;
                border: none;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                transition: transform 0.2s;
            }

            .dashboard-card:hover {
                transform: translateY(-5px);
            }

            .card-purple-gradient {
                background: linear-gradient(135deg, var(--primary-purple), var(--light-purple));
                color: white;
            }

            .text-purple {
                color: var(--primary-purple);
            }

            .chart-container {
                position: relative;
                height: 300px;
                width: 100%;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
        </style>
    </head>
    <body>

        <%
            // Mengambil data dari Servlet
            String totalPendapatan = (request.getAttribute("totalPendapatan") != null) ? request.getAttribute("totalPendapatan").toString() : "0";
            String totalKarya = (request.getAttribute("totalKarya") != null) ? request.getAttribute("totalKarya").toString() : "0";
            String totalSiswa = (request.getAttribute("totalSiswa") != null) ? request.getAttribute("totalSiswa").toString() : "0";
            String totalPesanan = (request.getAttribute("totalPesanan") != null) ? request.getAttribute("totalPesanan").toString() : "0";
            String totalTerjual = (request.getAttribute("totalTerjual") != null) ? request.getAttribute("totalTerjual").toString() : "0";

            // Data Kategori untuk Pie Chart (Urutan: Fine Art, Digital Art, Handmade Art)
            String categoryData = (request.getAttribute("categoryData") != null) ? request.getAttribute("categoryData").toString() : "0, 0, 0";
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
                        <a href="Dashboard" class="bi bi-file-bar-graph text-decoration-none text-danger fw-bold">Dashboard</a>
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
                                    <a class="dropdown-item py-2 text-danger fw-bold" href="Dashboard">
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

        <div class="container py-5">
            <div class="mb-4">
                <h2 class="fw-bold text-dark">
                    <%
                        if ("SEKOLAH".equals(userSession.getRole())){
                            out.print("Laporan Sekolah");
                        }else if ("ADMIN".equals(userSession.getRole())){
                            out.print("Laporan Artable");
                        }
                    %>
                </h2>
                <p class="text-muted">Pantau ringkasan performa dan distribusi karya siswa.</p>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="card dashboard-card card-purple-gradient h-100 p-3 text-center">
                        <div class="card-body d-flex flex-column justify-content-center">
                            <h6 class="text-uppercase small fw-semibold opacity-75">Total Pendapatan</h6>
                            <h2 class="fw-bold mb-0 mt-2">Rp <%= totalPendapatan%></h2>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="row g-3">
                        <div class="col-6 col-sm-3">
                            <div class="card dashboard-card bg-white p-2 text-center border-bottom border-4 border-purple" style="border-bottom-color: var(--primary-purple) !important;">
                                <div class="card-body">
                                    <h6 class="text-muted small fw-semibold">Karya</h6>
                                    <h4 class="fw-bold mb-0"><%= totalKarya%></h4>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-sm-3">
                            <div class="card dashboard-card bg-white p-2 text-center border-bottom border-4 border-info">
                                <div class="card-body">
                                    <h6 class="text-muted small fw-semibold">Siswa</h6>
                                    <h4 class="fw-bold mb-0"><%= totalSiswa%></h4>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-sm-3">
                            <div class="card dashboard-card bg-white p-2 text-center border-bottom border-4 border-warning">
                                <div class="card-body">
                                    <h6 class="text-muted small fw-semibold">Pesanan Aktif</h6>
                                    <h4 class="fw-bold mb-0"><%= totalPesanan%></h4>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-sm-3">
                            <div class="card dashboard-card bg-white p-2 text-center border-bottom border-4 border-success">
                                <div class="card-body">
                                    <h6 class="text-muted small fw-semibold">Terjual</h6>
                                    <h4 class="fw-bold mb-0 text-success"><%= totalTerjual%></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card dashboard-card bg-white p-4">
                        <div class="text-center mb-4">
                            <h5 class="fw-bold m-0 text-purple">Distribusi Penjualan</h5>
                            <p class="text-muted small">Berdasarkan kategori Fine, Digital, dan Handmade Art</p>
                        </div>
                        <div class="chart-container">
                            <canvas id="categoryPieChart"></canvas>
                        </div>
                    </div>
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

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const ctx = document.getElementById('categoryPieChart').getContext('2d');
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Fine Art', 'Digital Art', 'Handmade Art'],
                    datasets: [{
                            data: [<%= categoryData%>],
                            backgroundColor: ['#4b2a89', '#6f42c1', '#d1b3ff'],
                            hoverOffset: 25,
                            borderWidth: 4,
                            borderColor: '#ffffff'
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: {size: 14, weight: '600'}
                            }
                        }
                    }
                }
            });
        </script>
    </body>
</html>