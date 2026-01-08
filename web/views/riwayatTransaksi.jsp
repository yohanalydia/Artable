<%@page import="model.Notifikasi"%>
<%@page import="model.DetailTransaksi, model.Produk, model.Transaksi, model.User, java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Riwayat Pesanan - Artable</title>
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
            .accordion-item {
                border: none;
                border-radius: 15px !important;
                overflow: hidden;
                margin-bottom: 20px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            .accordion-button:not(.collapsed) {
                background-color: #f8f6ff;
                color: #6f42c1;
                box-shadow: none;
            }
            .text-purple {
                color: #6f42c1;
            }
            .btn-purple {
                background: #6f42c1;
                color: white;
                border-radius: 10px;
                transition: 0.3s;
            }
            .btn-purple:hover {
                background: #5a369d;
                color: white;
            }
            .sekolah-box {
                background: #ffffff;
                border-left: 5px solid #6f42c1;
                border-radius: 12px;
                margin-bottom: 20px;
                border: 1px solid #eee;
                border-left: 5px solid #6f42c1;
            }
            .product-img {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 8px;
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
                        <a href="Transaksi" class="text-decoration-none text-danger fw-bold">Pesanan Saya</a>
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

        <!-- Menampilkan Riwayat Transaksi User -->
        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold m-0 text-purple">Riwayat Pesanan</h3>
                <a href="Produk?menu=shop" class="btn btn-sm btn-outline-secondary rounded-pill">
                    <i class="bi bi-arrow-left"></i> Kembali Belanja
                </a>
            </div>

            <div class="accordion" id="accordionTrx">
                <%
                    // Mengambil list transaksi yang telah dikirimkan servlet
                    ArrayList<Transaksi> list = (ArrayList<Transaksi>) request.getAttribute("listTransaksi");
                    if (list == null || list.isEmpty()) {
                %>
                <div class="text-center py-5">
                    <i class="bi bi-bag-x text-muted" style="font-size: 3rem;"></i>
                    <p class="mt-3 text-muted">Belum ada riwayat pesanan.</p>
                </div>
                <%    
                } else {
                    for (Transaksi t : list) {
                %>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%= t.getIdTransaksi()%>">
                            <div class="d-flex w-100 justify-content-between align-items-center me-3">
                                <div>
                                    <span class="fw-bold d-block text-purple">#TRX-<%= t.getIdTransaksi()%></span>
                                    <small class="text-muted"><%= t.getTanggalTransaksi()%></small>
                                </div>
                                <div class="text-end">
                                    <span class="fw-bold d-block">Rp<%= String.format("%,.0f", t.getTotalBayar())%></span>
                                </div>
                            </div>
                        </button>
                    </h2>

                    <div id="collapse<%= t.getIdTransaksi()%>" class="accordion-collapse collapse" data-bs-parent="#accordionTrx">
                        <div class="accordion-body bg-white p-4">
                            <%
                                // Ambil semua detail dari request attribute
                                ArrayList<DetailTransaksi> allDetails = (ArrayList<DetailTransaksi>) request.getAttribute("listAllDetails");

                                // Filter detail yang hanya milik transaksi ini (t.getIdTransaksi())
                                ArrayList<DetailTransaksi> details = new ArrayList<>();
                                if (allDetails != null) {
                                    for (DetailTransaksi dtCheck : allDetails) {
                                        if (dtCheck.getIdTransaksi() == t.getIdTransaksi()) {
                                            details.add(dtCheck);
                                        }
                                    }
                                }
                                
                                if (!details.isEmpty()) {
                                    int currentSekolahId = -1;
                                    double ongkir = 20000;

                                    // Menampilkan total harga pembelian per transaksi per sekolah
                                    for (DetailTransaksi dt : details) {
                                        if (dt.getIdSekolah() != currentSekolahId) {
                                            currentSekolahId = dt.getIdSekolah();
                                            User sekolah = new User().find("idUser", String.valueOf(dt.getIdSekolah()));
                                            
                                            double subtotalSklh = 0;
                                            for (DetailTransaksi hitung : details) {
                                                if (hitung.getIdSekolah() == currentSekolahId) {
                                                    subtotalSklh += (hitung.getQty() * hitung.getHargaSatuan());
                                                }
                                            }
                            %>
                            <div class="sekolah-box p-3 mb-4 shadow-sm">
                                <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                    <div>
                                        <h6 class="fw-bold mb-0 text-purple"><i class="bi bi-shop me-2"></i><%= (sekolah != null) ? sekolah.getNama() : "Sekolah"%></h6>
                                        <small class="text-muted">Transfer ke: <b><%= (sekolah != null) ? sekolah.getTipeRekening() + " " + sekolah.getNomorRekening() : "-"%></b></small>
                                    </div>
                                    <div>
                                        <%
                                            // Menyesuaikan warna tampilan status sesuai kondisi status saat ini
                                            String status = dt.getStatus();
                                            if ("Dibatalkan".equals(status)) { %>
                                        <span class="badge bg-danger rounded-pill px-3 py-2"><i class="bi bi-x-circle"></i> Dibatalkan</span>
                                        <%  } else if ("Dikirim".equals(status)) { %>
                                        <span class="badge bg-primary rounded-pill px-3 py-2"><i class="bi bi-truck"></i> Sedang Dikirim</span>
                                        <%  } else if ("Diproses".equals(status)) { %>
                                        <span class="badge bg-info rounded-pill px-3 py-2 text-white"><i class="bi bi-gear"></i> Diproses</span>
                                        <%  } else if ("Menunggu Verifikasi".equals(status)) { %>
                                        <span class="badge bg-warning rounded-pill px-3 py-2"><i class="bi bi-clock"></i> Verifikasi</span>
                                        <%  } else if ("Selesai".equals(status)) { %>
                                        <span class="badge bg-success rounded-pill px-3 py-2"><i class="bi bi-check-all"></i> Selesai</span>
                                        <%  } else if (dt.getBuktiTransfer() == null || dt.getBuktiTransfer().isEmpty()) {%>
                                        <div class="d-flex gap-2">
                                            <!-- FORM UNTUK MEMBATALKAN ORDERAN -->
                                            <form action="Transaksi?action=cancel_order" method="POST" onsubmit="return confirm('Batal?')">
                                                <input type="hidden" name="idTrx" value="<%= t.getIdTransaksi()%>">
                                                <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger px-2 rounded-pill small">Batal</button>
                                            </form>
                                            <button class="btn btn-sm btn-purple px-3 rounded-pill" data-bs-toggle="modal" data-bs-target="#modalBukti<%= t.getIdTransaksi()%>_<%= dt.getIdSekolah()%>">Upload Bukti</button>
                                        </div>
                                        <%  } else { %>
                                        <span class="badge bg-secondary rounded-pill px-3 py-2">Menunggu Bayar</span>
                                        <%  } %>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <!-- Menampilkan produk per sekolah per transaksi -->
                                    <% for (DetailTransaksi prod : details) {
                                            if (prod.getIdSekolah() == currentSekolahId) {
                                                Produk p = new Produk().find("idProduk", String.valueOf(prod.getIdProduk()));
                                    %>
                                    <div class="d-flex align-items-center mb-2 border-bottom pb-2">
                                        <img src="<%= (p != null) ? p.getImageUrl() : ""%>" class="product-img border">
                                        <div class="ms-3 flex-grow-1">
                                            <div class="small fw-bold text-dark"><%= (p != null) ? p.getNama() : "Produk"%></div>
                                            <div class="text-muted small"><%= prod.getQty()%> x Rp<%= String.format("%,.0f", prod.getHargaSatuan())%></div>
                                        </div>
                                        <div class="fw-bold small text-dark">Rp<%= String.format("%,.0f", prod.getQty() * prod.getHargaSatuan())%></div>
                                    </div>
                                    <%      }
                                        }%>
                                </div>

                                <div class="bg-light p-3 rounded small">
                                    <div class="d-flex justify-content-between text-muted mb-1">
                                        <span>Subtotal:</span>
                                        <span>Rp<%= String.format("%,.0f", subtotalSklh)%></span>
                                    </div>
                                    <div class="d-flex justify-content-between text-muted mb-1">
                                        <span>Ongkir:</span>
                                        <span>Rp<%= String.format("%,.0f", ongkir)%></span>
                                    </div>
                                    <div class="d-flex justify-content-between fw-bold text-purple border-top mt-2 pt-2 fs-6">
                                        <span>Total:</span>
                                        <span>Rp<%= String.format("%,.0f", subtotalSklh + ongkir)%></span>
                                    </div>
                                </div>

                                <!-- Menampilkan detail tambahan sesuai dengan kondisi status transaksi -->
                                <% if ("Dikirim".equals(dt.getStatus())) {%>
                                <div class="mt-3 p-3 bg-primary-subtle rounded-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <small class="text-muted">Kurir: <b><%= dt.getKurir()%></b></small><br>
                                            <small class="text-muted">Resi: <b class="text-primary"><%= dt.getNoResi()%></b></small>
                                        </div>
                                        <form action="Transaksi?action=selesaikan_pesanan" method="POST">
                                            <input type="hidden" name="idTrx" value="<%= t.getIdTransaksi()%>">
                                            <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                            <button type="submit" class="btn btn-sm btn-success rounded-pill fw-bold" onclick="return confirm('Sudah terima barang?')">Selesaikan Pesanan</button>
                                        </form>
                                    </div>
                                </div>
                                <% } else if ("Selesai".equals(dt.getStatus())) { %>
                                <div class="mt-3 p-2 bg-success-subtle text-success rounded-3 text-center small fw-bold">
                                    <i class="bi bi-heart-fill"></i> Pesanan Selesai.
                                </div>
                                <% }%>
                            </div>

                            <div class="modal fade" id="modalBukti<%= t.getIdTransaksi()%>_<%= dt.getIdSekolah()%>" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-sm">
                                    <!-- FORM UNTUK UPLOAD BUKTI TRANSFER PADA USER PEMBELI -->
                                    <form action="Transaksi?action=upload_bukti" method="POST" enctype="multipart/form-data" class="modal-content shadow">
                                        <div class="modal-body p-4 text-center">
                                            <h6 class="fw-bold mb-3">Upload Bukti Transfer</h6>
                                            <input type="hidden" name="idTrx" value="<%= t.getIdTransaksi()%>">
                                            <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                            <input type="file" name="fileBukti" class="form-control form-control-sm mb-3" accept="image/*" required>
                                            <button type="submit" class="btn btn-purple w-100 py-2">Kirim</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <%
                                        } // End if Grouping Sekolah
                                    } // End for DetailTransaksi
                                } // End if details
                                %>
                            <div class="mt-2 p-3 bg-light rounded-3 small border">
                                <i class="bi bi-geo-alt-fill text-danger"></i> <strong>Alamat:</strong> <%= t.getAlamatPengiriman()%>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        } // End for Transaksi
                    } // End if list empty
                    %>
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