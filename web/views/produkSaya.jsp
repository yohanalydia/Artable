<%@page import="model.Notifikasi"%>
<%@page import="model.User"%>
<%@page import="model.Produk"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // PROTEKSI HALAMAN: Hanya Role SEKOLAH yang boleh masuk
    User userSession = (User) session.getAttribute("user");
    if (userSession == null || !"SEKOLAH".equals(userSession.getRole())) {
        response.sendRedirect("Auth"); // Lempar ke login jika bukan sekolah
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Produk Saya - Artable</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                background: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            .shop-header {
                background: #d2c9ff;
                padding: 60px 0;
                border-radius: 0 0 50px 50px;
                text-align: center;
                margin-bottom: 40px;
            }
            .card-custom {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            }
            .product-img {
                height: 200px;
                object-fit: contain;
                background: #fff;
                padding: 10px;
            }
            .btn-purple {
                background: #6f42c1;
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: 600;
            }
            .btn-purple:hover {
                background: #5a369d;
                color: white;
            }
            .section-title {
                font-weight: 700;
                color: #333;
                position: relative;
                padding-bottom: 10px;
                margin-bottom: 25px;
            }
            .section-title::after {
                content: '';
                display: block;
                width: 50px;
                height: 4px;
                background: #d2c9ff;
                border-radius: 2px;
                margin-top: 8px;
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
                                    <a class="dropdown-item py-2 text-danger fw-bold" href="Produk?menu=myproduct">
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

        <!-- BAGIAN HEADER -->  
        <header class="shop-header">
            <div class="container">
                <h1 class="display-5 fw-bold">KELOLA PRODUK SAYA</h1>
                <p class="text-muted">Dashboard Sekolah: <%= userSession.getNama()%></p>
                <a href="Home" class="btn btn-sm btn-outline-dark rounded-pill px-3 mt-2"><i class="bi bi-arrow-left"></i> Kembali ke Home</a>
            </div>
        </header>

        <div class="container mb-5">
            <div class="row g-4">

                <!-- BAGIAN FORM ADD KARYA -->
                <div class="col-lg-4">
                    <div class="card card-custom p-4 sticky-top" style="top: 20px; z-index: 1000;">
                        <h4 class="section-title">Tambah Karya Baru</h4>
                        <form action="Produk?action=insert" method="POST" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Nama Karya</label>
                                <input type="text" name="nama" class="form-control" placeholder="Contoh: Lukisan Senja" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Deskripsi Produk</label>
                                <textarea name="deskripsi" class="form-control" rows="3" placeholder="Deskripsi produk..." required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Kategori</label>
                                <select name="kategori" class="form-select">
                                    <option value="FINE_ART">Fine Art</option>
                                    <option value="DIGITAL_ART">Digital Art</option>
                                    <option value="HANDMADE_ART">Handmade Art</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Harga (Rp)</label>
                                <input type="number" name="harga" class="form-control" placeholder="0" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Stok</label>
                                <input type="number" name="stok" class="form-control" placeholder="1" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Berat (kg)</label>
                                <input type="double" name="berat" class="form-control" placeholder="Contoh: 4,2" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Dimensi</label>
                                <input type="text" name="dimensi" class="form-control" placeholder="Contoh: 5 x 5 cm" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Material</label>
                                <input type="text" name="material" class="form-control" placeholder="Contoh: Tanah Liat" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Pilih Seniman Pembuat</label>
                                <select name="idSeniman" class="form-select" required>
                                    <option value="" disabled selected>Pilih Seniman...</option>
                                    <%
                                        // Ambil daftar seniman milik sekolah ini yang sudah dikirim dari Servlet
                                        ArrayList<model.Seniman> listSeniman = (ArrayList<model.Seniman>) request.getAttribute("listSeniman");
                                        if (listSeniman != null) {
                                            for (model.Seniman s : listSeniman) {
                                    %>
                                    <option value="<%= s.getIdSeniman()%>"><%= s.getNama()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                                <small class="text-muted">Daftarkan seniman di menu "Kelola Seniman" jika belum ada.</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Upload Foto Karya</label>
                                <input type="file" name="foto" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-purple w-100 py-2 shadow-sm">
                                <i class="bi bi-plus-circle me-2"></i>Posting Karya
                            </button>
                        </form>
                    </div>
                </div>

                <!-- BAGIAN KOLEKSI KARYA MASING-MASING SEKOLAH -->
                <div class="col-lg-8">
                    <h4 class="section-title text-center text-lg-start">Koleksi Karya Sekolah</h4>

                    <div class="row g-3">
                        <%
                            ArrayList<Produk> myProds = (ArrayList<Produk>) request.getAttribute("myProductList");
                            if (myProds == null || myProds.isEmpty()) {
                        %>
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-box-seam display-1 text-muted"></i>
                            <p class="text-muted mt-3">Belum ada produk yang diunggah.</p>
                        </div>
                        <%    
                        } else {
                            for (Produk p : myProds) {
                        %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden position-relative">
                                <span class="position-absolute top-0 end-0 badge rounded-pill bg-dark m-2">
                                    Stok: <%= p.getStok()%>
                                </span>

                                <img src="<%= p.getImageUrl()%>" class="product-img card-img-top" alt="<%= p.getNama()%>">
                                <div class="card-body text-center">
                                    <h6 class="fw-bold mb-1"><%= p.getNama()%></h6>
                                    <p class="text-purple fw-bold mb-3">Rp<%= String.format("%,.0f", p.getHarga())%></p>

                                    <div class="d-grid gap-2">
                                        <a href="Produk?menu=view&id=<%= p.getIdProduk()%>" class="btn btn-sm btn-outline-secondary rounded-pill">
                                            <i class='bi bi-eye'></i> View
                                        </a>
                                        <a href="Produk?menu=edit&id=<%= p.getIdProduk()%>" class="btn btn-sm btn-outline-secondary rounded-pill">
                                            <i class="bi bi-pencil-square"></i> Edit
                                        </a>

                                        <form action="Produk" method="POST" class="d-grid" onsubmit="return confirm('Hapus karya ini?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= p.getIdProduk()%>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                                <i class="bi bi-trash"></i> Hapus
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>