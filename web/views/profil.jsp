<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <title>Pengaturan Akun - Artable</title>
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
            .profile-card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                background: white;
                overflow: hidden;
            }
            .header-bg {
                background: linear-gradient(135deg, #6f42c1 0%, #d2c9ff 100%);
                height: 160px;
            }
            .profile-img-container {
                position: relative;
                margin-top: -75px;
                margin-bottom: 20px;
            }
            .profile-img {
                width: 140px;
                height: 140px;
                object-fit: cover;
                border-radius: 50%;
                border: 5px solid white;
                background: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
            .btn-outline-custom {
                border: 2px solid #eee;
                color: #666;
                border-radius: 12px;
                font-weight: 600;
                transition: 0.3s;
                padding: 12px;
            }
            .btn-outline-custom:hover {
                background: #f8f9fa;
                border-color: #ddd;
                color: #333;
            }
            .info-label {
                color: #999;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 5px;
            }
            .info-value {
                color: #333;
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 25px;
                display: block;
            }
            .role-badge {
                font-size: 0.7rem;
                padding: 5px 12px;
                border-radius: 50px;
                background: rgba(111, 66, 193, 0.1);
                color: #6f42c1;
                font-weight: 700;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
        </style>
    </head>
    <body>

        <%
            // Ambil data user dari session
            User u = (User) session.getAttribute("user");
            if (u == null) {
                response.sendRedirect("Auth"); // Paksa login jika belum
                return;
            }
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

        <!-- Menampilkan Profil user yang sedang login saat ini -->
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="profile-card">
                        <div class="header-bg d-flex justify-content-between p-4 align-items-start">
                            <a href="Home" class="btn btn-white btn-sm rounded-pill shadow-sm bg-white px-3">
                                <i class="bi bi-arrow-left me-1"></i> Kembali
                            </a>
                            <span class="role-badge bg-white shadow-sm">
                                <i class="bi bi-person-badge me-1"></i> <%= u.getRole()%>
                            </span>
                        </div>

                        <div class="card-body px-4 px-md-5 pb-5">
                            <div class="text-center profile-img-container">
                                <img src="<%= (u.getImageUrl() != null && !u.getImageUrl().isEmpty()) ? u.getImageUrl() : "assets/default-user.png"%>" 
                                     class="profile-img" alt="Foto Profil">
                                <h4 class="fw-bold mt-3 mb-1"><%= u.getNama()%></h4>
                                <p class="text-muted small">@<%= u.getUsername()%></p>
                            </div>

                            <div class="row mt-4">
                                <div class="col-12">
                                    <h6 class="fw-bold mb-4 mt-2"><i class="bi bi-info-circle me-2 text-primary"></i> Informasi Pribadi</h6>
                                </div>

                                <div class="col-md-6">
                                    <label class="info-label">Email</label>
                                    <span class="info-value"><%= u.getEmail()%></span>
                                </div>

                                <div class="col-md-6">
                                    <label class="info-label">Nomor Telepon</label>
                                    <span class="info-value"><%= (u.getNomorTelepon() != null && !u.getNomorTelepon().isEmpty()) ? u.getNomorTelepon() : "-"%></span>
                                </div>

                                <div class="col-12">
                                    <label class="info-label">Alamat Lengkap</label>
                                    <span class="info-value"><%= (u.getAlamat() != null && !u.getAlamat().isEmpty()) ? u.getAlamat() : "Alamat belum diatur"%></span>
                                </div>

                                <!-- Khusus untuk Sekolah -->
                                <% if ("SEKOLAH".equals(u.getRole())) {%>
                                <div class="col-12 mt-2">
                                    <h6 class="fw-bold mb-3"><i class="bi bi-bank me-2 text-primary"></i> Informasi Rekening</h6>
                                    <div class="row bg-light p-3 rounded-3 mx-0">
                                        <div class="col-md-6">
                                            <label class="info-label text-muted">Bank / Tipe</label>
                                            <span class="info-value mb-md-0"><%= (u.getTipeRekening() != null) ? u.getTipeRekening() : "-"%></span>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="info-label text-muted">Nomor Rekening</label>
                                            <span class="info-value mb-0"><%= (u.getNomorRekening() != null) ? u.getNomorRekening() : "-"%></span>
                                        </div>
                                    </div>
                                    <div class="form-text mt-2" style="font-size: 0.75rem;">
                                        <i class="bi bi-info-circle me-1"></i> Data ini digunakan agar pembeli dapat mentransfer pembayaran langsung ke sekolah Anda.
                                    </div>
                                </div>
                                <% }%>
                            </div>

                            <!-- Menampilkan tombol untuk mengedit profil, mengganti password, dan keluar dari akun -->
                            <div class="row g-3 mt-2">
                                <div class="col-md-6">
                                    <a href="Auth?type=editProfil" class="btn btn-purple w-100 shadow-sm">
                                        <i class="bi bi-pencil-square me-2"></i>Edit Profil
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-custom w-100 py-3" data-bs-toggle="modal" data-bs-target="#modalGantiPassword">
                                        <i class="bi bi-shield-lock me-2"></i>Ganti Password
                                    </button>
                                </div>
                                <div class="col-12 mt-4 text-center">
                                    <a href="Auth?logout=true" class="text-danger text-decoration-none small fw-bold" onclick="return confirm('Yakin ingin keluar?')">
                                        <i class="bi bi-box-arrow-right me-1"></i> Keluar dari Akun
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- BAGIAN MODAL UNTUK GANTI PASSWORD -->
        <div class="modal fade" id="modalGantiPassword" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 rounded-4 shadow">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="fw-bold"><i class="bi bi-key me-2 text-primary"></i>Keamanan Akun</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="Auth" method="POST" onsubmit="return validatePassword()">
                        <input type="hidden" name="action" value="changePass">

                        <div class="modal-body p-4">
                            <div id="passwordError" class="alert alert-danger d-none small p-2 rounded-3 mb-3">
                                <i class="bi bi-exclamation-circle me-1"></i> Konfirmasi password tidak cocok!
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">PASSWORD LAMA</label>
                                <input type="password" name="oldPass" class="form-control" required minlength="6">
                            </div>
                            <hr class="my-4">
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">PASSWORD BARU</label>
                                <input type="password" id="newPass" name="newPass" class="form-control" required minlength="6">
                                <div class="form-text" style="font-size: 0.75rem;">Minimal 6 karakter.</div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-bold text-muted">KONFIRMASI PASSWORD BARU</label>
                                <input type="password" id="confirmPass" name="confirmPass" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer border-0 px-4 pb-4">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Batal</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4" style="background: #6f42c1; border: none;">Simpan Password</button>
                        </div>
                    </form>
                </div>
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
                        function validatePassword() {
                            const newPass = document.getElementById('newPass').value;
                            const confirmPass = document.getElementById('confirmPass').value;
                            const errorDiv = document.getElementById('passwordError');

                            // Cek kesamaan password
                            if (newPass !== confirmPass) {
                                errorDiv.classList.remove('d-none');
                                errorDiv.innerHTML = "<i class='bi bi-exclamation-circle me-1'></i> Konfirmasi password baru tidak cocok!";
                                return false;
                            }

                            errorDiv.classList.add('d-none');
                            return true;
                        }

                        document.addEventListener('DOMContentLoaded', function () {
                            const urlParams = new URLSearchParams(window.location.search);
                            // Jika ada error dari servlet terkait password, buka modalnya lagi secara otomatis
                            if (urlParams.has('error') && urlParams.get('action') === 'changePass') {
                                var modalElement = document.getElementById('modalGantiPassword');
                                if (modalElement) {
                                    var myModal = new bootstrap.Modal(modalElement);
                                    myModal.show();

                                    const errorDiv = document.getElementById('passwordError');
                                    errorDiv.classList.remove('d-none');
                                    errorDiv.innerText = urlParams.get('error');
                                }
                            }
                        });

                        function validatePassword() {
                            const newPass = document.getElementById('newPass').value;
                            const confirmPass = document.getElementById('confirmPass').value;
                            const errorDiv = document.getElementById('passwordError');

                            // 1. Validasi Panjang Karakter (Minimal 6)
                            if (newPass.length < 6) {
                                errorDiv.classList.remove('d-none');
                                errorDiv.innerHTML = "<i class='bi bi-exclamation-circle me-1'></i> Password minimal harus 6 karakter!";
                                return false;
                            }

                            // 2. Cek kesamaan password
                            if (newPass !== confirmPass) {
                                errorDiv.classList.remove('d-none');
                                errorDiv.innerHTML = "<i class='bi bi-exclamation-circle me-1'></i> Konfirmasi password baru tidak cocok!";
                                return false;
                            }

                            errorDiv.classList.add('d-none');
                            return true;
                        }
        </script>
    </body>
</html>