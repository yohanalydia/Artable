package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.User;
import model.Pembeli;
import model.Sekolah;
import model.Cart;

@WebServlet(name = "authServlet", urlPatterns = {"/Auth"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class authServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String type = request.getParameter("type");

            // 1. Logika Logout
            if (request.getParameter("logout") != null) {
                request.getSession().invalidate();
                response.sendRedirect("Auth?msg=Logged Out");
                return;
            }

            // 2. Navigasi ke Halaman Register via Servlet
            if ("register".equals(type)) {
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }

            // 3. Navigasi ke halaman profil user
            if ("profil".equals(type)) {
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    response.sendRedirect("Auth");
                } else {
                    request.getRequestDispatcher("views/profil.jsp").forward(request, response);
                }
                return;
            }

            // 4. Navigasi ke halaman edit profil
            if ("editProfil".equals(type)) {
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    response.sendRedirect("Auth");
                } else {
                    request.getRequestDispatcher("/views/editProfil.jsp").forward(request, response);
                }
                return;
            }

            // 5. Default: Tampilkan halaman login
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // Kirim user ke halaman error atau kembali ke login dengan pesan
            response.sendRedirect("views/login.jsp?error=system_failure");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil parameter aksi dari request
        String action = request.getParameter("action");

        // Proses registrasi user
        if ("register".equals(action)) {
            handleRegister(request, response);

        // Update data profil user
        } else if ("updateProfil".equals(action)) {
            handleUpdate(request, response);

        // Ganti password user
        } else if ("changePass".equals(action)) {
            handleUpdatePass(request, response);

        // Proses login (default)
        } else {
            handleLogin(request, response);
        }

    }

    private void handleUpdatePass(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // 1. Jika password lama salah
        if (!u.getPassword().equals(oldPass)) {
            // Tambahkan action=changePass agar JavaScript di profil.jsp tahu harus buka modal
            response.sendRedirect("Auth?type=profil&action=changePass&error=Password lama salah!");
            return;
        }

        // 2. Jika konfirmasi password tidak cocok
        if (!newPass.equals(confirmPass)) {
            response.sendRedirect("Auth?type=profil&action=changePass&error=Konfirmasi password baru tidak cocok!");
            return;
        }

        // 3. Jika berhasil
        try {
            u = u.find("idUser", String.valueOf(u.getIdUser()));
            u.setPassword(newPass);
            u.update();
            session.setAttribute("user", u);
            response.sendRedirect("Auth?type=profil&msg=Password berhasil diganti!");
        } catch (Exception e) {
            response.sendRedirect("Auth?type=profil&action=changePass&error=Gagal update database");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        User userSession = (User) session.getAttribute("user");

        if (userSession == null) {
            response.sendRedirect("Auth");
            return;
        }

        try {
            // 1. Ambil data dari form
            int id = Integer.parseInt(request.getParameter("id"));
            String nama = request.getParameter("nama");
            String email = request.getParameter("email");
            String nomorTelepon = request.getParameter("nomorTelepon");
            String alamat = request.getParameter("alamat");
            String tipeRekening = request.getParameter("tipeRekening");
            String nomorRekening = request.getParameter("nomorRekening");

            // 2. Cari data user di database berdasarkan ID
            User userUpdate = new User().find("idUser", String.valueOf(id));

            if (userUpdate != null) {
                // Set data baru (kecuali username dan password)
                userUpdate.setNama(nama);
                userUpdate.setEmail(email);
                userUpdate.setNomorTelepon(nomorTelepon);
                userUpdate.setAlamat(alamat);

                if ("SEKOLAH".equals(userUpdate.getRole())) {
                    userUpdate.setTipeRekening(tipeRekening);
                    userUpdate.setNomorRekening(nomorRekening);
                }
                // 3. Logika Upload Foto Profil (Opsional jika ada input file "foto")
                Part filePart = request.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    // Tentukan path penyimpanan
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    String uploadPath = getServletContext().getRealPath("/") + "assets/fotoProfil";

                    // Buat folder jika belum ada
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    filePart.write(uploadPath + java.io.File.separator + fileName);

                    // Update URL gambar di objek user
                    userUpdate.setImageUrl("assets/fotoProfil/" + fileName);
                }

                // 4. Eksekusi Update ke Database
                userUpdate.update();

                // 5. UPDATE SESSION (Sangat Penting!)
                // Agar nama/foto di Navbar langsung berubah tanpa harus relogin
                session.setAttribute("user", userUpdate);

                response.sendRedirect("Auth?type=profil&msg=Profil berhasil diperbarui");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Auth?type=editProfil&error=Gagal memperbarui profil: " + e.getMessage());
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // Ambil data dari form register.jsp
        String nama = request.getParameter("nama");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String alamat = request.getParameter("alamat");
        String nomorTelepon = request.getParameter("nomorTelepon");
        String imageUrl = "assets/fotoProfil/default.jpg"; // Nilai default untuk user baru

        String tipeRekening = request.getParameter("tipeRekening");
        String nomorRekening = request.getParameter("nomorRekening");

        if (password == null || password.length() < 6) {
            request.getSession().setAttribute("errorMessage", "Pendaftaran gagal! Password harus minimal 6 karakter.");
            response.sendRedirect("views/login.jsp"); // atau balik ke register
            return;
        }

        if (!"SEKOLAH".equals(role) || tipeRekening == null || tipeRekening.trim().isEmpty()) {
            tipeRekening = null;
            nomorRekening = null;
        }

        User modelUser = new User();
        if (modelUser.find("username", username) != null || modelUser.find("email", email) != null) {
            request.setAttribute("error", "Username atau Email sudah terdaftar!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(nama, username, email, password, alamat, nomorTelepon, role, imageUrl, tipeRekening, nomorRekening);

        try {
            newUser.insert();

            // Ambil data yang baru disimpan untuk mendapatkan ID-nya
            User userTerdaftar = new User().find("username", username);

            // KHUSUS PEMBELI: Buat baris di tabel 'cart'
            if ("PEMBELI".equals(role) && userTerdaftar != null) {
                Cart newCart = new Cart();
                newCart.setIdUser(userTerdaftar.getIdUser());
                newCart.insert();
            }

            response.sendRedirect("Auth?msg=Registrasi Berhasil, Silahkan Login");
        } catch (Exception e) {
            request.setAttribute("error", "Gagal daftar: " + e.getMessage());
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User userBase = new User().find("email", email);

            if (userBase == null || !userBase.getPassword().equals(password)) {
                request.setAttribute("error", "Email atau Password salah!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                return;
            }

            // LOGIN BERHASIL
            HttpSession session = request.getSession();

            // Cek Role dan bungkus ke objek yang sesuai
            if ("PEMBELI".equals(userBase.getRole())) {
                // Gunakan constructor Pembeli (Database version)
                Pembeli pembeli = new Pembeli(
                        userBase.getIdUser(), userBase.getNama(), userBase.getUsername(),
                        userBase.getEmail(), userBase.getPassword(), userBase.getAlamat(),
                        userBase.getNomorTelepon(), userBase.getImageUrl()
                );
                session.setAttribute("user", pembeli);
            } else if ("SEKOLAH".equals(userBase.getRole())) {
                // Gunakan constructor Sekolah (Database version)
                String tipe = (userBase.getTipeRekening() != null) ? userBase.getTipeRekening() : "";
                String nomor = (userBase.getNomorRekening() != null) ? userBase.getNomorRekening() : "";
                Sekolah sekolah = new Sekolah(
                        userBase.getIdUser(),
                        userBase.getNama(),
                        userBase.getUsername(),
                        userBase.getEmail(),
                        userBase.getPassword(),
                        userBase.getAlamat(),
                        userBase.getNomorTelepon(),
                        userBase.getImageUrl(),
                        tipe, // Ambil dari userBase hasil toModel
                        nomor // Ambil dari userBase hasil toModel
                );
                session.setAttribute("user", sekolah);
            } else {
                session.setAttribute("user", userBase);
            }

            response.sendRedirect("Home");

        } catch (Exception e) {
            // Cetak error ke console untuk debugging
            e.printStackTrace();

            // Kirim pesan error ke halaman login agar user tahu ada masalah sistem
            request.setAttribute("error", "Terjadi kesalahan sistem: " + e.getMessage());
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
