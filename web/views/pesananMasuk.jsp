<%@page import="model.Notifikasi"%>
<%@page import="model.DetailTransaksi, model.Produk, model.Transaksi, model.User, java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Pesanan Masuk - Artable</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                background:#f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .nota-box {
                background: white;
                border-radius: 15px;
                border: 1px solid #ddd;
                overflow: hidden;
                margin-bottom: 25px;
            }
            .topbar {
                font-size:14px;
                background:#eef1f8;
            }
            .text-purple {
                color: #6f42c1;
            }
            .nota-header {
                background: #f8f9fa;
                padding: 15px 20px;
                border-bottom: 1px solid #eee;
            }
            .product-img {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 8px;
            }
            .bg-purple {
                background-color: #6f42c1 !important;
                color: white !important;
            }
            .btn-purple {
                background: #6f42c1;
                color: white;
                border: none;
            }
            .btn-purple:hover {
                background: #5a369d;
                color: white;
            }
            .hover-purple:hover {
                color: #6f42c1 !important;
                transition: 0.3s;
            }
        </style>
    </head>
    <body class="bg-light">
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
                                    <a class="dropdown-item py-2 text-danger fw-bold" href="Transaksi">
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

        <div class="container py-5">
            <h3 class="fw-bold mb-4 text-purple">Daftar Pesanan Masuk</h3>

            <!-- Menampilkan daftar pesanan masuk ke akun sekolah -->
            <%
                ArrayList<DetailTransaksi> list = (ArrayList<DetailTransaksi>) request.getAttribute("daftarPesanan");
                if (list == null || list.isEmpty()) {
            %>
            <div class="text-center py-5 bg-white rounded-3 shadow-sm">
                <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                <p class="mt-3 text-muted">Belum ada pesanan yang masuk ke sekolah Anda.</p>
            </div>
            <%
            } else {
                int currentTrxId = -1; // Penanda untuk grouping

                for (DetailTransaksi dt : list) {
                    // JIKA ID TRANSAKSI BERBEDA, BUAT HEADER NOTA BARU
                    if (dt.getIdTransaksi() != currentTrxId) {
                        currentTrxId = dt.getIdTransaksi();

                        // Ambil data pembeli dari tabel Transaksi utama
                        Transaksi trxUtama = new Transaksi().find("idTransaksi", String.valueOf(currentTrxId));
                        User pembeli = new User().find("idUser", String.valueOf(trxUtama.getIdPembeli()));

                        double totalNotaSekolah = 0;
                        for (DetailTransaksi hitung : list) {
                            if (hitung.getIdTransaksi() == currentTrxId) {
                                totalNotaSekolah += (hitung.getQty() * hitung.getHargaSatuan());
                            }
                        }
            %>
            <div class="nota-box shadow-sm">
                <div class="nota-header d-flex justify-content-between align-items-center">
                    <div>
                        <span class="badge bg-purple mb-1">Nota #<%= currentTrxId%></span>
                        <h6 class="fw-bold mb-0">Pembeli: <%= (pembeli != null) ? pembeli.getNama() : "User"%></h6>
                        <small class="text-muted"><%= trxUtama.getTanggalTransaksi()%></small>
                    </div>
                    <div class="text-end">
                        <div class="small text-muted">Total Tagihan (Belum Ongkir):</div>
                        <h5 class="fw-bold text-dark mb-0">Rp<%= String.format("%,.0f", totalNotaSekolah)%></h5>
                    </div>
                </div>

                <div class="p-3">
                    <table class="table table-sm table-borderless mb-3">
                        <thead>
                            <tr class="text-muted small border-bottom">
                                <th>Produk</th>
                                <th class="text-center">Qty</th>
                                <th class="text-end">Harga</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Loop kedua untuk menampilkan semua produk di bawah nota yang sama
                                for (DetailTransaksi prod : list) {
                                    if (prod.getIdTransaksi() == currentTrxId) {
                                        Produk p = new Produk().find("idProduk", String.valueOf(prod.getIdProduk()));
                            %>
                            <tr class="align-middle">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="<%= (p != null) ? p.getImageUrl() : ""%>" class="product-img me-2 border">
                                        <span class="small fw-semibold"><%= (p != null) ? p.getNama() : "Produk Dihapus"%></span>
                                    </div>
                                </td>
                                <td class="text-center small"><%= prod.getQty()%></td>
                                <td class="text-end small">Rp<%= String.format("%,.0f", prod.getHargaSatuan())%></td>
                                <td class="text-end small fw-bold">Rp<%= String.format("%,.0f", prod.getQty() * prod.getHargaSatuan())%></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>


                    <div class="d-flex justify-content-between align-items-center border-top pt-3">
                        <div>
                            <span class="small text-muted">Status: </span>
                            <span class="badge rounded-pill 
                                  <!-- Menampilkan warna sesuai status -->
                                  <%= "Menunggu Verifikasi".equals(dt.getStatus()) ? "bg-info"
                                          : "Diproses".equals(dt.getStatus()) ? "bg-purple"
                                          : "Dikirim".equals(dt.getStatus()) || "Selesai".equals(dt.getStatus()) ? "bg-success"
                                          : "Dibatalkan".equals(dt.getStatus()) ? "bg-danger"
                                          : "bg-secondary"%>">
                                <%= dt.getStatus()%>
                            </span>
                        </div>

                        <div class="text-end">
                            <!-- Menampilkan pilihan aksi sesuai dengan status transaksi saat ini -->
                            <% if ("Menunggu Verifikasi".equals(dt.getStatus())) {%>
                            <button class="btn btn-sm btn-purple px-4" data-bs-toggle="modal" data-bs-target="#modalCek<%= dt.getIdTransaksi()%>">
                                <i class="bi bi-search"></i> Periksa Bukti
                            </button>
                            <% } else if ("Diproses".equals(dt.getStatus())) {%>
                            <button class="btn btn-sm btn-dark px-4" data-bs-toggle="modal" data-bs-target="#modalKirim<%= dt.getIdTransaksi()%>">
                                <i class="bi bi-truck"></i> Kirim Barang
                            </button>
                            <% } else if ("Dikirim".equals(dt.getStatus()) || "Selesai".equals(dt.getStatus())) {%>
                            <div class="bg-light p-2 rounded border small">
                                <i class="bi bi-box-sealer text-success"></i> 
                                <strong><%= dt.getKurir()%></strong>: <%= dt.getNoResi()%>
                            </div>
                            <% } else { %>
                            <div class="d-flex align-items-center gap-2">
                                <span class="text-muted small italic"><i class="bi bi-clock"></i> Menunggu Bukti</span>
                                <% if ("Menunggu Pembayaran".equals(dt.getStatus())) {%>
                                <form action="Transaksi?action=cancel_order" method="POST" onsubmit="return confirm('Batalkan pesanan ini?')">
                                    <input type="hidden" name="idTrx" value="<%= dt.getIdTransaksi()%>">
                                    <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">Batalkan</button>
                                </form>
                                <% } %>
                            </div>
                            <% }%>
                        </div>
                    </div>

                    <!-- Modal untuk menampilkan bukti transfer per transaksi -->
                    <div class="modal fade" id="modalCek<%= dt.getIdTransaksi()%>" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <!-- Header modal: judul dengan nomor transaksi -->
                                <div class="modal-header">
                                    <h6 class="modal-title fw-bold">Bukti Transfer Nota #<%= dt.getIdTransaksi()%></h6>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <!-- Body modal: tampilkan gambar bukti transfer -->
                                <div class="modal-body text-center">
                                    <img src="<%= dt.getBuktiTransfer()%>" class="img-fluid rounded border mb-3">
                                    <!-- Form untuk verifikasi pembayaran -->
                                    <form action="Transaksi?action=verifikasi_pembayaran" method="POST">
                                        <input type="hidden" name="idTrx" value="<%= dt.getIdTransaksi()%>">
                                        <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                        <button type="submit" class="btn btn-success w-100 py-2">Terima Pembayaran & Proses</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal untuk konfirmasi pengiriman per transaksi -->
                    <div class="modal fade" id="modalKirim<%= dt.getIdTransaksi()%>" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <!-- Header modal: judul dengan nomor transaksi -->
                                <div class="modal-header">
                                    <h6 class="modal-title fw-bold">Konfirmasi Pengiriman #<%= dt.getIdTransaksi()%></h6>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <!-- Form untuk proses pengiriman -->
                                <form action="Transaksi?action=proses_kirim" method="POST">
                                    <div class="modal-body">
                                        <!-- Kirim ID transaksi & ID sekolah ke servlet -->
                                        <input type="hidden" name="idTrx" value="<%= dt.getIdTransaksi()%>">
                                        <input type="hidden" name="idSekolah" value="<%= dt.getIdSekolah()%>">
                                        <div class="mb-3">
                                            <!-- Pilih jasa pengiriman -->
                                            <label class="form-label small fw-bold">Jasa Pengiriman</label>
                                            <select name="kurir" class="form-select" required>
                                                <option value="JNE">JNE Express</option>
                                                <option value="J&T">J&T Express</option>
                                                <option value="SiCepat">SiCepat</option>
                                                <option value="POS">Pos Indonesia</option>
                                            </select>
                                        </div>
                                        <!-- Input nomor resi -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold">Nomor Resi</label>
                                            <input type="text" name="noResi" class="form-control" placeholder="Masukkan nomor resi..." required>
                                        </div>
                                    </div>
                                    <!-- Footer modal: tombol submit -->
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-purple w-100">Konfirmasi & Kirim</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                        } // End If Grouping
                    } // End For Loop Utama
                } // End Else
            %>
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