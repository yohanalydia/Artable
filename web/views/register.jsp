<%@page import="model.User"%>
<%@page import="model.Notifikasi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Daftar - Artable</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <!-- GOOGLE FONTS -->
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background-color: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            .register-card {
                max-width: 550px;
                margin: 50px auto;
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            }
            .btn-purple {
                background: #6f42c1;
                color: white;
                border-radius: 12px;
                font-weight: 600;
                transition: 0.3s;
                padding: 12px;
            }
            .btn-purple:hover {
                background: #5a369d;
                color: white;
                transform: translateY(-2px);
            }
            .form-label {
                font-weight: 600;
                font-size: 0.9rem;
                color: #555;
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
                        <a href="Auth?type=register" class="text-decoration-none text-danger fw-bold">Register</a>
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

        <!-- Menampilkan Form Register -->
        <div class="container">
            <div class="card register-card p-4 p-md-5">
                <div class="text-center mb-5">
                    <h3 class="fw-bold text-dark mb-2">Register Here</h3>
                    <p class="text-muted small">Silahkan lengkapi data diri Anda untuk bergabung</p>
                </div>

                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger py-2 border-0 small" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2"></i> <%= request.getAttribute("error")%>
                </div>
                <% }%>

                <form action="Auth" method="POST">
                    <input type="hidden" name="action" value="register">

                    <div class="mb-3">
                        <label class="form-label">Daftar Sebagai</label>
                        <select class="form-select bg-light" name="role" required>
                            <option value="" disabled selected>Pilih tipe akun...</option>
                            <option value="PEMBELI">Pembeli (Kolektor/Umum)</option>
                            <option value="SEKOLAH">Sekolah / Institusi Seni</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nama Lengkap</label>
                            <input type="text" name="nama" class="form-control bg-light" placeholder="Contoh: Budi Santoso" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control bg-light" placeholder="budisantoso99" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Alamat Email</label>
                        <input type="email" name="email" class="form-control bg-light" placeholder="nama@email.com" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control bg-light" placeholder="Minimal 6 karakter" required minlength="6">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nomor Telepon</label>
                            <input type="text" name="nomorTelepon" class="form-control bg-light" placeholder="08123xxx" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Alamat Lengkap</label>
                        <textarea name="alamat" class="form-control bg-light" rows="3" placeholder="Jl. Seni No. 123, Jakarta" required></textarea>
                    </div>

                    <div id="rekeningSection" style="display: none;">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-purple">Tipe Rekening / Nama Bank</label>
                                <input type="text" id="tipeRekening" name="tipeRekening" class="form-control bg-light border-primary" placeholder="Contoh: BCA / Mandiri / Dana">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-purple">Nomor Rekening</label>
                                <input type="text" id="nomorRekening" name="nomorRekening" class="form-control bg-light border-primary" placeholder="1234567890">
                            </div>
                        </div>
                        <div class="alert alert-info py-2 small border-0">
                            <i class="bi bi-info-circle-fill me-2"></i> Rekening ini akan digunakan pembeli untuk mentransfer pembayaran karya.
                        </div>
                    </div>

                    <button type="submit" class="btn btn-purple w-100 py-2 shadow-sm">Daftar Sekarang</button>

                    <div class="text-center mt-4 small text-muted">
                        Sudah punya akun? <a href="Auth" class="text-decoration-none fw-bold">Masuk di sini</a>
                    </div>
                </form>
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
        <script>
            // Tambahkan event listener ketika pilihan role berubah
            document.querySelector('select[name="role"]').addEventListener('change', function () {
                const rekeningSection = document.getElementById('rekeningSection'); // Section input rekening
                const tipeInput = document.getElementById('tipeRekening');           // Input tipe rekening
                const nomorInput = document.getElementById('nomorRekening');         // Input nomor rekening

                if (this.value === 'SEKOLAH') {
                    // Jika role SEKOLAH, tampilkan section rekening dan buat required
                    rekeningSection.style.display = 'block';
                    tipeInput.setAttribute('required', 'required');
                    nomorInput.setAttribute('required', 'required');
                } else {
                    // Jika bukan SEKOLAH, sembunyikan section rekening dan hapus required
                    rekeningSection.style.display = 'none';
                    tipeInput.removeAttribute('required');
                    nomorInput.removeAttribute('required');

                    // Kosongkan value agar tidak terkirim secara tidak sengaja
                    tipeInput.value = '';
                    nomorInput.value = '';
                }
            });
        </script>

    </body>
</html>