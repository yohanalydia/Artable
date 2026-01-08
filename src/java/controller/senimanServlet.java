package controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Produk;
import model.Seniman;
import model.User;

@WebServlet(name = "SenimanServlet", urlPatterns = {"/SenimanServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class senimanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Proteksi: Pastikan hanya user login yang bisa akses
        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        if ("insert".equals(action)) {
            handleInsert(request, response, user);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        }
    }

    private void handleInsert(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        try {
            // 1. Ambil Data Form
            String nama = request.getParameter("nama");
            String tglLahirStr = request.getParameter("tanggalLahir");
            String jenisDisabilitas = request.getParameter("jenisDisabilitas");
            String jenisKelamin = request.getParameter("jenisKelamin");
            String tentangSaya = request.getParameter("tentangSaya");
            String tanggalLahir = request.getParameter("tanggalLahir");

            // 2. Proses Upload Foto Profil Seniman
            Part filePart = request.getPart("foto");
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            // Simpan di folder web/assets/fotoSeniman
            String uploadPath = getServletContext().getRealPath("/") + "assets/fotoSeniman";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + fileName);
            String imageUrl = "assets/fotoSeniman/" + fileName;

            // 3. Masukkan ke Database
            Seniman baru = new Seniman();
            baru.setNama(nama);
            baru.setTanggalLahir(tanggalLahir);
            baru.setJenisDisabilitas(jenisDisabilitas);
            baru.setJenisKelamin(jenisKelamin);
            baru.setTentangSaya(tentangSaya);
            baru.setImageUrl(imageUrl);

            // Relasi menggunakan idUser (Sekolah yang login)
            baru.setIdUser(user.getIdUser());

            baru.insert();

            response.sendRedirect("Produk?menu=myseniman&msg=Seniman Berhasil Didaftarkan");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Produk?menu=myseniman&error=Gagal: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("idSeniman");
        if (id != null) {
            try {
                Seniman s = new Seniman();
                s.setId(Integer.parseInt(id));
                s.delete();

                response.sendRedirect("Produk?menu=myseniman&msg=Seniman Berhasil Dihapus");
            } catch (Exception e) {
                // Log error ke console untuk debugging
                System.err.println("Gagal menghapus seniman: " + e.getMessage());
                e.printStackTrace();

                // Redirect dengan pesan error (biasanya karena relasi database/FK)
                response.sendRedirect("Produk?menu=myseniman&error=Gagal menghapus seniman. Pastikan seniman tidak memiliki karya yang terdaftar.");
            }
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            // 1. Ambil ID dan cari data lama
            int idSeniman = Integer.parseInt(request.getParameter("idSeniman"));
            Seniman s = new Seniman().find("idSeniman", String.valueOf(idSeniman));

            // 2. Tangkap data teks dari form
            String nama = request.getParameter("nama");
            String tanggalLahir = request.getParameter("tanggalLahir");
            String jenisKelamin = request.getParameter("jenisKelamin");
            String jenisDisabilitas = request.getParameter("jenisDisabilitas");
            String tentangSaya = request.getParameter("tentangSaya");

            // 3. Proses Foto (Logika: Jika upload baru pakai yang baru, jika tidak pakai yang lama)
            Part filePart = request.getPart("foto");
            String imageUrl = s.getImageUrl(); // default foto lama

            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/") + "assets/fotoSeniman";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Bersihkan nama file dari spasi agar URL tidak rusak
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = "assets/fotoSeniman/" + fileName;

                // Optional: Hapus foto lama di folder biar gak numpuk
                File oldFile = new File(getServletContext().getRealPath("/") + s.getImageUrl());
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            // 4. Update Objek
            s.setId(idSeniman);
            s.setNama(nama);
            s.setTanggalLahir(tanggalLahir);
            s.setJenisKelamin(jenisKelamin);
            s.setJenisDisabilitas(jenisDisabilitas);
            s.setTentangSaya(tentangSaya);
            s.setImageUrl(imageUrl);

            s.update();
            response.sendRedirect("Produk?menu=myseniman&msg=Profil Seniman Berhasil Diperbarui");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Produk?menu=myseniman&error=Gagal Update: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String menu = request.getParameter("menu");

        try {
            if ("edit".equals(menu)) {
                String id = request.getParameter("id");
                if (id != null) {
                    // Ambil data seniman tunggal berdasarkan ID
                    Seniman s = new Seniman().find("idSeniman", id);

                    // Titipkan objek seniman ke request
                    request.setAttribute("s", s);

                    // Forward ke file editSeniman.jsp (Pastikan letak filenya benar)
                    request.getRequestDispatcher("views/editSeniman.jsp").forward(request, response);
                } else {
                    response.sendRedirect("Produk?menu=myseniman");
                }
            } else if ("view".equals(menu)) {
                String id = request.getParameter("id");

                // 1. Ambil data seniman
                Seniman s = new Seniman().find("idSeniman", id);

                if (s != null) {
                    // 2. Ambil data sekolah (User) berdasarkan idUser yang ada di profil seniman
                    User sekolah = new User().find("idUser", String.valueOf(s.getIdUser()));

                    request.setAttribute("s", s);

                    // 3. Titipkan nama sekolahnya ke JSP
                    if (sekolah != null) {
                        request.setAttribute("namaSekolah", sekolah.getNama());
                    } else {
                        request.setAttribute("namaSekolah", "Sekolah Tidak Terdaftar");
                    }
                    
                    // 4. Ambil daftar karya milik seniman ini
                    Produk p = new Produk();
                    p.where("idSeniman = " + String.valueOf(id));
                    ArrayList<Produk> listKarya = p.get();
                    request.setAttribute("listKarya", listKarya);
                }

                // Forward ke halaman yang berisi detail tadi
                request.getRequestDispatcher("views/detailSeniman.jsp").forward(request, response);
            } else if ("detailSekolah".equals(menu)) {
                String id = request.getParameter("id"); // ID Sekolah
                if (id == null || id.isEmpty()) {
                    response.sendRedirect("Home?error=invalid_id");
                    return;
                }

                // 2. Ambil Profil Sekolah dari tabel User
                // Kita cari user yang punya idUser tersebut
                User sekolah = new User().find("idUser", id);

                if (sekolah == null) {
                    response.sendRedirect("Home?error=school_not_found");
                    return;
                }

                // 3. Ambil Daftar Seniman yang bernaung di bawah sekolah tersebut
                // Filter berdasarkan idUser (foreign key di tabel seniman)
                Seniman sModel = new Seniman();
                sModel.where("idUser = '" + id + "'");
                ArrayList<Seniman> listSeniman = sModel.get();

                // 4. Masukkan data ke dalam Request Attribute agar bisa dibaca JSP
                request.setAttribute("sekolah", sekolah);
                request.setAttribute("listSeniman", listSeniman);

                // 5. Lempar (Forward) ke halaman detailSekolah.jsp
                request.getRequestDispatcher("views/detailSekolah.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Cetak error ke console untuk debugging
            System.err.println("Error di doGet Seniman: " + e.getMessage());
            e.printStackTrace();

            // Redirect ke halaman sebelumnya atau home jika terjadi kegagalan database
            response.sendRedirect("Produk?menu=myseniman&error=Terjadi kesalahan sistem saat memuat data.");
        }
    }
}
