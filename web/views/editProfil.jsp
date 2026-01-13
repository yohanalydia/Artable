<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <title>Edit Profil - Artable</title>
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

            /* Menyamakan shadow dan radius dengan profile-card */
            .edit-card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                background: white;
                overflow: hidden;
            }

            .form-label {
                font-weight: 700;
                color: #999;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .form-control {
                border-radius: 12px;
                padding: 12px;
                border: 1px solid #eee;
                background: #fcfdfe;
                font-weight: 600;
                color: #333;
            }
            .form-control:focus {
                border-color: #6f42c1;
                box-shadow: 0 0 0 0.25rem rgba(111, 66, 193, 0.1);
            }
            .form-control-readonly {
                background-color: #f8f9fa !important;
                cursor: not-allowed;
                color: #999;
            }

            .btn-save {
                background: #6f42c1;
                color: white;
                border-radius: 12px;
                font-weight: 600;
                padding: 12px;
                transition: 0.3s;
                width: 100%;
                border: none;
            }
            .btn-save:hover {
                background: #5a369d;
                transform: translateY(-2px);
                color: white;
            }

            .preview-img {
                width: 140px;
                height: 140px;
                object-fit: cover;
                border-radius: 50%;
                border: 5px solid white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            /* Style khusus header agar senada */
            .edit-header-bg {
                background: linear-gradient(135deg, #6f42c1 0%, #d2c9ff 100%);
                height: 120px;
                display: flex;
                align-items: center;
                padding: 0 30px;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
        </style>
    </head>
    <body>

        <%
            User u = (User) session.getAttribute("user");
            if (u == null) {
                response.sendRedirect("Auth");
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

        <!-- BAGIAN EDIT DATA PRIBADI USER -->
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="edit-card">
                        <div class="edit-header-bg" style="position: relative; display: flex; align-items: center; padding: 0 30px;">
                            <a href="Auth?type=profil" class="btn btn-white btn-sm rounded-pill shadow-sm bg-white px-3" style="position: relative; z-index: 10;">
                                <i class="bi bi-arrow-left me-1"></i> Batal
                            </a>

                            <h5 class="text-white fw-bold mb-0" 
                                style="position: absolute; left: 0; right: 0; text-align: center; margin: 0; pointer-events: none;">
                                Edit Informasi Profil
                            </h5>
                        </div>

                        <div class="card-body px-4 px-md-5 py-5">
                            <form action="Auth?action=updateProfil" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="id" value="<%= u.getIdUser()%>">

                                <div class="text-center mb-5" style="margin-top: -10px;">
                                    <div class="position-relative d-inline-block">
                                        <img src="<%= (u.getImageUrl() != null && !u.getImageUrl().isEmpty()) ? u.getImageUrl() : "assets/default-user.png"%>" 
                                             class="preview-img mb-3" id="imgPreview">
                                        <label for="foto" class="btn btn-sm btn-dark rounded-circle position-absolute bottom-0 end-0 mb-3 shadow" style="width: 35px; height: 35px; padding: 5px;">
                                            <i class="bi bi-camera"></i>
                                        </label>
                                        <input type="file" name="foto" id="foto" hidden accept="image/*" onchange="previewImage(this)">
                                    </div>
                                    <p class="text-muted small">Klik ikon kamera untuk ganti foto</p>
                                </div>

                                <div class="row g-4">
                                    <div class="col-12">
                                        <label class="form-label">Username</label>
                                        <input type="text" class="form-control form-control-readonly" value="<%= u.getUsername()%>" readonly>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Nama Lengkap / Instansi</label>
                                        <input type="text" name="nama" class="form-control" value="<%= u.getNama()%>" required>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Alamat Email</label>
                                        <input type="email" name="email" class="form-control" value="<%= u.getEmail()%>" required>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Nomor Telepon</label>
                                        <input type="text" name="nomorTelepon" class="form-control" value="<%= (u.getNomorTelepon() != null) ? u.getNomorTelepon() : ""%>">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Alamat Lengkap</label>
                                        <textarea name="alamat" class="form-control" rows="3"><%= (u.getAlamat() != null) ? u.getAlamat() : ""%></textarea>
                                    </div>
                                    <% if ("SEKOLAH".equals(u.getRole())) {%>
                                    <div class="col-12 mt-4 p-3 rounded-4" style="background: rgba(111, 66, 193, 0.05); border: 1px dashed #6f42c1;">
                                        <h6 class="fw-bold text-purple mb-3"><i class="bi bi-bank me-2"></i> Pengaturan Rekening Sekolah</h6>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Tipe Rekening / Bank</label>
                                                <input type="text" name="tipeRekening" class="form-control" 
                                                       value="<%= (u.getTipeRekening() != null) ? u.getTipeRekening() : ""%>" 
                                                       placeholder="Contoh: BCA, Mandiri, Dana">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Nomor Rekening</label>
                                                <input type="text" name="nomorRekening" class="form-control" 
                                                       value="<%= (u.getNomorRekening() != null) ? u.getNomorRekening() : ""%>" 
                                                       placeholder="Masukkan nomor rekening">
                                            </div>
                                        </div>
                                        <div class="form-text mt-2" style="font-size: 0.7rem;">
                                            * Informasi ini akan ditampilkan kepada pembeli saat mereka melakukan pembayaran.
                                        </div>
                                    </div>
                                    <% }%>

                                    <div class="col-12 mt-5">
                                        <button type="submit" class="btn btn-save shadow-sm py-3">
                                            <i class="bi bi-check2-circle me-2"></i>Simpan Perubahan
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
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
        <script>
            // Fungsi untuk menampilkan preview gambar sebelum diupload
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    // Setelah file dibaca, set hasilnya sebagai src <img id="imgPreview">
                    reader.onload = function (e) {
                        document.getElementById('imgPreview').src = e.target.result;
                    }

                    // Baca file sebagai URL data
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>