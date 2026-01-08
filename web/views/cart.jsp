<%@page import="model.Produk"%>
<%@page import="model.Notifikasi"%>
<%@page import="model.Seniman"%>
<%@page import="model.User"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart - Artable</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <!-- GOOGLE FONTS -->
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background: #f6f7fb;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }
            .topbar {
                font-size: 14px;
                background: #eef1f8; /* Warna abu-abu kebiruan agar tidak transparan */
                color: #333;
            }
            .h-custom {
                min-height: 80vh;
                padding-bottom: 50px;
            }
            .card-registration {
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            }
            input[type=number]::-webkit-inner-spin-button,
            input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
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
                        <a href="CartServlet?action=view" class="text-danger fw-bold"><i class="bi bi-cart fs-5"></i></a>
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

        <section class="h-custom pt-5" style="background-color: #d2c9ff;">
            <div class="container py-5 h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-12">
                        <div class="card card-registration card-registration-2" style="border-radius: 15px;">
                            <div class="card-body p-0">
                                <div class="row g-0"> 
                                    <%
                                        ArrayList<CartItem> items = (ArrayList<CartItem>) request.getAttribute("cart");
                                        double subtotal = (items != null) ? (double) request.getAttribute("subtotal") : 0;
                                    %>

                                    <div class="col-lg-8 p-4 p-md-5 bg-white" style="border-radius: 15px 0 0 15px;">

                                        <%-- PESAN ERROR STOK --%>
                                        <% if (session.getAttribute("cartError") != null) {%>
                                        <div class="alert alert-warning alert-dismissible fade show py-2 small" role="alert">
                                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                            <%= session.getAttribute("cartError")%>
                                            <button type="button" class="btn-close small" data-bs-dismiss="alert" aria-label="Close" style="padding: 0.75rem;"></button>
                                        </div>
                                        <%
                                            // Hapus pesan setelah ditampilkan agar tidak muncul terus saat refresh
                                            session.removeAttribute("cartError");
                                        %>
                                        <% }%>
                                        <div class="d-flex justify-content-between align-items-center mb-5">
                                            <h1 class="fw-bold mb-0 text-black">Shopping Cart</h1>
                                            <h6 class="mb-0 text-muted"><%= items.size()%> items</h6>
                                        </div>
                                        <hr class="my-4">

                                        <% if (items.isEmpty()) { %>
                                        <div class="text-center py-5">
                                            <h5 class="text-muted">Your cart is empty.</h5>
                                        </div>
                                        <% } else {
                                            for (CartItem ci : items) {
                                                Produk p = new Produk().find("idProduk", String.valueOf(ci.getIdProduk()));
                                        %>
                                        <div class="row mb-4 d-flex justify-content-between align-items-center">
                                            <div class="col-md-2">
                                                <img src="<%= p.getImageUrl()%>" class="img-fluid rounded-3" alt="<%= p.getNama()%>">
                                            </div>
                                            <div class="col-md-3">
                                                <h6 class="text-muted small"><%= p.getKategori()%></h6>
                                                <h6 class="text-black mb-0"><%= p.getNama()%></h6>
                                            </div>
                                            <div class="col-md-3 d-flex justify-content-center align-items-center">
                                                <a href="CartServlet?action=update&idItem=<%= ci.getIdCartItem()%>&op=min" 
                                                   class="btn btn-link px-2 text-dark">
                                                    <i class="bi bi-dash-circle"></i>
                                                </a>

                                                <input type="number" readonly class="form-control form-control-sm text-center mx-2" 
                                                       value="<%= ci.getQuantity()%>" style="width: 50px;" />

                                                <a href="CartServlet?action=update&idItem=<%= ci.getIdCartItem()%>&op=add" 
                                                   class="btn btn-link px-2 text-dark">
                                                    <i class="bi bi-plus-circle"></i>
                                                </a>
                                            </div>
                                            <div class="col-md-3">
                                                <h6 class="mb-0">Rp<%= String.format("%,.0f", p.getHarga() * ci.getQuantity())%></h6>
                                            </div>
                                            <div class="col-md-1 text-end">
                                                <form action="CartServlet" method="POST" onsubmit="return confirm('Remove this item?')">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="idItem" value="<%= ci.getIdCartItem()%>">

                                                    <button type="submit" class="btn btn-link text-danger p-0 border-0">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                        <hr class="my-4">
                                        <% }
                                            }%>

                                        <div class="pt-5">
                                            <h6 class="mb-0">
                                                <a href="Produk?menu=shop" class="text-body text-decoration-none">
                                                    <i class="bi bi-arrow-left me-2"></i>Back to shop
                                                </a>
                                            </h6>
                                        </div>
                                    </div> 

                                    <div class="col-lg-4 bg-light p-4 p-md-5" style="border-radius: 0 15px 15px 0;">
                                        <h3 class="fw-bold mb-5 mt-2 pt-1">Summary</h3>
                                        <hr class="my-4">

                                        <div class="d-flex justify-content-between mb-4">
                                            <h5 class="text-uppercase">Total Items</h5>
                                            <h5><%= items.size()%></h5>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4">
                                            <h5 class="text-uppercase">Subtotal</h5>
                                            <h5>Rp<%= String.format("%,.0f", subtotal)%></h5>
                                        </div>

                                        <h5 class="text-uppercase mb-3">Shipping</h5>
                                        <div class="mb-4 pb-2">
                                            <select class="form-select">
                                                <option value="20000">Standard Delivery (Per School) - Rp20.000</option>
                                            </select>
                                        </div>

                                        <%
                                            ArrayList<Integer> uniqueSchools = new ArrayList<>(); // List untuk simpan ID Sekolah unik

                                            if (items != null && !items.isEmpty()) {
                                                // Hitung jumlah sekolah unik
                                                for (CartItem ci : items) {
                                                    Produk p = new Produk().find("idProduk", String.valueOf(ci.getIdProduk()));
                                                    Seniman s = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));
                                                    int idSekolah = s.getIdUser();
                                                    if (!uniqueSchools.contains(idSekolah)) {
                                                        uniqueSchools.add(idSekolah);
                                                    }
                                                }
                                            }

                                            double biayaPerSekolah = 20000; // Tentukan biaya flat per sekolah
                                            double totalOngkir = uniqueSchools.size() * biayaPerSekolah;
                                            double grandTotal = subtotal + totalOngkir;
                                        %>

                                        <hr class="my-4">
                                        <div class="d-flex justify-content-between mb-5">
                                            <h5 class="text-uppercase">Total price</h5>
                                            <h5 class="fw-bold text-success">Rp<%= String.format("%,.0f", grandTotal)%></h5>
                                        </div>

                                        <form action="Transaksi?action=checkout" method="POST">
                                            <button type="submit" class="btn btn-dark w-100">Checkout</button>
                                        </form>
                                    </div> 
                                </div> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

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