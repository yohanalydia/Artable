package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.*;

@WebServlet(name = "TransaksiServlet", urlPatterns = {"/Transaksi"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class TransaksiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Proteksi: Cek apakah user sudah login
        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        // 2. Gunakan Try-Catch untuk menangani error database di dalam method tampilkan
        try {
            if (action == null || "view".equals(action)) {
                String role = user.getRole();
                if ("PEMBELI".equals(role)) {
                    tampilkanRiwayat(request, response);
                } else if ("SEKOLAH".equals(role)) {
                    tampilkanPesananMasuk(request, response);
                }
            }
        } catch (Exception e) {
            // Log error ke console
            System.err.println("Error di TransaksiServlet (doGet): ");
            e.printStackTrace();

            // Redirect ke Home dengan info error
            response.sendRedirect("Home?error=transaction_view_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         // Ambil parameter aksi dari request
        String action = request.getParameter("action");

        // Proses checkout pesanan
        if (action != null && "checkout".equals(action)) {
            prosesCheckout(request, response);

            // Batalkan pesanan
        } else if ("cancel_order".equals(action)) {
            prosesCancel(request, response);

            // Upload bukti pembayaran
        } else if ("upload_bukti".equals(action)) {
            handleUploadBukti(request, response);

            // Verifikasi pembayaran
        } else if ("verifikasi_pembayaran".equals(action)) {
            handleVerifikasiPembayaran(request, response);

            // Proses pengiriman pesanan
        } else if ("proses_kirim".equals(action)) {
            handleProsesKirim(request, response);

            // Selesaikan pesanan
        } else if ("selesaikan_pesanan".equals(action)) {
            prosesSelesai(request, response);
        }
    }

    // --- DAFTAR TRANSAKSI (RIWAYAT) ---
    private void tampilkanRiwayat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Validasi Session dan Role
        if (user == null || !"PEMBELI".equals(user.getRole())) {
            response.sendRedirect("Auth");
            return;
        }

        try {
            // 1. Ambil semua transaksi milik pembeli
            Transaksi tModel = new Transaksi();
            tModel.where("idPembeli = " + user.getIdUser());
            tModel.addQuery("ORDER BY idTransaksi DESC");
            ArrayList<Transaksi> listTrx = tModel.get();

            // 2. Ambil SEMUA detail transaksi yang berkaitan dengan transaksi pembeli ini
            // Kita bisa gunakan subquery agar hanya mengambil detail milik pembeli ini saja
            DetailTransaksi dtModel = new DetailTransaksi();
            dtModel.where("idTransaksi IN (SELECT idTransaksi FROM transaksi WHERE idPembeli = " + user.getIdUser() + ")");
            ArrayList<DetailTransaksi> allDetails = dtModel.get();

            // 3. Kirim kedua list ke JSP
            request.setAttribute("listTransaksi", listTrx);
            request.setAttribute("listAllDetails", allDetails);

            request.getRequestDispatcher("views/riwayatTransaksi.jsp").forward(request, response);
        } catch (Exception e) {
            // Cetak log error untuk debugging di NetBeans
            System.err.println("Error saat memuat riwayat transaksi: " + e.getMessage());
            e.printStackTrace();

            // Redirect ke Home dengan parameter error agar user tahu ada masalah
            response.sendRedirect("Home?error=view_history_failed");
        }
    }

    // --- PROSES CHECKOUT ---
    private void prosesCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Cart cartModel = new Cart();
        Cart cart = cartModel.find("idUser", String.valueOf(user.getIdUser()));

        CartItem ci = new CartItem();
        ci.where("idCart = '" + cart.getIdCart() + "'");
        ArrayList<CartItem> daftarProduk = ci.get();

        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        if (cart == null || daftarProduk == null || daftarProduk.isEmpty()) {
            session.setAttribute("cartError", "Keranjang belanja Anda kosong.");
            response.sendRedirect("CartServlet?action=view");
            return;
        }

        String metodePembayaran = "Bank Transfer";
        String alamatPengiriman = request.getParameter("alamatPengiriman");

        if (alamatPengiriman == null || alamatPengiriman.trim().isEmpty()) {
            alamatPengiriman = user.getAlamat();
        }

        try {
            // 1. Simpan Transaksi
            Transaksi t = new Transaksi();
            t.setIdPembeli(user.getIdUser());
            t.setTanggalTransaksi(java.time.LocalDateTime.now());
            t.setMetodePembayaran(metodePembayaran);
            t.setAlamatPengiriman(alamatPengiriman);

            // Perhitungan Ongkir dan Total Pembelian
            ArrayList<Integer> listSekolah = new ArrayList<>();
            double totalHarga = 0;
            for (CartItem item : daftarProduk) {
                Produk p = new Produk().find("idProduk", String.valueOf(item.getIdProduk()));
                Seniman s = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));
                int idSekolah = s.getIdUser();
                if (!listSekolah.contains(idSekolah)) {
                    listSekolah.add(idSekolah);
                }
                totalHarga += item.getQuantity() * p.getHarga();
            }

            double biayaPerSekolah = 20000;
            double totalOngkir = listSekolah.size() * biayaPerSekolah;

            t.setTotalBayar(totalHarga + totalOngkir);

            // Eksekusi insert (Method void)
            t.insert();

            // 2. AMBIL ID TERAKHIR
            int idTransaksiBaru = 0;

            // Gunakan method where() untuk filter user
            t.where("idPembeli = '" + user.getIdUser() + "'");

            // Gunakan addQuery() untuk mengurutkan dari yang terbaru (ID terbesar)
            t.addQuery("ORDER BY idTransaksi DESC LIMIT 1");

            // Panggil get() yang mengembalikan ArrayList<Transaksi>
            ArrayList<Transaksi> list = t.get();

            if (list != null && !list.isEmpty()) {
                // Ambil index 0 karena LIMIT 1
                idTransaksiBaru = list.get(0).getIdTransaksi();
            }

            if (idTransaksiBaru > 0) {
                // 3. Simpan Detail Transaksi (Looping) dan Update Stok Produk
                for (CartItem item : daftarProduk) {
                    Produk p = new Produk().find("idProduk", String.valueOf(item.getIdProduk()));
                    p.setStok(p.getStok() - item.getQuantity());
                    p.update();

                    DetailTransaksi dt = new DetailTransaksi();
                    dt.setIdTransaksi(idTransaksiBaru);
                    Seniman s = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));
                    int idSekolah = s.getIdUser();
                    dt.setIdProduk(p.getIdProduk());
                    dt.setIdSekolah(idSekolah);
                    dt.setQty(item.getQuantity());
                    dt.setHargaSatuan(p.getHarga());

                    dt.insert(); // Insert detail (void)
                }

                // 4. Reset/Bersihkan Keranjang
                for (int i = daftarProduk.size() - 1; i >= 0; i--) {
                    CartItem item = daftarProduk.get(i);
                    item.delete(); // Ini akan menghapus baris di tabel cart_item
                    daftarProduk.remove(i); // Ini menghapus dari list di Java
                }

                // 5. Kirimkan Notifikasi ke Sekolah Tujuan
                for (Integer idSekolahTujuan : listSekolah) {
                    Notifikasi n = new Notifikasi();
                    n.setIdUser(idSekolahTujuan);
                    n.setJudul("Pesanan Baru Masuk!");
                    n.setPesan("Ada pesanan baru dengan Nota #" + idTransaksiBaru + ". Silakan cek stok dan tunggu pembayaran.");
                    n.updateStatus("unread");
                    n.setWaktu(java.time.LocalDateTime.now());
                    n.insert();
                }

                // 6. Kirimkan Notifikasi pesanan berhasil dicheckout ke user saat ini
                Notifikasi nPembeli = new Notifikasi();
                nPembeli.setIdUser(user.getIdUser()); // ID Pembeli yang sedang login
                nPembeli.setJudul("Checkout Berhasil!");
                nPembeli.setPesan("Pesanan Anda dengan Nota #" + idTransaksiBaru + " telah berhasil dibuat. Segera lakukan pembayaran agar pesanan dapat diproses.");
                nPembeli.updateStatus("unread");
                nPembeli.setWaktu(java.time.LocalDateTime.now());
                nPembeli.insert();

                session.removeAttribute("cart");
                response.sendRedirect("Home?orderStatus=success");
            } else {
                throw new Exception("Gagal sinkronisasi ID Transaksi.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("cartError", "Error: " + e.getMessage());
            response.sendRedirect("CartServlet?action=view");
        }
    }

    private void handleUploadBukti(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idTrx = request.getParameter("idTrx");
        String idSekolah = request.getParameter("idSekolah");
        Part filePart = request.getPart("fileBukti");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = "BUKTI_" + idTrx + "_" + idSekolah + "_" + System.currentTimeMillis() + ".jpg";
            String uploadPath = getServletContext().getRealPath("/") + "assets/bukti_transfer";

            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + java.io.File.separator + fileName);

            // Update SEMUA item di detail_transaksi yang memiliki idTrx dan idSekolah yang sama
            // Karena satu sekolah bisa punya banyak produk dalam satu nota
            try {
                DetailTransaksi dtModel = new DetailTransaksi();
                // Cari semua produk dari sekolah yang sama dalam satu transaksi ini
                dtModel.where("idTransaksi = " + idTrx + " AND idSekolah = " + idSekolah);
                ArrayList<DetailTransaksi> items = dtModel.get();

                for (DetailTransaksi item : items) {
                    item.setBuktiTransfer("assets/bukti_transfer/" + fileName);
                    item.updateStatus("Menunggu Verifikasi"); // Update status per produk/per sekolah
                    item.update();
                }

                // Kirimkan notifikasi ke sekolah
                Notifikasi n = new Notifikasi();
                n.setIdUser(Integer.parseInt(idSekolah));
                n.setJudul("Bukti Transfer Baru");
                n.setPesan("Pembeli telah mengunggah bukti pembayaran untuk Nota #" + idTrx + ". Silakan verifikasi.");
                n.updateStatus("unread");
                n.setWaktu(java.time.LocalDateTime.now());
                n.insert();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("Transaksi?action=view");
    }

    private void prosesCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idTrx = request.getParameter("idTrx");
        String idSekolah = request.getParameter("idSekolah");

        try {
            DetailTransaksi dtModel = new DetailTransaksi();
            // Cari semua item dari sekolah yang sama dalam satu transaksi
            dtModel.where("idTransaksi = " + idTrx + " AND idSekolah = " + idSekolah);
            ArrayList<DetailTransaksi> items = dtModel.get();

            // Update Status dan Stok
            for (DetailTransaksi item : items) {
                item.updateStatus("Dibatalkan");
                item.update();

                Produk p = new Produk().find("idProduk", String.valueOf(item.getIdProduk()));
                p.setStok(p.getStok() + item.getQty());
                p.update();
            }
            Transaksi t = new Transaksi().find("idTransaksi", idTrx);
            Notifikasi n = new Notifikasi();
            HttpSession sess = request.getSession();
            User u = (User) sess.getAttribute("user");

            if ("PEMBELI".equals(u.getRole())) {
                n.setIdUser(Integer.parseInt(idSekolah)); // Kirim ke Sekolah
            } else {
                n.setIdUser(t.getIdPembeli()); // Kirim ke Pembeli
            }

            n.setJudul("Pesanan Dibatalkan");
            n.setPesan("Pesanan #" + idTrx + " telah dibatalkan.");
            n.updateStatus("unread");
            n.setWaktu(java.time.LocalDateTime.now());
            n.insert();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("Transaksi?action=view");
    }

    private void tampilkanPesananMasuk(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Cek login dan role
        if (user == null || !"SEKOLAH".equals(user.getRole())) {
            response.sendRedirect("Auth");
            return;
        }

        try {
            // Ambil semua detail transaksi yang tujuannya ke sekolah ini
            DetailTransaksi dtModel = new DetailTransaksi();
            dtModel.where("idSekolah = " + user.getIdUser());
            dtModel.addQuery("ORDER BY idDetail DESC");
            ArrayList<DetailTransaksi> list = dtModel.get();

            request.setAttribute("daftarPesanan", list);
            request.getRequestDispatcher("views/pesananMasuk.jsp").forward(request, response);

        } catch (Exception e) {
            // Cetak error ke console NetBeans
            System.err.println("Error di tampilkanPesananMasuk: " + e.getMessage());
            e.printStackTrace();

            // Lempar balik ke Home/Dashboard dengan pesan error
            response.sendRedirect("Home?error=view_orders_failed");
        }
    }

    private void handleVerifikasiPembayaran(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idTrx = request.getParameter("idTrx");
        String idSekolah = request.getParameter("idSekolah");

        try {
            DetailTransaksi dtModel = new DetailTransaksi();
            // Cari semua item dari sekolah yang sama dalam satu transaksi
            dtModel.where("idTransaksi = " + idTrx + " AND idSekolah = " + idSekolah);
            ArrayList<DetailTransaksi> items = dtModel.get();

            // Update Status dan Stok
            for (DetailTransaksi item : items) {
                item.updateStatus("Diproses");
                item.update();
            }

            // Kirimkan notifikasi ke user
            Transaksi t = new Transaksi().find("idTransaksi", idTrx);
            User sekolah = new User().find("idUser", idSekolah);

            Notifikasi n = new Notifikasi();
            n.setIdUser(t.getIdPembeli());
            n.setJudul("Pembayaran Diterima");
            n.setPesan("Pembayaran Anda untuk Nota #" + idTrx + " pada sekolah " + sekolah.getNama() + " telah diverifikasi. Sekolah sedang menyiapkan produk Anda.");
            n.updateStatus("unread");
            n.setWaktu(java.time.LocalDateTime.now());
            n.insert();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("Transaksi");
    }

    private void handleProsesKirim(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idTrx = request.getParameter("idTrx");
        String noResi = request.getParameter("noResi");
        String kurir = request.getParameter("kurir");
        String idSekolah = request.getParameter("idSekolah");

        try {
            DetailTransaksi dtModel = new DetailTransaksi();
            // Ambil semua produk milik sekolah ini dalam satu nota
            dtModel.where("idTransaksi = " + idTrx + " AND idSekolah = " + idSekolah);
            ArrayList<DetailTransaksi> items = dtModel.get();

            for (DetailTransaksi item : items) {
                item.setNoResi(noResi);
                item.setKurir(kurir);
                item.updateStatus("Dikirim");
                item.update();
            }

            // Kirim notifikasi ke pembeli
            Transaksi t = new Transaksi().find("idTransaksi", idTrx);
            User sekolah = new User().find("idUser", idSekolah);

            Notifikasi n = new Notifikasi();
            n.setIdUser(t.getIdPembeli());
            n.setJudul("Pesanan Dikirim");
            n.setPesan("Karya yang Anda beli di nota #" + idTrx + " pada sekolah " + sekolah.getNama() + " telah dikirim via " + kurir + " (Resi: " + noResi + ")");
            n.updateStatus("unread");
            n.setWaktu(java.time.LocalDateTime.now());
            n.insert();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("Transaksi");
    }

    private void prosesSelesai(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idTrx = request.getParameter("idTrx");
            String idSekolah = request.getParameter("idSekolah");

            DetailTransaksi dtModel = new DetailTransaksi();
            dtModel.where("idTransaksi = " + idTrx + " AND idSekolah = " + idSekolah);
            ArrayList<DetailTransaksi> items = dtModel.get();

            for (DetailTransaksi item : items) {
                item.updateStatus("Selesai");
                item.update();
            }

            // Trigger Notifikasi
            Notifikasi n = new Notifikasi();
            n.setIdUser(Integer.parseInt(idSekolah));
            n.setJudul("Pesanan Selesai");
            n.setPesan("Pembeli telah menerima pesanan untuk nota #" + idTrx + ".");
            n.updateStatus("unread");
            n.setWaktu(java.time.LocalDateTime.now());
            n.insert();

            response.sendRedirect("Transaksi?action=view&msg=OrderCompleted");

        } catch (Exception e) {
            System.err.println("Error prosesSelesai: " + e.getMessage());
            response.sendRedirect("Transaksi?action=view&error=complete_failed");
        }
    }
}
