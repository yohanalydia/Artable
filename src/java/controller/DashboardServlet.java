package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Produk;
import model.User;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/Dashboard"})
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Cek apakah yang login itu sekolah
        if (user == null || (!user.getRole().equals("SEKOLAH") && !user.getRole().equals("ADMIN"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (user.getRole().equals("SEKOLAH")) {
            try {
                int id = user.getIdUser();
                Produk db = new Produk(); // Untuk panggil fungsi .query()

                // 1. Hitung Pendapatan
                String sql1 = "SELECT SUM(dt.hargaSatuan * dt.qty) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND dt.status = 'Selesai'";
                Object hasil1 = db.query(sql1).get(0).get(0);
                double uang = (hasil1 != null) ? Double.parseDouble(hasil1.toString()) : 0;

                // 2. Hitung Karya, Siswa, Antrean, & Terjual (Pakai query COUNT)
                int karya = Integer.parseInt(db.query("SELECT COUNT(*) FROM produk p JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id).get(0).get(0).toString());
                int siswa = Integer.parseInt(db.query("SELECT COUNT(*) FROM seniman WHERE idUser = " + id).get(0).get(0).toString());
                int antrean = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND dt.status != 'Selesai'").get(0).get(0).toString());
                int laku = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND dt.status = 'Selesai'").get(0).get(0).toString());

                // 3. Data Pie Chart (Kategori)
                int fine = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND p.kategori = 'FINE_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());
                int digital = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND p.kategori = 'DIGITAL_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());
                int handmade = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk JOIN seniman s ON p.idSeniman = s.idSeniman WHERE s.idUser = " + id + " AND p.kategori = 'HANDMADE_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());

                // Kirim semua ke JSP
                request.setAttribute("totalPendapatan", String.format("%,.0f", uang).replace(",", "."));
                request.setAttribute("totalKarya", karya);
                request.setAttribute("totalSiswa", siswa);
                request.setAttribute("totalPesanan", antrean);
                request.setAttribute("totalTerjual", laku);
                request.setAttribute("categoryData", fine + "," + digital + "," + handmade);
                
                // Mengarahkan user ke dashboard.jsp
                request.getRequestDispatcher("views/dashboard.jsp").forward(request, response);
            } catch (Exception e) {
                response.getWriter().print("Error: " + e.getMessage());
            }
        } else {
            try {
                int id = user.getIdUser();
                Produk db = new Produk(); // Untuk panggil fungsi .query()

                // 1. Hitung Pendapatan
                String sql1 = "SELECT SUM(dt.hargaSatuan * dt.qty) FROM detail_transaksi dt WHERE dt.status = 'Selesai'";
                Object hasil1 = db.query(sql1).get(0).get(0);
                double uang = (hasil1 != null) ? Double.parseDouble(hasil1.toString()) : 0;

                // 2. Hitung Karya, Siswa, Antrean, & Terjual (Pakai query COUNT)
                int karya = Integer.parseInt(db.query("SELECT COUNT(*) FROM produk").get(0).get(0).toString());
                int siswa = Integer.parseInt(db.query("SELECT COUNT(*) FROM seniman").get(0).get(0).toString());
                int antrean = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt WHERE dt.status != 'Selesai'").get(0).get(0).toString());
                int laku = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt WHERE dt.status = 'Selesai'").get(0).get(0).toString());

                // 3. Data Pie Chart (Kategori)
                int fine = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk WHERE p.kategori = 'FINE_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());
                int digital = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk WHERE p.kategori = 'DIGITAL_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());
                int handmade = Integer.parseInt(db.query("SELECT COUNT(*) FROM detail_transaksi dt JOIN produk p ON dt.idProduk = p.idProduk WHERE p.kategori = 'HANDMADE_ART' AND dt.status = 'Selesai'").get(0).get(0).toString());

                // Kirim semua ke JSP
                request.setAttribute("totalPendapatan", String.format("%,.0f", uang).replace(",", "."));
                request.setAttribute("totalKarya", karya);
                request.setAttribute("totalSiswa", siswa);
                request.setAttribute("totalPesanan", antrean);
                request.setAttribute("totalTerjual", laku);
                request.setAttribute("categoryData", fine + "," + digital + "," + handmade);
                
                // Mengarahkan user ke dashboard.jsp
                request.getRequestDispatcher("views/dashboard.jsp").forward(request, response);
            } catch (Exception e) {
                response.getWriter().print("Error: " + e.getMessage());
            }
        }
    }
}
