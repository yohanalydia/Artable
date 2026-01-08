package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Notifikasi;
import model.User;

@WebServlet(name = "NotifikasiServlet", urlPatterns = {"/Notifikasi"})
public class NotifikasiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Proteksi Login
        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        try {
            Notifikasi nModel = new Notifikasi();

            // 1. Pembersihan notifikasi lama (Maintenance)
            String sqlClean = "DELETE FROM notifikasi WHERE waktu < DATE_SUB(NOW(), INTERVAL 30 DAY)";
            nModel.executeCustom(sqlClean);

            // 2. Ambil data notifikasi milik user saat ini
            nModel.where("idUser = " + user.getIdUser());
            nModel.addQuery("ORDER BY idNotifikasi DESC");
            ArrayList<Notifikasi> listNotif = nModel.get();

            // 3. Kirim ke JSP
            request.setAttribute("listNotif", listNotif);
            request.getRequestDispatcher("views/notifikasi.jsp").forward(request, response);

        } catch (Exception e) {
            // Log error di console NetBeans untuk pengecekan
            System.err.println("Error pada NotifikasiServlet: " + e.getMessage());
            e.printStackTrace();

            // Kirim user kembali ke Home dengan pesan error
            response.sendRedirect("Home?error=failed_to_load_notif");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil parameter idNotif dari AJAX
        String idNotif = request.getParameter("idNotif");

        if (idNotif != null) {
            try {
                // Cari data notifikasi berdasarkan ID
                Notifikasi n = new Notifikasi().find("idNotifikasi", idNotif);

                // Cek apakah data ada dan statusnya memang masih 'unread'
                if (n != null && "unread".equals(n.getStatus())) {
                    n.updateStatus("read");
                    n.update(); // Update status ke database

                    // Berikan respon sukses ke AJAX agar JS tahu proses berhasil
                    response.getWriter().write("success");
                }
            } catch (Exception e) {
                // Cetak error ke console server
                System.err.println("Gagal update status notifikasi: " + e.getMessage());
                e.printStackTrace();

                // Kirim status error ke AJAX agar browser tidak bingung
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}
