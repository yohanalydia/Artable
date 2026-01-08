<%@page import="model.Notifikasi"%>
<%@page import="model.Seniman"%>
<%@page import="model.User"%>
<%@page import="model.Produk"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Detail - Artable</title>

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
                font-size:14px;
                background:#eef1f8;
            }
            .product-detail-card {
                background: #fff;
                border: 1px solid #eaeaea;
                border-radius: 10px;
                overflow: hidden;
            }
            .img-container {
                background: #fff;
                padding: 20px;
                border: 1px solid #f0f0f0;
                border-radius: 8px;
            }
            .product-img-detail {
                width: 100%;
                height: auto;
                object-fit: contain;
                max-height: 450px;
            }
            .price {
                font-size: 1.5rem;
                font-weight: 700;
                color: #333;
            }
            .btn-outline-primary-custom {
                border-color: #ffb30e;
                color: #ffb30e;
            }
            .btn-outline-primary-custom:hover {
                background: #ffb30e;
                color: #fff;
            }
            .nav-tabs .nav-link {
                color: #4b566b;
                border: none;
                border-bottom: 2px solid transparent;
                font-weight: 600;
            }
            .nav-tabs .nav-link.active {
                color: #81c408;
                border-bottom: 2px solid #81c408;
                background: none;
            }
            .form-control:focus {
                box-shadow: none;
                border-color: #81c408;
            }
            .quantity-control {
                max-width: 120px;
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

        <!-- DETAIL PRODUK -->
        <%
            // Ambil objek produk 'p' yang dititipkan oleh Servlet
            Produk p = (Produk) request.getAttribute("p");
            if (p == null) {
                response.sendRedirect("../Produk?menu=shop");
                return;
            }
        %>
        <div class="container my-5">
            <div class="product-detail-card p-4 shadow-sm">
                <div class="row g-5 align-items-center">

                    <div class="col-md-6">
                        <div class="img-container">
                            <img src="<%= p.getImageUrl()%>" class="product-img-detail" alt="<%= p.getNama()%>">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <% Seniman pembuat = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));%>
                        <a href="SenimanServlet?menu=view&id=<%= pembuat.getIdSeniman()%>" class="badge rounded-pill px-3 py-2" style="background-color: #d2c9ff; color: #6f42c1;">
                            <i class="bi bi-person-circle me-1"></i> <%= pembuat.getNama()%>
                        </a>
                        <br><br>
                        <h2 class="fw-bold mb-1">"<%= p.getNama()%>"</h2>
                        <p class="text-muted mb-3">Stok: <%=p.getStok()%> - Kategori: <%= p.getKategori()%></p>

                        <div class="price mb-2">Rp<%= String.format("%,.0f", p.getHarga())%></div>

                        <!--                        <div class="rating mb-3">
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star text-secondary"></i>
                                                </div>-->

                        <%
                            if (userSession == null || !"SEKOLAH".equals(userSession.getRole())) {
                        %>
                        <form action="CartServlet" method="POST" class="d-flex align-items-center gap-3 mb-4">
                            <input type="hidden" name="id" value="<%= p.getIdProduk()%>">

                            <input type="hidden" name="action" value="add">

                            <div class="input-group quantity-control">
                                <button class="btn btn-outline-secondary btn-sm" type="button" id="btn-minus">-</button>
                                <input type="number" id="input-qty" name="qty" class="form-control form-control-sm text-center" value="1" min="1" max="<%= p.getStok()%>">
                                <button class="btn btn-outline-secondary btn-sm" type="button" id="btn-plus">+</button>
                            </div>

                            <button type="submit" class="btn btn-outline-success rounded-pill px-4">
                                <i class="bi bi-bag-plus me-2"></i>Add to cart
                            </button>
                        </form>
                        <% }%>
                    </div>
                </div>

                <div class="mt-5">
                    <div class="d-flex justify-content-between align-items-center border-bottom mb-4">
                        <ul class="nav nav-tabs border-0" id="productTab" role="tablist" >
                            <li class="nav-item" >
                                <button class="nav-link active" 
                                        id="desc-tab" 
                                        data-bs-toggle="tab" 
                                        data-bs-target="#description" 
                                        type="button" 
                                        style="color: #6f42c1; border: none; border-bottom: 2px solid #6f42c1; background: none;">
                                    Description
                                </button>
                            </li>
                            <!--                        <li class="nav-item">
                                                        <button class="nav-link" id="review-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button">Reviews</button>
                                                    </li>-->
                        </ul>
                        <%
                            if (userSession != null
                                    && "SEKOLAH".equals(userSession.getRole())
                                    && pembuat != null
                                    && pembuat.getIdUser() == userSession.getIdUser()) {
                        %>
                        <div class="d-flex gap-2 mb-1">
                            <button class="btn btn-sm btn-outline-secondary rounded-pill" id="btn-edit-desc" onclick="toggleEditDesc()">
                                <i class="bi bi-pencil-square"></i> Edit Deskripsi
                            </button>
                            <form action="Produk?action=updateDeskripsi" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin menghapus deskripsi ini?')">
                                <input type="hidden" name="id" value="<%= p.getIdProduk()%>">
                                <input type="hidden" name="deskripsi baru" value="Deskripsi belum ditambahkan.">
                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                    <i class="bi bi-trash"></i> Hapus
                                </button>
                            </form>
                        </div>
                        <% }%>
                    </div>

                    <div class="tab-content" id="productTabContent">
                        <div class="tab-pane fade show active" id="description" role="tabpanel">

                            <div id="desc-text-wrapper">
                                <p id="current-desc"><%= p.getDeskripsi()%></p>
                            </div>

                            <div id="desc-form-wrapper" style="display: none;">
                                <form action="Produk?action=updateDeskripsi" method="POST">
                                    <input type="hidden" name="id" value="<%= p.getIdProduk()%>">
                                    <textarea name="deskripsi baru" class="form-control mb-2" rows="5" required><%= p.getDeskripsi()%></textarea>
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">Save Changes</button>
                                        <button type="button" class="btn btn-light btn-sm rounded-pill px-3" onclick="toggleEditDesc()">Cancel</button>
                                    </div>
                                </form>
                            </div>
                            <table class="table table-striped mt-3" style="max-width: 400px;">
                                <tr><td>Berat</td><td><%= p.getBerat()%></td></tr>
                                <tr><td>Dimensi</td><td><%= p.getDimensi()%></td></tr>
                                <tr><td>Material</td><td><%= p.getMaterial()%></td></tr>
                            </table>
                        </div>
                    </div>

                    <!--                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                                                <div class="mb-4">
                                                    <h5 class="fw-bold">Leave a Reply</h5>
                                                    <div class="row g-3 mt-2">
                                                        <div class="col-md-6">
                                                            <input type="text" class="form-control border-0 border-bottom" placeholder="Your Name *">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <input type="email" class="form-control border-0 border-bottom" placeholder="Your Email *">
                                                        </div>
                                                        <div class="col-12">
                                                            <textarea class="form-control border-0 border-bottom" rows="4" placeholder="Your Review *"></textarea>
                                                        </div>
                                                        <div class="col-12 d-flex justify-content-between align-items-center">
                                                            <div class="small">Please rate: 
                                                                <i class="bi bi-star text-muted"></i>
                                                                <i class="bi bi-star text-muted"></i>
                                                                <i class="bi bi-star text-muted"></i>
                                                                <i class="bi bi-star text-muted"></i>
                                                                <i class="bi bi-star text-muted"></i>
                                                            </div>
                                                            <button class="btn btn-outline-success rounded-pill px-4">Post Comment</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>-->
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


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
                                            // Fungsi untuk Toggle Form Edit Deskripsi (Bisa diletakkan di luar DOMContentLoaded)
                                            function toggleEditDesc() {
                                                const textWrapper = document.getElementById('desc-text-wrapper');
                                                const formWrapper = document.getElementById('desc-form-wrapper');
                                                const btnEdit = document.getElementById('btn-edit-desc');

                                                if (formWrapper.style.display === 'none') {
                                                    formWrapper.style.display = 'block';
                                                    textWrapper.style.display = 'none';
                                                    if (btnEdit)
                                                        btnEdit.style.display = 'none';
                                                } else {
                                                    formWrapper.style.display = 'none';
                                                    textWrapper.style.display = 'block';
                                                    if (btnEdit)
                                                        btnEdit.style.display = 'block';
                                                }
                                            }

                                            document.addEventListener('DOMContentLoaded', function () {
                                                // --- LOGIKA QUANTITY (CART) ---
                                                const btnMinus = document.getElementById('btn-minus');
                                                const btnPlus = document.getElementById('btn-plus');
                                                const inputQty = document.getElementById('input-qty');

                                                // Pastikan elemen ada (karena Sekolah tidak melihat tombol ini)
                                                if (btnMinus && btnPlus && inputQty) {
                                                    const maxStock = <%= p.getStok()%>;

                                                    btnPlus.addEventListener('click', function () {
                                                        let currentVal = parseInt(inputQty.value);
                                                        if (currentVal < maxStock) {
                                                            inputQty.value = currentVal + 1;
                                                        } else {
                                                            alert("Stok tidak mencukupi. Maksimal: " + maxStock);
                                                        }
                                                    });

                                                    btnMinus.addEventListener('click', function () {
                                                        let currentVal = parseInt(inputQty.value);
                                                        if (currentVal > 1) {
                                                            inputQty.value = currentVal - 1;
                                                        }
                                                    });

                                                    inputQty.addEventListener('change', function () {
                                                        let val = parseInt(this.value);
                                                        if (isNaN(val) || val < 1)
                                                            this.value = 1;
                                                        if (val > maxStock) {
                                                            this.value = maxStock;
                                                            alert("Jumlah melebihi stok tersedia!");
                                                        }
                                                    });
                                                }
                                            });
    </script>
</body>
</html>